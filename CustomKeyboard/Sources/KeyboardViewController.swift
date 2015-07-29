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
    var layoutEngine: KeyboardLayoutEngine?
    var keyWithDelayedPopup: KeyboardKeyButton?
    var popupDelayTimer: NSTimer?
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceStartTime: CFAbsoluteTime!
    var lastLayoutBounds: CGRect?
    var kludge: UIView?
    static var debugKeyboard = false
    var backspaceActive: Bool {
        get {
            return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
        }
    }
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?
    // state tracking during shift tap
    var shiftWasMultitapped: Bool = false
    var shiftStartingState: ShiftState?
    var shiftState: ShiftState {
        didSet {
            switch shiftState {
            case .Disabled:
                updateKeyCaps(false)
            case .Enabled:
                updateKeyCaps(true)
            case .Locked:
                updateKeyCaps(true)
            }
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
        
        searchBar.view.frame = CGRectMake(0, 0, view.bounds.width, 40)
        keysContainerView.frame.origin = CGPointMake(0, view.bounds.height - keysContainerView.bounds.height)
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
            
            updateKeyCaps(shiftState.uppercase())
            
            constraintsAdded = true
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
        if kludge == nil {
            var kludge = UIView()
            view.addSubview(kludge)
            kludge.setTranslatesAutoresizingMaskIntoConstraints(false)
            kludge.hidden = true
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            view.addConstraints([a, b, c, d])
            
            self.kludge = kludge
        }
    }
    
    func setupKeys() {
        for page in layout.pages {
            for rowKeys in page.rows { // TODO: quick hack
                for key in rowKeys {
                    if let keyView = layoutEngine?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                        
                        switch key {
                        case .modifier(.SwitchKeyboard, let pageId):
                            keyView.addTarget(self, action: "advanceTapped:", forControlEvents: .TouchUpInside)
                        case .modifier(.Backspace, let pageId):
                            println("Backspace found")
                            let cancelEvents: UIControlEvents = UIControlEvents.TouchUpInside|UIControlEvents.TouchUpInside|UIControlEvents.TouchDragExit|UIControlEvents.TouchUpOutside|UIControlEvents.TouchCancel|UIControlEvents.TouchDragOutside
                            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "backspaceLongPressed:")
                            
                            keyView.addGestureRecognizer(longPressRecognizer)
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
        layoutEngine?.layoutKeys(page, uppercase: false, characterUppercase: false, shiftState: shiftState)
        setupKeys()
    }
    
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
    }
    
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType) {
        searchBar.activeServiceProviderType = serviceProviderType
    }

//
//    // MARK: Event Handlers
//    func didTouchDownOnKey(sender: AnyObject?) {
//        let button = sender as! KeyboardKeyButton
//        
//    }
//    
//    func advanceTapped(sender: KeyboardKeyButton?) {
//        
//    }
//    
//    func pageChangeTapped(sender: AnyObject?) {
//        if let button = sender as? KeyboardKeyButton,
//            key = button.key {
//                switch(key) {
//                case .changePage(let pageNumber, let pageId):
//                    setPage(pageNumber)
//                default:
//                    setPage(0)
//                }
//        }
//        
//    }
//    
//    func highlightKey(sender: AnyObject?) {
//        let button = sender as! KeyboardKeyButton
//        button.highlighted = true
//    }
//    
//    func unHighlightKey(sender: AnyObject?) {
//        let button = sender as! KeyboardKeyButton
//        button.highlighted = false
//    }
//    
//    func playKeySound() {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            AudioServicesPlaySystemSound(1104)
//        })
//    }
//    
//    var keyWithDelayedPopup: KeyboardKeyButton?
//    var popupDelayTimer: NSTimer?
//    
//    func showPopup(sender: AnyObject?) {
//        let button = sender as! KeyboardKeyButton
//        if button == self.keyWithDelayedPopup {
//            self.popupDelayTimer?.invalidate()
//        }
//        button.showPopup()
//    }
//    
//    func hidePopupDelay(sender: AnyObject?) {
//        let button = sender as! KeyboardKeyButton
//        self.popupDelayTimer?.invalidate()
//        
//        if button != self.keyWithDelayedPopup {
//            self.keyWithDelayedPopup?.hidePopup()
//            self.keyWithDelayedPopup = button
//        }
//        
//        if button.popup != nil {
//            self.popupDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("hidePopupCallback"), userInfo: nil, repeats: false)
//        }
//    }
//    
//    func hidePopupCallback() {
//        self.keyWithDelayedPopup?.hidePopup()
//        self.keyWithDelayedPopup = nil
//        self.popupDelayTimer = nil
//    }
//    
//    let backspaceDelay: NSTimeInterval = 0.5
//    let backspaceRepeat: NSTimeInterval = 0.07
//    var backspaceActive: Bool {
//        get {
//            return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
//        }
//    }
//    var backspaceDelayTimer: NSTimer?
//    var backspaceRepeatTimer: NSTimer?
//    var backspaceWordDeleteTimer: NSTimer?
//    var backspaceStartTime: CFAbsoluteTime!
//
//    func cancelBackspaceTimers() {
//        self.backspaceDelayTimer?.invalidate()
//        self.backspaceRepeatTimer?.invalidate()
//        self.backspaceWordDeleteTimer?.invalidate()
//        self.backspaceDelayTimer = nil
//        self.backspaceRepeatTimer = nil
//        self.backspaceWordDeleteTimer = nil
//        self.backspaceStartTime = nil
//    }
//    
//    func backspaceDown(button: KeyboardKeyButton?) {
//        self.cancelBackspaceTimers()
//        
//        backspaceStartTime = CFAbsoluteTimeGetCurrent()
//        
//        if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
//            textDocumentProxy.deleteBackward()
//        }
//    
//        // trigger for subsequent deletes
//        self.backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
//    }
//    
//    func backspaceUp(sender: KeyboardKeyButton?) {
//        self.cancelBackspaceTimers()
//    }
//    
//    func backspaceDelayCallback() {
//        self.backspaceDelayTimer = nil
//        self.backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
//        println("backspace delay")
//    }
//    
//    func backspaceRepeatCallback() {
//        self.playKeySound()
//        
//        var timeElapsed = CFAbsoluteTimeGetCurrent() - backspaceStartTime
//        
//        if timeElapsed < 2.0 {
//            if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
//                textDocumentProxy.deleteBackward()
//            }
//        } else {
//            backspaceLongPressed()
//        }
//    }
//    
//    /**
//        Deleting whole word method. Looks at the number of characters from cursor back to first whitespace 
//        before it not including one that is next to it. Needs to be in loop.
//    
//        :param: recognizer Long Press recognizer to handle for a long backspace press
//    
//    */
//    func backspaceLongPressed() {
//        for _ in 0...40000 {
//            println("Stall")
//        }
//        
//        if let textDocumentProxy = self.textDocumentProxy as? UITextDocumentProxy {
//            if let documentContextBeforeInput = textDocumentProxy.documentContextBeforeInput as NSString? {
//                if documentContextBeforeInput.length > 0 {
//                    var charactersToDelete = 0
//                    switch documentContextBeforeInput {
//                    // If cursor is next to a letter
//                    case let stringLeft where NSCharacterSet.letterCharacterSet().characterIsMember(stringLeft.characterAtIndex(stringLeft.length - 1)):
//                        let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet().invertedSet, options: .BackwardsSearch)
//                        if range.location != NSNotFound {
//                            charactersToDelete = documentContextBeforeInput.length - range.location
//                        } else {
//                            charactersToDelete = documentContextBeforeInput.length
//                        }
//                    // If cursor is next to a whitespace
//                    case let stringLeft where stringLeft.hasSuffix(" "):
//                        let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet().invertedSet, options: .BackwardsSearch)
//                        if range.location != NSNotFound {
//                            charactersToDelete = documentContextBeforeInput.length - range.location - 1
//                        } else {
//                            charactersToDelete = documentContextBeforeInput.length
//                        }
//                    // if there is only one character left
//                    default:
//                        charactersToDelete = 1
//                    }
//                    
//                    for i in 0..<charactersToDelete {
//                        textDocumentProxy.deleteBackward()
//                    }
//                }
//            }
//        }
//    }
//
//    // state tracking during shift tap
//    var shiftWasMultitapped: Bool = false
//    var shiftStartingState: ShiftState?
//    
//    func shiftDown(sender: KeyboardKeyButton?) {
//        self.shiftStartingState = self.shiftState
//        
//        if let shiftStartingState = self.shiftStartingState {
//            if shiftStartingState.uppercase() {
//                // handled by shiftUp
//                return
//            }
//            else {
//                switch self.shiftState {
//                case .Disabled:
//                    self.shiftState = .Enabled
//                case .Enabled:
//                    self.shiftState = .Disabled
//                case .Locked:
//                    self.shiftState = .Disabled
//                }
//            }
//        }
//    }
//    
//    func shiftUp(sender: KeyboardKeyButton?) {
//        if self.shiftWasMultitapped {
//            // do nothing
//        }
//        else {
//            if let shiftStartingState = self.shiftStartingState {
//                if !shiftStartingState.uppercase() {
//                    // handled by shiftDown
//                }
//                else {
//                    switch self.shiftState {
//                    case .Disabled:
//                        self.shiftState = .Enabled
//                    case .Enabled:
//                        self.shiftState = .Disabled
//                    case .Locked:
//                        self.shiftState = .Disabled
//                    }
//                }
//            }
//        }
//        
//        self.shiftStartingState = nil
//        self.shiftWasMultitapped = false
//    }
//    
//    func shiftDoubleTapped(sender: KeyboardKeyButton?) {
//        self.shiftWasMultitapped = true
//        
//        switch self.shiftState {
//        case .Disabled:
//            self.shiftState = .Locked
//        case .Enabled:
//            self.shiftState = .Locked
//        case .Locked:
//            self.shiftState = .Disabled
//        }
//    }

}

