//
//  KeyboardViewController.swift
//  Often
//
//  Created by Luc Succes on 12/10/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

enum AutoPeriodState {
    case NoSpace
    case FirstSpace
}

/// Controller for Standard Keyboard View
class KeyboardViewController: UIViewController {
    var textProcessor: TextProcessingManager
    let locale: Language = .English
    var keysContainerView: TouchRecognizerView!
    var layout: KeyboardLayout
    var currentPage: Int = 0
    var layoutEngine: KeyboardLayoutEngine?
    var lastLayoutBounds: CGRect?
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?
    // state tracking during shift tap
    var shiftWasMultitapped: Bool = false
    var shiftStartingState: ShiftState?
    var keyWithDelayedPopup: KeyboardKeyButton?
    var popupDelayTimer: NSTimer?
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceStartTime: CFAbsoluteTime!
    var firstWordQuickDeleted: Bool = false
    var autoPeriodState: AutoPeriodState = .NoSpace
    var constraintsAdded: Bool = false
    var collapsed: Bool = false
    var shouldSetupKeysOnLayoutChange: Bool = false
    
    var backspaceActive: Bool {
        return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
    }
    var shiftState: ShiftState {
        didSet {
            updateKeyboardLetterCases()
        }
    }
    var allKeys: [KeyboardKeyButton] {
        get {
            var keys = [KeyboardKeyButton]()
            for page in layout.pages {
                for rowKeys in page.rows {
                    for key in rowKeys {
                        if let keyView = layoutEngine?.viewForKey(key) {
                            keys.append(keyView as KeyboardKeyButton)
                        }
                    }
                }
            }
            return keys
        }
    }

    init(textProcessor aTextProcessor: TextProcessingManager) {
        textProcessor = aTextProcessor

        keysContainerView = TouchRecognizerView()
        keysContainerView.backgroundColor = DefaultTheme.keyboardBackgroundColor

        shiftState = .Enabled

        if let defaultLayout = KeyboardLayouts[locale] {
            layout = defaultLayout
        } else {
            layout = DefaultKeyboardLayout
        }

        super.init(nibName: nil, bundle: nil)

        view.addSubview(keysContainerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func heightForOrientation(orientation: UIInterfaceOrientation, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad

        //TODO: hardcoded stuff
        let actualScreenWidth = (UIScreen.mainScreen().nativeBounds.size.width / UIScreen.mainScreen().nativeScale)
        let canonicalPortraitHeight = (isPad ? CGFloat(264) : CGFloat(orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216))
        let canonicalLandscapeHeight = (isPad ? CGFloat(352) : CGFloat(162))
        let topBannerHeight: CGFloat = withTopBanner ? 100 : 0.0

        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight) + topBannerHeight
    }

    override func viewDidLayoutSubviews() {
        if view.bounds == CGRectZero {
            return
        }

        let keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: false)
        keysContainerView.frame = CGRectMake(0, CGRectGetHeight(view.frame) - keyboardHeight, view.bounds.width, keyboardHeight)
        setupLayout()
    }

    func setupLayout() {
        if !constraintsAdded {
            layoutEngine = KeyboardLayoutEngine(model: layout, superview: keysContainerView, layoutConstants: LayoutConstants.self)
            layoutEngine?.containerView = view.superview
            setPage(0)
            updateKeyCaps(shiftState.lettercase())
            constraintsAdded = true
        }
        updateLayout()
        shouldSetupKeysOnLayoutChange = false
    }

    func updateLayout() {
        let keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: false)
        let orientationSavvyBounds = CGRectMake(0, CGRectGetHeight(view.frame) - keyboardHeight, view.bounds.width, keyboardHeight)

        if lastLayoutBounds?.width != orientationSavvyBounds.width {
            let uppercase = shiftState.uppercase()
            let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
            layoutEngine?.layoutKeys(currentPage, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
            lastLayoutBounds = orientationSavvyBounds
            setupKeys()
        }
    }

    func setCapsIfNeeded() -> Bool {
        if textProcessor.shouldAutoCapitalize() == true {
            switch shiftState {
            case .Disabled:
                shiftState = .Enabled
            case .Enabled:
                shiftState = .Enabled
            case .Locked:
                shiftState = .Locked
            }

            return true
        } else {
            switch shiftState {
            case .Disabled:
                shiftState = .Disabled
            case .Enabled:
                shiftState = .Disabled
            case .Locked:
                shiftState = .Locked
            }

            return false
        }
    }

    func setPage(page: Int) {
        keysContainerView.resetTrackedViews()
        currentPage = page
        layoutEngine?.layoutKeys(page, uppercase: false, characterUppercase: false, shiftState: shiftState)
        setupKeys()
    }

    func updateKeyboardLetterCases() {
        for button in allKeys {
            if let key = button.key {
                switch key {
                case .letter (let character):
                    let str = String(character.rawValue)
                    if shiftState.uppercase() {
                        button.text = str
                    } else {
                        button.text = str.lowercaseString
                    }
                    break
                case .modifier(.CapsLock, _):
                    if shiftState.uppercase() {
                        button.selected = true
                    } else {
                        button.selected = false
                    }
                default:
                    break
                }
            }
        }
    }

    func setupKeys() {
        let setupKey: (KeyboardKey) -> (KeyboardKeyButton?) = { key in
            if let keyView = self.layoutEngine?.viewForKey(key) {
                keyView.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                switch key {
                case .modifier(.SwitchKeyboard, _):
                    keyView.addTarget(self, action: "advanceTapped:", forControlEvents: .TouchUpInside)
                case .modifier(.Backspace, _):
                    let cancelEvents: UIControlEvents = [
                        UIControlEvents.TouchUpInside,
                        UIControlEvents.TouchDragExit,
                        UIControlEvents.TouchUpOutside,
                        UIControlEvents.TouchCancel,
                        UIControlEvents.TouchDragOutside
                    ]
                    keyView.addTarget(self, action: "backspaceDown:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "backspaceUp:", forControlEvents: cancelEvents)
                case .modifier(.CapsLock, _):
                    keyView.addTarget(self, action: "shiftDown:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "shiftUp:", forControlEvents: .TouchUpInside)
                    keyView.addTarget(self, action: "shiftDoubleTapped:", forControlEvents: .TouchDownRepeat)
                case .modifier(.Space, _):
                    keyView.addTarget(self, action: "didTapSpaceButton:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseSpaceButton:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .modifier(.CallService, _):
                    keyView.addTarget(self, action: "didTapCallKey:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseCallKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .modifier(.Share, _):
                    keyView.addTarget(self, action: "didTapShareKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .modifier(.Enter, _):
                    keyView.addTarget(self, action: "didTapEnterKey:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseEnterKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .changePage(_, _):
                    keyView.addTarget(self, action: "pageChangeTapped:", forControlEvents: .TouchDown)
                default:
                    break
                }

                if key.isCharacter {
                    if UIDevice.currentDevice().userInterfaceIdiom != UIUserInterfaceIdiom.Pad {
                        keyView.addTarget(self, action: "showPopup:", forControlEvents: [.TouchDown, .TouchDragInside, .TouchDragEnter])
                        keyView.addTarget(keyView, action: "hidePopup", forControlEvents: [.TouchDragExit, .TouchCancel])
                        keyView.addTarget(self, action: "hidePopupDelay:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside])
                    }
                }

                if !key.isModifier {
                    keyView.addTarget(self, action: "highlightKey:", forControlEvents: [.TouchDown, .TouchDragInside, .TouchDragEnter])
                    keyView.addTarget(self, action: "unHighlightKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                }

                if key.hasOutput {
                    keyView.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
                }
                self.updateKeyboardLetterCases()

                return keyView
            }
            return nil
        }

        let page = layout.pages[currentPage]
        for rowKeys in page.rows {
            for key in rowKeys {
                setupKey(key)
            }
        }

    }

}
