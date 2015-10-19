    //
//  KeyboardViewController.swift
//  Surf
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Surf. All rights reserved.
//

import UIKit
import AudioToolbox

let ShiftStateUserDefaultsKey = "kShiftState"
let ResizeKeyboardEvent = "resizeKeyboard"
let SwitchKeyboardEvent = "switchKeyboard"
let CollapseKeyboardEvent = "collapseKeyboard"
let RestoreKeyboardEvent = "restoreKeyboard"

class KeyboardViewController: UIInputViewController, TextProcessingManagerDelegate {
    let locale: Language = .English
    var textProcessor: TextProcessingManager!
    var keysContainerView: TouchRecognizerView!
    var togglePanelButton: TogglePanelButton!
    var slidePanelContainerView: UIView
    var searchBar: SearchBarController!
    var layout: KeyboardLayout
    var constraintsAdded: Bool = false
    var currentPage: Int = 0
    var layoutEngine: KeyboardLayoutEngine?
    var keyWithDelayedPopup: KeyboardKeyButton?
    var popupDelayTimer: NSTimer?
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceStartTime: CFAbsoluteTime!
    var firstWordQuickDeleted: Bool = false
    var lastLayoutBounds: CGRect?
    var userDefaults: NSUserDefaults
    var keyboardconnectivityWormhole: MMWormhole
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var kludge: UIView?
    static var debugKeyboard = false
    var autoPeriodState: AutoPeriodState = .NoSpace
    var backspaceActive: Bool {
        return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
    }
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?
    // state tracking during shift tap
    var shiftWasMultitapped: Bool = false
    var shiftStartingState: ShiftState?
    var shiftState: ShiftState {
        didSet {
            changeKeyboardLetterCases()
        }
    }
    var heightConstraint: NSLayoutConstraint?
    var keyboardHeight: CGFloat {
        get {
            if let constraint = heightConstraint {
                return constraint.constant
            }
            else {
                return 0
            }
        }
        set {
            setHeight(newValue)
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
    enum AutoPeriodState {
        case NoSpace
        case FirstSpace
    }
    
    static var once_predicate: dispatch_once_t = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        userDefaults.setBool(true, forKey: "keyboardInstall")
        userDefaults.synchronize()
        
        keyboardconnectivityWormhole = MMWormhole(applicationGroupIdentifier: AppSuiteName, optionalDirectory: nil)
        keyboardconnectivityWormhole.passMessageObject("open", identifier: "keyboardOpen")
        
        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned
        dispatch_once(&KeyboardViewController.once_predicate) {
            if (!KeyboardViewController.debugKeyboard) {
                Firebase.defaultConfig().persistenceEnabled = true
            }
        }
        
        searchBar = SearchBarController(nibName: nil, bundle: nil)
        searchBarHeight = KeyboardSearchBarHeight
        
        keysContainerView = TouchRecognizerView()
        keysContainerView.backgroundColor = DefaultTheme.keyboardBackgroundColor
        
        togglePanelButton = TogglePanelButton()
        togglePanelButton.hidden = true
        
        shiftState = .Enabled
        
        if let defaultLayout = KeyboardLayouts[locale] {
            layout = defaultLayout
        } else {
            layout = DefaultKeyboardLayout
        }
        
        slidePanelContainerView = UIView()
        slidePanelContainerView.accessibilityIdentifier = "Slide Panel"
        searchBar.searchResultsContainerView = slidePanelContainerView
        
        super.init(nibName: nil, bundle: nil)
        
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy)
        textProcessor.delegate = self
        searchBar.textProcessor = textProcessor
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        center.addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)
        center.addObserver(self, selector: "collapseKeyboard", name: CollapseKeyboardEvent, object: nil)
        center.addObserver(self, selector: "restoreKeyboard", name: RestoreKeyboardEvent, object: nil)
        togglePanelButton.addTarget(self, action: "toggleKeyboard", forControlEvents: .TouchUpInside)
        
        view.addSubview(searchBar.view)
        view.addSubview(slidePanelContainerView)
        view.addSubview(togglePanelButton)
        view.addSubview(keysContainerView)
        inputView!.backgroundColor = VeryLightGray
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if view.bounds == CGRectZero {
            return
        }
        
        setupLayout()
        
        let orientationSavvyBounds = CGRectMake(0, 0, view.bounds.width, heightForOrientation(interfaceOrientation, withTopBanner: false))
        if (lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
            // do nothing
        }
        else {
            let uppercase = shiftState.uppercase()
            let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
            
            keysContainerView.frame = orientationSavvyBounds
            layoutEngine?.layoutKeys(currentPage, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
            lastLayoutBounds = orientationSavvyBounds
            setupKeys()
        }
        
        if keysContainerView.collapsed {
            let height = CGRectGetHeight(self.view.frame) - 30
            var keysContainerViewFrame = keysContainerView.frame
            keysContainerViewFrame.origin.y = CGRectGetHeight(self.view.frame)
            keysContainerView.frame = keysContainerViewFrame
            
            var togglePanelButtonFrame = self.keysContainerView.frame
            togglePanelButtonFrame.origin.y = height
            togglePanelButtonFrame.size.height = 30
            self.togglePanelButton.frame = togglePanelButtonFrame
        } else {
            keysContainerView.frame.origin = CGPointMake(0, view.bounds.height - keysContainerView.bounds.height)
        }
        slidePanelContainerView.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(keysContainerView.frame), CGRectGetHeight(self.view.frame) - KeyboardSearchBarHeight)
        searchBar.view.frame = CGRectMake(0, 0, view.bounds.width, searchBarHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        searchBar.view.hidden = false
        keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
    }
    
    func setHeight(height: CGFloat) {
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(
                item:view,
                attribute:NSLayoutAttribute.Height,
                relatedBy:NSLayoutRelation.Equal,
                toItem:nil,
                attribute:NSLayoutAttribute.NotAnAttribute,
                multiplier:0,
                constant:height)
            heightConstraint!.priority = 1000
            
            view.addConstraint(heightConstraint!) // TODO: what if view already has constraint added?
            
            if (KeyboardViewController.debugKeyboard) {
                var viewFrame = view.frame
                viewFrame.size.height = KeyboardHeight + 100
                view.frame = viewFrame
            }
        }
        else {
            heightConstraint?.constant = height
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func heightForOrientation(orientation: UIInterfaceOrientation, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        
        //TODO: hardcoded stuff
        let actualScreenWidth = (UIScreen.mainScreen().nativeBounds.size.width / UIScreen.mainScreen().nativeScale)
        let canonicalPortraitHeight = (isPad ? CGFloat(264) : CGFloat(orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216))
        let canonicalLandscapeHeight = (isPad ? CGFloat(352) : CGFloat(162))
        let topBannerHeight: CGFloat = withTopBanner ? searchBarHeight : 0.0
        
        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight) + topBannerHeight
    }
    
    func resizeKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            height = userInfo["height"] as? CGFloat {
                togglePanelButton.hidden = true
                
                let keysContainerViewHeight = self.heightForOrientation(self.interfaceOrientation, withTopBanner: false)
                
                searchBarHeight = height + KeyboardSearchBarHeight
                keyboardHeight = keysContainerViewHeight + searchBarHeight
                
                self.searchBar.view.frame = CGRectMake(0, self.searchBarHeight, self.view.bounds.width, self.searchBarHeight)
                self.view.layoutIfNeeded()
        }
    }
    
    func collapseKeyboard() {
        togglePanelButton.collapsed = true
        keysContainerView.collapsed = true
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
            
            let height = CGRectGetHeight(self.view.frame) - 30
            var keysContainerViewFrame = self.keysContainerView.frame
            keysContainerViewFrame.origin.y = CGRectGetHeight(self.view.frame)
            self.keysContainerView.frame = keysContainerViewFrame
            
            var togglePanelButtonFrame = self.keysContainerView.frame
            togglePanelButtonFrame.origin.y = height
            togglePanelButtonFrame.size.height = 30
            self.togglePanelButton.frame = togglePanelButtonFrame
            
        }) { done in
            self.togglePanelButton.hidden = false
        }
    }
    
    func restoreKeyboard() {
        togglePanelButton.collapsed = false
        keysContainerView.collapsed = false
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
            self.keysContainerView.frame.origin = CGPointMake(0, self.view.bounds.height - self.keysContainerView.bounds.height)
            
            self.togglePanelButton.frame.origin.y = self.keysContainerView.frame.origin.y - 30
            }) { done in
                
        }
    }
    
    func toggleKeyboard() {
        if togglePanelButton.collapsed {
            restoreKeyboard()
        } else {
            collapseKeyboard()
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        keyboardHeight = heightForOrientation(toInterfaceOrientation, withTopBanner: true)
    }
    
    func switchKeyboard() {
        advanceToNextInputMode()
    }
    
    func setupLayout() {
        if !constraintsAdded {
            layoutEngine = KeyboardLayoutEngine(model: layout, superview: keysContainerView, layoutConstants: LayoutConstants.self)
            
            setPage(0)
            setupKludge()
            
            updateKeyCaps(shiftState.lettercase())
            constraintsAdded = true
        }
    }
    
    func setCapsIfNeeded() -> Bool {
        if textProcessor.shouldAutoCapitalize() {
            switch shiftState {
            case .Disabled:
                shiftState = .Enabled
            case .Enabled:
                shiftState = .Enabled
            case .Locked:
                shiftState = .Locked
            }
            
            return true
        }
        else {
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
    
    override func textDidChange(textInput: UITextInput?) {
        if let textInput = textInput {
             textProcessor.textDidChange(textInput)
        }
    }
    
    override func textWillChange(textInput: UITextInput?) {
        if let textInput = textInput {
            textProcessor.textWillChange(textInput)
        }
    }
   
    
    override func selectionWillChange(textInput: UITextInput?) {
        if let textInput = textInput {
             textProcessor.selectionWillChange(textInput)
        }
    }
    
    override func selectionDidChange(textInput: UITextInput?) {
        if let textInput = textInput {
            textProcessor.selectionDidChange(textInput)
        }
    }
    
    func setupKludge() {
        if kludge == nil {
            let kludge = UIView()
            view.addSubview(kludge)
            kludge.translatesAutoresizingMaskIntoConstraints = false
            kludge.hidden = true
            
            view.addConstraints([
                kludge.al_left == view.al_left,
                kludge.al_right == view.al_left,
                kludge.al_top == view.al_top,
                kludge.al_bottom == view.al_bottom
            ])
            
            self.kludge = kludge
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
                    let cancelEvents: UIControlEvents = [UIControlEvents.TouchUpInside, UIControlEvents.TouchUpInside, UIControlEvents.TouchDragExit, UIControlEvents.TouchUpOutside, UIControlEvents.TouchCancel, UIControlEvents.TouchDragOutside]
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
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "callServiceLongPressed:")
                    longPressRecognizer.minimumPressDuration = 1.0
                    keyView.background.addGestureRecognizer(longPressRecognizer)
                    keyView.userInteractionEnabled = true
                    
                    keyView.addTarget(self, action: "didTapCallKey:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseCallKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
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
                self.changeKeyboardLetterCases()
                return keyView
            }
            return nil
        }
        
        for page in layout.pages {
            for rowKeys in page.rows {
                for key in rowKeys {
                    setupKey(key)
                }
            }
        }
    }
    
    func setPage(page: Int) {
        keysContainerView.resetTrackedViews()
        currentPage = page
        layoutEngine?.layoutKeys(page, uppercase: false, characterUppercase: false, shiftState: shiftState)
        setupKeys()
    }

    func changeKeyboardLetterCases() {
        for button in allKeys {
            if let key = button.key {
                switch(key) {
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
    
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
        setCapsIfNeeded()
    }
    
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType) {
        searchBar.activeServiceProviderType = serviceProviderType
    }
}

