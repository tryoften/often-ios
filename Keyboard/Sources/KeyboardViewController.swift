    //
//  KeyboardViewController.swift
//  Surf
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Surf. All rights reserved.
//

import UIKit
import AudioToolbox
import Realm
import Fabric
import Crashlytics

let ShiftStateUserDefaultsKey = "kShiftState"
let ResizeKeyboardEvent = "resizeKeyboard"
let SwitchKeyboardEvent = "switchKeyboard"
let CollapseKeyboardEvent = "collapseKeyboard"
let RestoreKeyboardEvent = "restoreKeyboard"
let ToggleButtonKeyboardEvent = "toggleButtonKeyboard"

class KeyboardViewController: UIInputViewController, TextProcessingManagerDelegate, ToolTipCloseButtonDelegate {
    var viewModel: KeyboardViewModel?
    let locale: Language = .English
    var textProcessor: TextProcessingManager?
    var keysContainerView: TouchRecognizerView!
    var togglePanelButton: TogglePanelButton!
    var slidePanelContainerView: UIView
    var searchBar: SearchBarController
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
    var mediaLink: MediaLink?
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var kludge: UIView?
    static var debugKeyboard = false
    var autoPeriodState: AutoPeriodState = .NoSpace
    var toolTipViewController: ToolTipViewController?
    var favoritesAndRecentsViewController: KeyboardFavoritesAndRecentsViewController?
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
            updateKeyboardLetterCases()
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
    var viewModelsLoaded: dispatch_once_t = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        searchBar = SearchBarController(nibName: nil, bundle: nil)
        searchBarHeight = KeyboardSearchBarHeight
        
        keysContainerView = TouchRecognizerView()
        keysContainerView.backgroundColor = DefaultTheme.keyboardBackgroundColor
        
        togglePanelButton = TogglePanelButton()
        togglePanelButton.hidden = true
        togglePanelButton.mode = .ToggleKeyboard
        
        shiftState = .Enabled
        
        if let defaultLayout = KeyboardLayouts[locale] {
            layout = defaultLayout
        } else {
            layout = DefaultKeyboardLayout
        }
        
        slidePanelContainerView = UIView()
        slidePanelContainerView.accessibilityIdentifier = "Slide Panel"
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(searchBar.view)
        view.addSubview(slidePanelContainerView)
        view.addSubview(togglePanelButton)
        view.addSubview(keysContainerView)
        
        inputView!.backgroundColor = DefaultTheme.keyboardBackgroundColor
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModelsLoaded = 0
        searchBar.viewModel?.delegate = nil
        searchBar.suggestionsViewModel?.delegate = nil
        searchBar.viewModel = nil
        searchBar.textProcessor = nil
        searchBar.suggestionsViewModel = nil
        searchBar.searchResultsContainerView = nil
        textProcessor?.delegate = nil
        textProcessor = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        center.addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)
        center.addObserver(self, selector: "collapseKeyboard", name: CollapseKeyboardEvent, object: nil)
        center.addObserver(self, selector: "restoreKeyboard", name: RestoreKeyboardEvent, object: nil)
        center.addObserver(self, selector: "toggleShowKeyboardButton:", name: ToggleButtonKeyboardEvent, object: nil)
        center.addObserver(self, selector: "didTapOnMediaLink:", name: SearchResultsInsertLinkEvent, object: nil)
        
        togglePanelButton.addTarget(self, action: "toggleKeyboard", forControlEvents: .TouchUpInside)

    }
    
    override func viewDidAppear(animated: Bool) {
        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned
        dispatch_once(&KeyboardViewController.once_predicate) {
            if (!KeyboardViewController.debugKeyboard) {
                Fabric.with([Crashlytics()])
                Flurry.startSession(FlurryClientKey)
            }
            Firebase.defaultConfig().persistenceEnabled = true
        }
        
        dispatch_once(&viewModelsLoaded) {
            self.setupViewModels()
        }
    }
    
    func setupViewModels() {
        self.textProcessor = TextProcessingManager(textDocumentProxy: self.textDocumentProxy)
        self.textProcessor?.delegate = self
        
        viewModel = KeyboardViewModel()
        viewModel?.sessionManagerFlags.userHasOpenedKeyboard = true

        let baseURL = Firebase(url: BaseURL)
        let searchViewModel = SearchViewModel(base: baseURL)
        searchViewModel.delegate = searchBar
        
        let suggestionsViewModel = SearchSuggestionsViewModel(base: baseURL)
        suggestionsViewModel.delegate = searchBar
        suggestionsViewModel.suggestionsDelegate = searchBar
        
        searchBar.textProcessor = textProcessor
        searchBar.searchResultsContainerView = slidePanelContainerView
        searchBar.viewModel = searchViewModel
        searchBar.suggestionsViewModel = suggestionsViewModel
        
        if viewModel?.sessionManagerFlags.hasSeenKeyboardGeneralToolTips == false {
            toolTipViewController = ToolTipViewController()
            toolTipViewController?.closeButtonDelegate = self
            toolTipViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(toolTipViewController!.view)
            view.addConstraints([
                toolTipViewController!.view.al_top == view.al_top + searchBarHeight,
                toolTipViewController!.view.al_left == view.al_left,
                toolTipViewController!.view.al_right == view.al_right,
                toolTipViewController!.view.al_bottom == view.al_bottom
            ])
        }
    }
    
    override func viewDidLayoutSubviews() {
        if view.bounds == CGRectZero {
            return
        }
        
        setupLayout()
        
        let orientationSavvyBounds = CGRectMake(0, 0, view.bounds.width, heightForOrientation(interfaceOrientation, withTopBanner: false))
        if !(lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
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
        view.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.layer.shouldRasterize = true
        
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
        
        if (KeyboardViewController.debugKeyboard) {
            if let window = view.window {
                var frame = window.frame
                frame.origin.y = UIScreen.mainScreen().bounds.size.height - height
                frame.size.height = height
                window.frame = frame
            }
        }
        
        view.layer.shouldRasterize = false
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
        guard let userInfo = notification.userInfo,
            height = userInfo["height"] as? CGFloat else {
                return
        }
        
        togglePanelButton.hidden = true
        
        let keysContainerViewHeight = self.heightForOrientation(self.interfaceOrientation, withTopBanner: false)
        
        keysContainerView.layer.shouldRasterize = true
        keysContainerView.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        searchBarHeight = height + KeyboardSearchBarHeight
        keyboardHeight = keysContainerViewHeight + searchBarHeight
        
        self.searchBar.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.searchBarHeight)
        self.view.layoutIfNeeded()
        
        keysContainerView.layer.shouldRasterize = false
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
                if self.keyboardHeight == KeyboardHeight {
                    self.togglePanelButton.hidden = true
                    self.favoritesAndRecentsViewController?.view.hidden = true
                }
        }
    }
    
    func toggleKeyboard() {
        switch (togglePanelButton.mode) {
        case .ToggleKeyboard:
            if togglePanelButton.collapsed {
                restoreKeyboard()
            } else {
                collapseKeyboard()
            }
        case .ClosePanel:
            searchBar.resetSearchBar()
            restoreKeyboard()
            togglePanelButton.hidden = true
            favoritesAndRecentsViewController?.view.hidden = true
            togglePanelButton.mode = .ToggleKeyboard
        }
    }
    
    func toggleShowKeyboardButton(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let hide = userInfo["hide"] as? Bool else {
                return
        }
        
        togglePanelButton.hidden = hide
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        keyboardHeight = heightForOrientation(toInterfaceOrientation, withTopBanner: true)
        searchBar.searchBar.textInput.updateButtonPositions()
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
        if textProcessor?.shouldAutoCapitalize() == true {
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
        textProcessor?.textDidChange(textInput)
    }
    
    override func textWillChange(textInput: UITextInput?) {
        textProcessor?.textWillChange(textInput)
    }
    
    override func selectionWillChange(textInput: UITextInput?) {
        textProcessor?.selectionWillChange(textInput)
    }
    
    override func selectionDidChange(textInput: UITextInput?) {
        textProcessor?.selectionDidChange(textInput)
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
                case .modifier(.GoToBrowse, _):
                    keyView.addTarget(self, action: "didTapGoToBrowseKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
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

    func updateKeyboardLetterCases() {
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
    }
    
    func textProcessingManagerDidDetectFilter(textProcessingManager: TextProcessingManager, filter: Filter) {
        searchBar.setFilter(filter)
    }
    
    func textProcessingManagerDidTextContainerFilter(text: String) -> Filter? {
        return searchBar.suggestionsViewModel?.checkFilterInQuery(text)
    }
    
    func textProcessingManagerDidReceiveSpellCheckSuggestions(textProcessingManager: TextProcessingManager, suggestions: [SuggestItem]) {
        print("Suggestions", suggestions)
        searchBar.updateSuggestions(suggestions)
    }
    
    func textProcessingManagerDidClearTextBuffer(textProcessingManager: TextProcessingManager, text: String) {
        if let mediaLink = mediaLink {
            viewModel?.logTextSendEvent(mediaLink)
        }
    }

    // MARK: ToolTipCloseButtonDelegate
    func toolTipCloseButtonDidTap() {
        viewModel?.sessionManagerFlags.hasSeenKeyboardGeneralToolTips = true
        
        UIView.animateWithDuration(0.3, animations: {
            self.toolTipViewController!.view.alpha = 0.0
            }, completion: { done in
                self.toolTipViewController!.view.removeFromSuperview()
        })
    }
    
    func didTapOnMediaLink(notification: NSNotification) {
        guard let mediaLink = notification.object as? MediaLink else {
            return
        }
        self.mediaLink = mediaLink
    }
}

