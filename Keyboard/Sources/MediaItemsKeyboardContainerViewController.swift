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
    ToolTipViewControllerDelegate,
    ConnectivityObservable,
    TextProcessingManagerDelegate {
    var mediaItem: MediaItem?
    var viewModel: KeyboardViewModel?
    var togglePanelButton: TogglePanelButton

    var viewModelsLoaded: dispatch_once_t = 0
    var sectionsTabBarController: KeyboardSectionsContainerViewController
    var sections: [(MediaItemsKeyboardSection, UIViewController)]
    var tooltipVC: ToolTipViewController?
    
    var isNetworkReachable: Bool = true
    var errorDropView: DropDownMessageView

    override init(extraHeight: CGFloat, debug: Bool) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

        sectionsTabBarController = KeyboardSectionsContainerViewController()
        sections = []
        
        errorDropView = DropDownMessageView()
        errorDropView.text = "NO INTERNET FAM :("
        errorDropView.hidden = true

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
        textProcessor?.delegate = self

        setupSections()
        view.backgroundColor = DefaultTheme.keyboardBackgroundColor

        containerView.addSubview(sectionsTabBarController.view)
        containerView.addSubview(togglePanelButton)

        showTooltipsIfNeeded()
        view.addSubview(errorDropView)
        startMonitoring()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didInsertMediaItem:", name: "mediaItemInserted", object: nil)
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
        let favoritesVC = KeyboardFavoritesAndRecentsViewController(viewModel: FavoritesService.defaultInstance, collectionType: .Favorites)
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfFavoritestab(scale: 0.45), tag: 0)
        favoritesVC.textProcessor = textProcessor

        // Recents
        let recentsVC = KeyboardFavoritesAndRecentsViewController(viewModel: FavoritesService.defaultInstance, collectionType: .Recents)
        recentsVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfRecentstab(scale: 0.45), tag: 1)
        recentsVC.textProcessor = textProcessor

        // Browse
        let browseVC = BrowseViewController(collectionViewLayout: BrowseViewController.getLayout(), viewModel: BrowseViewModel(), textProcessor: textProcessor)
        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSearchtab(scale: 0.45), tag: 2)
        browseVC.textProcessor = textProcessor
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateReachabilityStatusBar()
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

    func didInsertMediaItem(notification: NSNotification) {
        if let item = notification.object as? MediaItem {
            mediaItem = item
        }
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
    
    func updateReachabilityStatusBar() {
        if isNetworkReachable {
            UIView.animateWithDuration(0.3, animations: {
                self.errorDropView.frame = CGRectMake(0, -64, UIScreen.mainScreen().bounds.width, 64)
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                    self.errorDropView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64)
            })
            
            errorDropView.hidden = false
        }
    }

    //MARK: TextProcessingManagerDelegate

    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {}
    func textProcessingManagerDidClearTextBuffer(textProcessingManager: TextProcessingManager, text: String) {
        if let item = mediaItem {
            viewModel?.logTextSendEvent(item)
            
            let count = SessionManagerFlags.defaultManagerFlags.userMessageCount
            SessionManagerFlags.defaultManagerFlags.userMessageCount = count + 1
        }
    }
}
