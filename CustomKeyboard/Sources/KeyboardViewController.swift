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
        searchBar.textProcessor = textProcessor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)
        
        view.addSubview(searchBar.view)
        view.addSubview(keysContainerView)
        inputView.backgroundColor = UIColor.whiteColor()
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
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.keyboardHeight = self.heightForOrientation(toInterfaceOrientation, withTopBanner: true)
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
                        case .modifier(.SwitchKeyboard, let pageId):
                            keyView.addTarget(self, action: "advanceTapped:", forControlEvents: .TouchUpInside)
                        case .modifier(.Backspace, let pageId):
                            let cancelEvents: UIControlEvents = UIControlEvents.TouchUpInside|UIControlEvents.TouchUpInside|UIControlEvents.TouchDragExit|UIControlEvents.TouchUpOutside|UIControlEvents.TouchCancel|UIControlEvents.TouchDragOutside
                            
                            keyView.addTarget(self, action: "backspaceDown:", forControlEvents: .TouchDown)
                            keyView.addTarget(self, action: "backspaceUp:", forControlEvents: cancelEvents)
                        case .modifier(.CapsLock, let pageId):
                            keyView.addTarget(self, action: "shiftDown:", forControlEvents: .TouchDown)
                            keyView.addTarget(self, action: "shiftUp:", forControlEvents: .TouchUpInside)
                            keyView.addTarget(self, action: "shiftDoubleTapped:", forControlEvents: .TouchDownRepeat)
                        case .digit(let number):
                            break
                        case .changePage(let pageNumber, let pageId):
                            keyView.addTarget(self, action: "pageChangeTapped:", forControlEvents: .TouchDown)
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
                        
                        if !key.isModifier {
                            keyView.addTarget(self, action: Selector("highlightKey:"), forControlEvents: .TouchDown | .TouchDragInside | .TouchDragEnter)
                            keyView.addTarget(self, action: Selector("unHighlightKey:"), forControlEvents: .TouchUpInside | .TouchUpOutside | .TouchDragOutside | .TouchDragExit | .TouchCancel)
                        }
                        
                        if key.hasOutput {
                            keyView.addTarget(self, action: "didTapButton:", forControlEvents: .TouchDown)
                        }
                    }
                }
            }
        }
    }
    
    
    func setPage(page: Int) {
        currentPage = page
        self.layoutEngine?.layoutKeys(page, uppercase: false, characterUppercase: false, shiftState: self.shiftState)
        self.setupKeys()
    }
    
    func updateKeyCaps(uppercase: Bool) {
        let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
        self.layoutEngine?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
    }
    
    func didTapButton(button: KeyboardKeyButton?) {
        
        if let button = button, key = button.key {
            
            button.highlighted = false
            button.selected = !button.selected
            
            switch(key) {
            case .letter(let character):
                var str = String(character.rawValue)
                if lettercase! == .Lowercase {
                    str = str.lowercaseString
                }
                textProcessor.insertText(str)
            case .digit(let number):
                textProcessor.insertText(String(number.rawValue))
            case .special(let character, let pageId):
                textProcessor.insertText(String(character.rawValue))
            case .changePage(let pageIndex, let pageId):
                break
            case .modifier(.CapsLock, let pageId):
                lettercase = (lettercase == .Lowercase) ? .Uppercase : .Lowercase
            case .modifier(.CallService, let pageId):
                textProcessor.insertText("#")
            case .modifier(.Space, let pageId):
                textProcessor.insertText(" ")
            case .modifier(.Enter, let pageId):
                textProcessor.insertText("\n")
            default:
                break
            }
        }
        
        playKeySound()
    }
    
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
    }
    
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType) {
        searchBar.activeServiceProviderType = serviceProviderType
    }

    // MARK: Event Handlers
    func didTouchDownOnKey(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        
    }
    
    func advanceTapped(sender: KeyboardKeyButton?) {
        NSNotificationCenter.defaultCenter().postNotificationName("switchKeyboard", object: nil)
    }
    
    func pageChangeTapped(sender: AnyObject?) {
        if let button = sender as? KeyboardKeyButton,
            key = button.key {
                switch(key) {
                case .changePage(let pageNumber, let pageId):
                    setPage(pageNumber)
                default:
                    setPage(0)
                }
        }
        
    }
    
    func highlightKey(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        button.highlighted = true
    }
    
    func unHighlightKey(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        button.highlighted = false
    }
    
    func playKeySound() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            AudioServicesPlaySystemSound(1104)
        })
    }
    
    var keyWithDelayedPopup: KeyboardKeyButton?
    var popupDelayTimer: NSTimer?
    
    func showPopup(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        if button == self.keyWithDelayedPopup {
            self.popupDelayTimer?.invalidate()
        }
        button.showPopup()
    }
    
    func hidePopupDelay(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        self.popupDelayTimer?.invalidate()
        
        if button != self.keyWithDelayedPopup {
            self.keyWithDelayedPopup?.hidePopup()
            self.keyWithDelayedPopup = button
        }
        
        if button.popup != nil {
            self.popupDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("hidePopupCallback"), userInfo: nil, repeats: false)
        }
    }
    
    func hidePopupCallback() {
        self.keyWithDelayedPopup?.hidePopup()
        self.keyWithDelayedPopup = nil
        self.popupDelayTimer = nil
    }
    
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceActive: Bool {
        get {
            return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
        }
    }
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?

    func cancelBackspaceTimers() {
        self.backspaceDelayTimer?.invalidate()
        self.backspaceRepeatTimer?.invalidate()
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = nil
    }
    
    func backspaceDown(sender: KeyboardKeyButton?) {
        self.cancelBackspaceTimers()
        
        if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
            textProcessor.deleteBackward()
        }
        
        // trigger for subsequent deletes
        self.backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
    }
    
    func backspaceUp(sender: KeyboardKeyButton?) {
        self.cancelBackspaceTimers()
    }
    
    func backspaceDelayCallback() {
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
    }
    
    func backspaceRepeatCallback() {
        self.playKeySound()
        
        if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
            textProcessor.deleteBackward()
        }
    }

    // state tracking during shift tap
    var shiftWasMultitapped: Bool = false
    var shiftStartingState: ShiftState?
    
    func shiftDown(sender: KeyboardKeyButton?) {
        self.shiftStartingState = self.shiftState
        
        if let shiftStartingState = self.shiftStartingState {
            if shiftStartingState.uppercase() {
                // handled by shiftUp
                return
            }
            else {
                switch self.shiftState {
                case .Disabled:
                    self.shiftState = .Enabled
                case .Enabled:
                    self.shiftState = .Disabled
                case .Locked:
                    self.shiftState = .Disabled
                }
                
//                (sender.shape as? ShiftShape)?.withLock = false
            }
        }
    }
    
    func shiftUp(sender: KeyboardKeyButton?) {
        if self.shiftWasMultitapped {
            // do nothing
        }
        else {
            if let shiftStartingState = self.shiftStartingState {
                if !shiftStartingState.uppercase() {
                    // handled by shiftDown
                }
                else {
                    switch self.shiftState {
                    case .Disabled:
                        self.shiftState = .Enabled
                    case .Enabled:
                        self.shiftState = .Disabled
                    case .Locked:
                        self.shiftState = .Disabled
                    }
                    
//                    (sender.shape as? ShiftShape)?.withLock = false
                }
            }
        }
        
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
    }
    
    func shiftDoubleTapped(sender: KeyboardKeyButton?) {
        self.shiftWasMultitapped = true
        
        switch self.shiftState {
        case .Disabled:
            self.shiftState = .Locked
        case .Enabled:
            self.shiftState = .Locked
        case .Locked:
            self.shiftState = .Disabled
        }
    }
//    
//    func updateKeyCaps(uppercase: Bool) {
//        let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
//        self.layoutEngine?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
//    }

}

