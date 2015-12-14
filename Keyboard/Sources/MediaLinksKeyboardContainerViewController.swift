//
//  MediaLinksKeyboardContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class MediaLinksKeyboardContainerViewController: BaseKeyboardContainerViewController, TextProcessingManagerDelegate {
    var mediaLink: MediaLink?
    var viewModel: MediaLinksViewModel?
    var textProcessor: TextProcessingManager?
    var searchBar: SearchBarController
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var mediaLinksViewController: KeyboardMediaLinksAndFilterBarViewController?
    var trendingViewController: TrendingLyricsViewController?
    var togglePanelButton: TogglePanelButton
    var slidePanelContainerView: UIView
    var viewModelsLoaded: dispatch_once_t = 0

    override init(extraHeight: CGFloat, debug: Bool) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

        searchBar = SearchBarController(nibName: nil, bundle: nil)
        searchBarHeight = KeyboardSearchBarHeight

        slidePanelContainerView = UIView()

        super.init(extraHeight: extraHeight, debug: debug)

        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned
        dispatch_once(&MediaLinksKeyboardContainerViewController.oncePredicate) {
            if !self.debugKeyboard {
                Fabric.with([Crashlytics()])
                Flurry.startSession(FlurryClientKey)
                Firebase.defaultConfig().persistenceEnabled = true
            }
        }

        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy)
        textProcessor!.delegate = self

        viewModel = MediaLinksViewModel()
        trendingViewController = TrendingLyricsViewController(viewModel: TrendingLyricsViewModel())

        view.backgroundColor = DefaultTheme.keyboardBackgroundColor

        view.addSubview(searchBar.view)
        containerView.addSubview(slidePanelContainerView)
        containerView.addSubview(trendingViewController!.view)
        containerView.addSubview(togglePanelButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
//        center.addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)
        center.addObserver(self, selector: "hideKeyboard", name: CollapseKeyboardEvent, object: nil)
        center.addObserver(self, selector: "showKeyboard", name: RestoreKeyboardEvent, object: nil)
        center.addObserver(self, selector: "toggleShowKeyboardButton:", name: ToggleButtonKeyboardEvent, object: nil)
        center.addObserver(self, selector: "didTapOnMediaLink:", name: SearchResultsInsertLinkEvent, object: nil)
        center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)

        togglePanelButton.addTarget(self, action: "switchKeyboard", forControlEvents: .TouchUpInside)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        dispatch_once(&viewModelsLoaded) {
            self.setupViewModels()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRectZero {
            return
        }
        if searchBar.searchBar.textInput.selected {
            searchBar.view.frame = CGRectMake(0, 0, view.bounds.width, searchBarHeight + 100)
        } else {
            searchBar.view.frame = CGRectMake(0, 0, view.bounds.width, searchBarHeight)
        }
        trendingViewController!.view.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame) - KeyboardSearchBarHeight)

        let height = CGRectGetHeight(view.frame) - 30
        var togglePanelButtonFrame = containerView.frame
        togglePanelButtonFrame.origin.y = height
        togglePanelButtonFrame.size.height = 30
        togglePanelButton.frame = togglePanelButtonFrame

        slidePanelContainerView.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(containerView.frame), CGRectGetHeight(self.view.frame) - KeyboardSearchBarHeight)
    }

    func setupViewModels() {
        textProcessor = TextProcessingManager(textDocumentProxy: self.textDocumentProxy)
        textProcessor?.delegate = self
        mediaLinksViewController?.textProcessor = textProcessor

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
    }

    func resizeKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            height = userInfo["height"] as? CGFloat else {
                return
        }
    }

    func showKeyboard() {
        trendingViewController!.view.hidden = true
        if keyboard == nil {
            keyboard = KeyboardViewController(nibName: nil, bundle: nil)
            containerView.addSubview(keyboard!.view)
            self.viewDidLayoutSubviews()
        } else {
            keyboard!.view.hidden = false
        }
    }

    func hideKeyboard() {
        trendingViewController!.view.hidden = false
        guard let keyboard = keyboard else {
            return
        }
        keyboard.view.hidden = true
    }

    func didTapEnterButton(button: KeyboardKeyButton?) {
        trendingViewController!.view.hidden = true
    }

    func toggleShowKeyboardButton(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let hide = userInfo["hide"] as? Bool else {
                return
        }

        togglePanelButton.hidden = hide
    }


    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
    }

    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType) {
    }

    func textProcessingManagerDidDetectFilter(textProcessingManager: TextProcessingManager, filter: Filter) {
    }

    func textProcessingManagerDidTextContainerFilter(text: String) -> Filter? {
        return nil
    }

    func textProcessingManagerDidReceiveSpellCheckSuggestions(textProcessingManager: TextProcessingManager, suggestions: [SuggestItem]) {
    }

    func textProcessingManagerDidClearTextBuffer(textProcessingManager: TextProcessingManager, text: String) {
    }

}