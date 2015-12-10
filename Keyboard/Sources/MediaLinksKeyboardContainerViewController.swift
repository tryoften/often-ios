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
    var mediaLinksViewController: KeyboardMediaLinksAndFilterBarViewController?
    var trendingViewController: TrendingLyricsViewController?
    var togglePanelButton: TogglePanelButton
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight

    var mediaLinksView: UIView?
    var viewModelsLoaded: dispatch_once_t = 0

    override init(extraHeight: CGFloat, debug: Bool) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

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
        mediaLinksView = mediaLinksViewController!.view

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
        center.addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)
        center.addObserver(self, selector: "collapseKeyboard", name: CollapseKeyboardEvent, object: nil)
        center.addObserver(self, selector: "restoreKeyboard", name: RestoreKeyboardEvent, object: nil)
        center.addObserver(self, selector: "toggleShowKeyboardButton:", name: ToggleButtonKeyboardEvent, object: nil)
        center.addObserver(self, selector: "didTapOnMediaLink:", name: SearchResultsInsertLinkEvent, object: nil)

        togglePanelButton.addTarget(self, action: "switchKeyboard", forControlEvents: .TouchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRectZero {
            return
        }

        mediaLinksView!.frame = containerView.bounds
        trendingViewController!.view.frame = containerView.bounds

        let height = CGRectGetHeight(view.frame) - 30
        var togglePanelButtonFrame = containerView.frame
        togglePanelButtonFrame.origin.y = height
        togglePanelButtonFrame.size.height = 30
        togglePanelButton.frame = togglePanelButtonFrame
    }

    func setupViewModels() {
        textProcessor = TextProcessingManager(textDocumentProxy: self.textDocumentProxy)
        textProcessor?.delegate = self
        mediaLinksViewController?.textProcessor = textProcessor
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