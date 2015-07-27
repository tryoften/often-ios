//
//  KeyboardViewController.swift
//  Surf
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Surf. All rights reserved.
//

import UIKit

let ShiftStateUserDefaultsKey = "kShiftState"
let ResizeKeyboardEvent = "resizeKeyboard"
let SwitchKeyboardEvent = "switchKeyboard"

class KeyboardViewController: UIInputViewController, TextProcessingManagerDelegate {
    let locale: Language = .English
    var textProcessor: TextProcessingManager!
    var keysContainerView: TouchRecognizerView!
    var searchBar: SearchBarController!
    var lettercase: Lettercase!
    var layout: KeyboardLayout
    var constraintsAdded: Bool = false
    var currentPage: Int = 0
    private var layoutEngine: KeyboardLayoutEngine?
    var shiftState: ShiftState {
        didSet {
            switch shiftState {
            case .Disabled:
                self.updateKeyCaps(false)
            case .Enabled:
                self.updateKeyCaps(true)
            case .Locked:
                self.updateKeyCaps(true)
            }
        }
    }
    var heightConstraint: NSLayoutConstraint?
    var keyboardHeight: CGFloat {
        get {
            if let constraint = self.heightConstraint {
                return constraint.constant
            }
            else {
                return 0
            }
        }
        set {
            self.setHeight(newValue)
        }
    }
    
    var kludge: UIView?
    static var debugKeyboard = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        searchBar = SearchBarController(nibName: nil, bundle: nil)
        searchBar.textProcessor = textProcessor
        
        keysContainerView = TouchRecognizerView()
        keysContainerView.backgroundColor = UIColor(fromHexString: "#202020")
        
        shiftState = .Disabled
        
        if let defaultLayout = KeyboardLayouts[locale] {
            layout = defaultLayout
        } else {
            layout = DefaultKeyboardLayout
        }
        
        lettercase = .Lowercase
        
        super.init(nibName: nil, bundle: nil)
        
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy as! UITextDocumentProxy)
        
        textProcessor.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)
        
        view.addSubview(searchBar.view)
        view.addSubview(keysContainerView)
        inputView.backgroundColor = UIColor.whiteColor()
        
        if KeyboardViewController.debugKeyboard {
            var viewFrame = view.frame
            viewFrame.origin.y = 0
            viewFrame.size.height = KeyboardHeight
            view.frame = viewFrame
        }
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var lastLayoutBounds: CGRect?
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
            let uppercase = self.shiftState.uppercase()
            let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
            
            self.keysContainerView.frame = orientationSavvyBounds
            self.layoutEngine?.layoutKeys(self.currentPage, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
            self.lastLayoutBounds = orientationSavvyBounds
            self.setupKeys()
        }
        
        searchBar.view.frame = CGRectMake(0, 0, view.bounds.width, 40)
        keysContainerView.frame.origin = CGPointMake(0, view.bounds.height - keysContainerView.bounds.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        searchBar.view.hidden = false
        keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
    }
    
    func setHeight(height: CGFloat) {
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(
                item:self.view,
                attribute:NSLayoutAttribute.Height,
                relatedBy:NSLayoutRelation.Equal,
                toItem:nil,
                attribute:NSLayoutAttribute.NotAnAttribute,
                multiplier:0,
                constant:height)
            self.heightConstraint!.priority = 1000
            
            self.view.addConstraint(self.heightConstraint!) // TODO: what if view already has constraint added?
        }
        else {
            self.heightConstraint?.constant = height
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
        let topBannerHeight: CGFloat = withTopBanner ? 40.0 : 0.0
        
        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight) + topBannerHeight
    }
    
    func resizeKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            height = userInfo["height"] as? CGFloat {
                keyboardHeight = height
                UIView.animateWithDuration(0.3) {
                    self.view.layoutIfNeeded()
                }
        }
    }
    
    func switchKeyboard() {
        advanceToNextInputMode()
    }
    
    func setupLayout() {
        if !constraintsAdded {
            layoutEngine = KeyboardLayoutEngine(model: layout, superview: keysContainerView, layoutConstants: LayoutConstants.self)
            
            setPage(0)
            setupKludge()
            
            updateKeyCaps(self.shiftState.uppercase())
            
            self.constraintsAdded = true
        }
    }
    
    override func textWillChange(textInput: UITextInput) {
        textProcessor.textWillChange(textInput)
    }
    
    override func textDidChange(textInput: UITextInput) {
        textProcessor.textDidChange(textInput)
    }
    
    override func selectionWillChange(textInput: UITextInput) {
        textProcessor.selectionWillChange(textInput)
    }
    
    override func selectionDidChange(textInput: UITextInput) {
        textProcessor.selectionDidChange(textInput)
    }
    
    func setupKludge() {
        if self.kludge == nil {
            var kludge = UIView()
            self.view.addSubview(kludge)
            kludge.setTranslatesAutoresizingMaskIntoConstraints(false)
            kludge.hidden = true
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            self.view.addConstraints([a, b, c, d])
            
            self.kludge = kludge
        }
    }
    
    func setupKeys() {
        for page in layout.pages {
            for rowKeys in page.rows { // TODO: quick hack
                for key in rowKeys {
                    if let keyView = self.layoutEngine?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                        
                        switch key {
                        case .modifier(.SwitchKeyboard):
                            keyView.addTarget(self, action: "advanceTapped:", forControlEvents: .TouchUpInside)
                        case .modifier(.Backspace):
                            let cancelEvents: UIControlEvents = UIControlEvents.TouchUpInside|UIControlEvents.TouchUpInside|UIControlEvents.TouchDragExit|UIControlEvents.TouchUpOutside|UIControlEvents.TouchCancel|UIControlEvents.TouchDragOutside
                            
                            keyView.addTarget(self, action: "backspaceDown:", forControlEvents: .TouchDown)
                            keyView.addTarget(self, action: "backspaceUp:", forControlEvents: cancelEvents)
                        case .modifier(.CapsLock):
                            keyView.addTarget(self, action: Selector("shiftDown:"), forControlEvents: .TouchDown)
                            keyView.addTarget(self, action: Selector("shiftUp:"), forControlEvents: .TouchUpInside)
                            keyView.addTarget(self, action: Selector("shiftDoubleTapped:"), forControlEvents: .TouchDownRepeat)
                        case .modifier(.SpecialKeypad):
                            keyView.addTarget(self, action: Selector("modeChangeTapped:"), forControlEvents: .TouchDown)
                        default:
                            break
                        }
                        
                        if key.isCharacter {
                            if UIDevice.currentDevice().userInterfaceIdiom != UIUserInterfaceIdiom.Pad {
                                keyView.addTarget(self, action: Selector("showPopup:"), forControlEvents: .TouchDown | .TouchDragInside | .TouchDragEnter)
                                keyView.addTarget(keyView, action: Selector("hidePopup"), forControlEvents: .TouchDragExit | .TouchCancel)
                                keyView.addTarget(self, action: Selector("hidePopupDelay:"), forControlEvents: .TouchUpInside | .TouchUpOutside | .TouchDragOutside)
                            }
                        }
                        
                        if key.hasOutput {
                            keyView.addTarget(self, action: "keyPressedHelper:", forControlEvents: .TouchUpInside)
                        }
                        
                        if key != .modifier(.CapsLock) {
                            keyView.addTarget(self, action: Selector("highlightKey:"), forControlEvents: .TouchDown | .TouchDragInside | .TouchDragEnter)
                            keyView.addTarget(self, action: Selector("unHighlightKey:"), forControlEvents: .TouchUpInside | .TouchUpOutside | .TouchDragOutside | .TouchDragExit | .TouchCancel)
                        }
                        
                        keyView.addTarget(self, action: Selector("playKeySound"), forControlEvents: .TouchDown)
                    }
                }
            }
        }
    }
    
    
    func setPage(page: Int) {
        currentPage = page
        self.layoutEngine?.layoutKeys(page, uppercase: false, characterUppercase: false, shiftState: self.shiftState)
    }
    
    func updateKeyCaps(uppercase: Bool) {
        let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
        self.layoutEngine?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
    }
    
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! KeyboardKeyButton
        
        button.highlighted = false
        button.selected = !button.selected
        
        if let key = button.key {
            switch(key) {
            case .letter(let character):
                var str = String(character.rawValue)
                if lettercase! == .Lowercase {
                    str = str.lowercaseString
                }
                textProcessor.insertText(str)
            case .digit(let number):
                textProcessor.insertText(String(number.rawValue))
            case .special(let character):
                textProcessor.insertText(String(character.rawValue))
            case .modifier(.CapsLock):
                lettercase = (lettercase == .Lowercase) ? .Uppercase : .Lowercase
            case .modifier(.SwitchKeyboard):
                NSNotificationCenter.defaultCenter().postNotificationName("switchKeyboard", object: nil)
            case .modifier(.Backspace):
                textProcessor.deleteBackward()
            case .modifier(.Space):
                textProcessor.insertText(" ")
            case .modifier(.Enter):
                textProcessor.insertText("\n")
            case .modifier(.GoToBrowse):
                dismissViewControllerAnimated(false, completion: nil)
            default:
                break
            }
        }
    }
    
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
    }
    
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType) {
        searchBar.activeServiceProviderType = serviceProviderType
    }
    
    func didTouchDownOnKey(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        
    }
    
    func advanceTapped(sender: KeyboardKey) {
        
    }
}

