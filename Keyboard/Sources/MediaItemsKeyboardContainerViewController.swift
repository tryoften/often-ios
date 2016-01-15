//
//  MediaItemsKeyboardContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

enum MediaItemsKeyboardSection: Int {
    case Favorites
    case Recents
    case Trending
    case Search
}

class MediaItemsKeyboardContainerViewController: BaseKeyboardContainerViewController,
    UIScrollViewDelegate,
    ToolTipViewControllerDelegate {
    var mediaLink: MediaItem?
    var viewModel: KeyboardViewModel?
    var togglePanelButton: TogglePanelButton

    var viewModelsLoaded: dispatch_once_t = 0
    var sectionsTabBarController: KeyboardSectionsContainerViewController
    var sections: [(MediaItemsKeyboardSection, UIViewController)]
    var tooltipVC: ToolTipViewController?

    override init(extraHeight: CGFloat, debug: Bool) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

        sectionsTabBarController = KeyboardSectionsContainerViewController()
        sections = []

        super.init(extraHeight: extraHeight, debug: debug)

        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned
        dispatch_once(&MediaItemsKeyboardContainerViewController.oncePredicate) {
            if !self.debugKeyboard {
                Fabric.with([Crashlytics()])
                Flurry.startSession(FlurryClientKey)
                Firebase.defaultConfig().persistenceEnabled = true
            }
        }

        viewModel = KeyboardViewModel()
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy)

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
        let mediaLinksViewModel = MediaItemsViewModel()
        let favoritesVC = KeyboardFavoritesAndRecentsViewController(viewModel: mediaLinksViewModel, collectionType: .Favorites)
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfFavoritestab(scale: 0.45), tag: 0)

        // Recents
        let recentsVC = KeyboardFavoritesAndRecentsViewController(viewModel: mediaLinksViewModel, collectionType: .Recents)
        recentsVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfRecentstab(scale: 0.45), tag: 1)

        // Browse
        let browseVC = BrowseViewController(collectionViewLayout: BrowseViewController.getLayout(), viewModel: BrowseViewModel(), textProcessor: textProcessor)
        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSearchtab(scale: 0.45), tag: 2)
        let trendingNavigationVC = UINavigationController(rootViewController: browseVC)

        sections = [
            (.Favorites, favoritesVC),
            (.Recents, recentsVC),
            (.Trending, trendingNavigationVC)
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
        center.addObserver(self, selector: "didTapOnMediaItem:", name: SearchResultsInsertLinkEvent, object: nil)
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
            self.sectionsTabBarController.tabBar.selectedItem = self.sectionsTabBarController.tabBar.items![0]
            self.tooltipVC?.view.alpha = 0
            self.tooltipVC?.delegate = nil
            self.tooltipVC?.view.removeFromSuperview()
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
        if let toolBarItems = sectionsTabBarController.tabBar.items
            where currentPage <= sectionsTabBarController.viewControllers.count && currentPage <= toolBarItems.count {
            sectionsTabBarController.tabBar.selectedItem = toolBarItems[currentPage]
        }
    }

}

extension UIScrollView {

}