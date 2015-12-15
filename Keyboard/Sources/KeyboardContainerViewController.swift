//
//  KeyboardViewController.swift
//  Surf
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Surf. All rights reserved.
//
//  swiftlint:disable variable_name

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

class KeyboardContainerViewController: BaseKeyboardContainerViewController, TextProcessingManagerDelegate, ToolTipCloseButtonDelegate {
    var viewModel: KeyboardViewModel?
    var textProcessor: TextProcessingManager?
    var togglePanelButton: TogglePanelButton
    var slidePanelContainerView: UIView
    var searchBar: SearchBarController
    var mediaLink: MediaLink?
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var kludge: UIView?
    static var debugKeyboard = false

    var toolTipViewController: ToolTipViewController?
    var favoritesAndRecentsViewController: KeyboardMediaLinksAndFilterBarViewController?

    var viewModelsLoaded: dispatch_once_t = 0
    
    override init(extraHeight: CGFloat, debug: Bool = false) {
        let searchViewModel = SearchViewModel(base: Firebase(url: BaseURL))
        searchBar = SearchBarController(viewModel: searchViewModel)
        searchBarHeight = KeyboardSearchBarHeight
        
        togglePanelButton = TogglePanelButton()
        togglePanelButton.hidden = true
        togglePanelButton.mode = .ToggleKeyboard

        slidePanelContainerView = UIView()
        slidePanelContainerView.accessibilityIdentifier = "Slide Panel"

        super.init(extraHeight: extraHeight, debug: debug)

        textProcessor = TextProcessingManager(textDocumentProxy: self.textDocumentProxy)
        textProcessor?.delegate = self

        keyboard = KeyboardViewController(textProcessor: textProcessor!)
        searchBar.viewModel = searchViewModel
        searchViewModel.delegate = searchBar

        containerView.addSubview(keyboard!.view)
        containerView.addSubview(searchBar.view)
        containerView.addSubview(slidePanelContainerView)
        containerView.addSubview(togglePanelButton)

        inputView!.backgroundColor = DefaultTheme.keyboardBackgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModelsLoaded = 0
        searchBar.viewModel.delegate = nil
        searchBar.suggestionsViewModel?.delegate = nil
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
        dispatch_once(&BaseKeyboardContainerViewController.oncePredicate) {
            if (!self.debugKeyboard) {
                Fabric.with([Crashlytics()])
                Flurry.startSession(FlurryClientKey)
                Firebase.defaultConfig().persistenceEnabled = true
            }
        }
        
        dispatch_once(&viewModelsLoaded) {
            self.setupViewModels()
        }
    }
    
    func setupViewModels() {
        viewModel = KeyboardViewModel()
        viewModel?.sessionManagerFlags.userHasOpenedKeyboard = true

        let baseURL = Firebase(url: BaseURL)
        let suggestionsViewModel = SearchSuggestionsViewModel(base: baseURL)
        suggestionsViewModel.delegate = searchBar
        suggestionsViewModel.suggestionsDelegate = searchBar
        
        searchBar.textProcessor = textProcessor
        searchBar.searchResultsContainerView = slidePanelContainerView

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
        super.viewDidLayoutSubviews()

        let height = CGRectGetHeight(self.view.frame) - 30
        var togglePanelButtonFrame = self.containerView.frame
        togglePanelButtonFrame.origin.y = height
        togglePanelButtonFrame.size.height = 30
        self.togglePanelButton.frame = togglePanelButtonFrame

        containerView.frame = view.bounds

        slidePanelContainerView.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(containerView.frame), CGRectGetHeight(self.view.frame) - KeyboardSearchBarHeight)
        searchBar.view.frame = CGRectMake(0, 0, view.bounds.width, searchBarHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.view.hidden = false
    }
    
    func resizeKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            height = userInfo["height"] as? CGFloat else {
                return
        }
        
        togglePanelButton.hidden = true
        
        let keysContainerViewHeight = self.heightForOrientation(interfaceOrientation, withTopBanner: false)

        searchBarHeight = height + KeyboardSearchBarHeight
        keyboardHeight = keysContainerViewHeight + 144
        
        self.searchBar.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.searchBarHeight)
        self.view.layoutIfNeeded()
        
//        keysContainerView.layer.shouldRasterize = false
    }
    
    func collapseKeyboard() {
        togglePanelButton.collapsed = true
//        keysContainerView.collapsed = true
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
//            let height = CGRectGetHeight(self.view.frame) - 30
//            var keysContainerViewFrame = self.keysContainerView.frame
//            keysContainerViewFrame.origin.y = CGRectGetHeight(self.view.frame)
//            self.keysContainerView.frame = keysContainerViewFrame
//            var togglePanelButtonFrame = self.keysContainerView.frame
//            togglePanelButtonFrame.origin.y = height
//            togglePanelButtonFrame.size.height = 30
//            self.togglePanelButton.frame = togglePanelButtonFrame
        }) { done in
            self.togglePanelButton.hidden = false
        }
    }
    
    func restoreKeyboard() {
        togglePanelButton.collapsed = false
//        keysContainerView.collapsed = false
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
//            self.keysContainerView.frame.origin = CGPointMake(0, self.view.bounds.height - self.keysContainerView.bounds.height)
//            self.togglePanelButton.frame.origin.y = self.keysContainerView.frame.origin.y - 30
            }) { done in
                if self.keyboardHeight == KeyboardHeight {
                    self.togglePanelButton.hidden = true
                    self.favoritesAndRecentsViewController?.view.hidden = true
                }
        }
    }
    
    func toggleKeyboard() {
        switch togglePanelButton.mode {
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
        case .SwitchKeyboard:
            break
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
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        searchBar.searchBar.textInput.updateButtonPositions()
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


    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
//        setCapsIfNeeded()
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

