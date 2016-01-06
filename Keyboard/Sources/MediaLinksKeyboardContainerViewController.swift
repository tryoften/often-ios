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

enum MediaLinksKeyboardSection: Int {
    case Favorites
    case Recents
    case Trending
    case Search
}

class MediaLinksKeyboardContainerViewController: BaseKeyboardContainerViewController,
    TextProcessingManagerDelegate,
    UIScrollViewDelegate,
    ToolTipViewControllerDelegate {
    var mediaLink: MediaLink?
    var viewModel: KeyboardViewModel?
    var togglePanelButton: TogglePanelButton

    var viewModelsLoaded: dispatch_once_t = 0
    var sectionsTabBarController: KeyboardSectionsContainerViewController
    var sections: [(MediaLinksKeyboardSection, UIViewController)]
    var tooltipVC: ToolTipViewController?

    override init(extraHeight: CGFloat, debug: Bool) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

        sectionsTabBarController = KeyboardSectionsContainerViewController()
        sections = []

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

        viewModel = KeyboardViewModel()

        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy)
        textProcessor!.delegate = self

        setupSections()

        view.backgroundColor = DefaultTheme.keyboardBackgroundColor

        containerView.addSubview(sectionsTabBarController.view)
        containerView.addSubview(togglePanelButton)

        showTooltipsIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showTooltipsIfNeeded() {
        if viewModel?.sessionManagerFlags.hasSeenKeyboardSearchBarToolTips == false {
            tooltipVC = ToolTipViewController()
            tooltipVC?.delegate = self
            tooltipVC?.closeButton.addTarget(self, action: "closeToolTipButtonDidTap:", forControlEvents: .TouchUpInside)

            sectionsTabBarController.view.userInteractionEnabled = false

            view.addSubview(tooltipVC!.view)
        }
    }

    func setupSections() {
        // Favorites
        let mediaLinksViewModel = MediaLinksViewModel()
        let favoritesVC = KeyboardFavoritesAndRecentsViewController(viewModel: mediaLinksViewModel, collectionType: .Favorites)
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfFavoritestab(scale: 0.45), tag: 0)

        // Recents
        let recentsVC = KeyboardFavoritesAndRecentsViewController(viewModel: mediaLinksViewModel, collectionType: .Recents)
        recentsVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfRecentstab(scale: 0.45), tag: 1)

        // Trending
        let trendingVC = TrendingLyricsViewController(collectionViewLayout: TrendingLyricsViewController.getLayout(), viewModel: TrendingLyricsViewModel())
        trendingVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfTrendingtab(scale: 0.45), tag: 2)
        let trendingNavigationVC = UINavigationController(rootViewController: trendingVC)

        // Search
        let baseURL = Firebase(url: BaseURL)
        let searchVC = SearchViewController(
            viewModel: SearchViewModel(base: baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            textProcessor: textProcessor!,
            SearchBarControllerClass: KeyboardSearchBarController.self,
            SearchBarClass: KeyboardSearchBar.self)

        if let keyboardSearchBarController = searchVC.searchBarController as? KeyboardSearchBarController {
            keyboardSearchBarController.textProcessor = textProcessor!
        }

        searchVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSearchtab(scale: 0.45), tag: 3)
        let searchNavigationVC = UINavigationController(rootViewController: searchVC)
        searchNavigationVC.navigationBarHidden = true

        sections = [
            (.Favorites, favoritesVC),
            (.Recents, recentsVC),
            (.Trending, trendingNavigationVC),
            (.Search, searchNavigationVC)
        ]

        sectionsTabBarController.viewControllers = sections.map { $0.1 }
        viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        center.addObserver(self, selector: "hideKeyboard", name: CollapseKeyboardEvent, object: nil)
        center.addObserver(self, selector: "showKeyboard", name: RestoreKeyboardEvent, object: nil)
        center.addObserver(self, selector: "didTapOnMediaLink:", name: SearchResultsInsertLinkEvent, object: nil)
        center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)

        togglePanelButton.addTarget(self, action: "switchKeyboard", forControlEvents: .TouchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRectZero {
            return
        }

        let height = CGRectGetHeight(view.frame) - 30
        var togglePanelButtonFrame = containerView.frame
        togglePanelButtonFrame.origin.y = height
        togglePanelButtonFrame.size.height = 30
        togglePanelButton.frame = togglePanelButtonFrame
        sectionsTabBarController.view.frame = view.bounds

        let tabBarHeight = sectionsTabBarController.tabBarHeight
        tooltipVC?.view.frame = CGRectMake(0, tabBarHeight, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) - tabBarHeight)
    }

    func resizeKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            _ = userInfo["height"] as? CGFloat else {
                return
        }
    }

    func didTapEnterButton(button: KeyboardKeyButton?) {
    }

    func closeToolTipButtonDidTap(sender: UIButton) {
        viewModel?.sessionManagerFlags.hasSeenKeyboardSearchBarToolTips = true

        UIView.animateWithDuration(0.3) {
            self.tooltipVC?.view.alpha = 0
            self.tooltipVC?.view.removeFromSuperview()
            self.tooltipVC?.delegate = nil
            self.sectionsTabBarController.view.userInteractionEnabled = true
        }
    }

    func toggleShowKeyboardButton(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let hide = userInfo["hide"] as? Bool else {
                return
        }

        togglePanelButton.hidden = hide
    }

    //MARK: ToolTipViewControllerDelegate
    func toolTipViewControllerCurrentPage(toolTipViewController: ToolTipViewController, currentPage: Int) {
        if let toolBarItems = sectionsTabBarController.tabBar.items where currentPage <= sectionsTabBarController.viewControllers.count && currentPage <= toolBarItems.count {
            sectionsTabBarController.selectedViewController = sectionsTabBarController.viewControllers[currentPage]
            sectionsTabBarController.tabBar.selectedItem = toolBarItems[currentPage]
        }
    }

    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
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

extension UIScrollView {

}