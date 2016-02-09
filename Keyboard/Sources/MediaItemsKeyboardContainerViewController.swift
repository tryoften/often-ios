
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
    case Keyboard
    case Favorites
    case Recents
    case Trending
    case Search
}

class MediaItemsKeyboardContainerViewController: BaseKeyboardContainerViewController,
    UIScrollViewDelegate,
    ToolTipViewControllerDelegate,
    TextProcessingManagerDelegate {
    var mediaItem: MediaItem?
    var viewModel: KeyboardViewModel?
    var togglePanelButton: TogglePanelButton
    var tabChangeListener: Listener?
    var orientationChangeListener: Listener?

    var viewModelsLoaded: dispatch_once_t = 0
    var sectionsTabBarController: KeyboardSectionsContainerViewController
    var browseVC: BrowseViewController?
    var sections: [(MediaItemsKeyboardSection, UIViewController)]
    var tooltipVC: ToolTipViewController?

    override init(extraHeight: CGFloat) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

        sectionsTabBarController = KeyboardSectionsContainerViewController()
        sections = []
        
        super.init(extraHeight: extraHeight)

        tabChangeListener = sectionsTabBarController.didChangeTab.on(onTabChange)
        orientationChangeListener = sectionsTabBarController.didChangeOrientation.on(onOrientationChange)
        

        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned
        #if !(KEYBOARD_DEBUG)
        dispatch_once(&MediaItemsKeyboardContainerViewController.oncePredicate) {
            Fabric.sharedSDK().debug = true
            Fabric.with([Crashlytics.startWithAPIKey(FabricAPIKey)])
            Flurry.startSession(FlurryClientKey)
            Firebase.defaultConfig().persistenceEnabled = true
        }
        #endif

        viewModel = KeyboardViewModel()
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy)
        textProcessor?.delegate = self

        setupSections()
        view.backgroundColor = DefaultTheme.keyboardBackgroundColor

        containerView.addSubview(sectionsTabBarController.view)
        containerView.addSubview(togglePanelButton)

        showTooltipsIfNeeded()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didInsertMediaItem:", name: "mediaItemInserted", object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showTooltipsIfNeeded() {
        if viewModel?.sessionManagerFlags.hasSeenKeyboardSearchBarToolTips == false {
            if let tabBarItem = self.sectionsTabBarController.tabBar.items?[0] {
                self.sectionsTabBarController.tabBar.selectedItem = tabBarItem
                
            }
            tooltipVC = ToolTipViewController()
            tooltipVC?.delegate = self

            sectionsTabBarController.view.userInteractionEnabled = false

            view.addSubview(tooltipVC!.view)
        }
    }

    func setupSections() {
        // Keyboard
        let keyboardVC = KeyboardViewController(textProcessor: textProcessor!)
        keyboardVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfKeyboard(scale: 0.45), tag: 0)

        // Favorites
        let favoritesVC = KeyboardFavoritesAndRecentsViewController(viewModel: FavoritesService.defaultInstance, collectionType: .Favorites)
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfFavoritestab(scale: 0.45), tag: 1)
        favoritesVC.textProcessor = textProcessor

        // Recents
        let recentsVC = KeyboardFavoritesAndRecentsViewController(viewModel: MediaItemsViewModel(), collectionType: .Recents)
        recentsVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfRecentstab(scale: 0.45), tag: 2)
        recentsVC.textProcessor = textProcessor

        // Browse
        browseVC = BrowseViewController(collectionViewLayout: BrowseViewController.getLayout(), viewModel: BrowseViewModel(), textProcessor: textProcessor)
        browseVC!.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSearchtab(scale: 0.45), tag: 3)
        browseVC!.textProcessor = textProcessor

        let trendingNavigationVC = UINavigationController(rootViewController: browseVC!)
        trendingNavigationVC.view.backgroundColor = UIColor.clearColor()

        sections = [
            (.Keyboard, keyboardVC),
            (.Favorites, favoritesVC),
            (.Recents, recentsVC),
            (.Trending, trendingNavigationVC)
        ]

        sectionsTabBarController.viewControllers = sections.map { $0.1 }

        let currentTab = sectionsTabBarController.currentTab
        if let section = MediaItemsKeyboardSection(rawValue: currentTab) {
            setupCurrentSection(section, changeHeight: false)
        }

        viewDidLayoutSubviews()
    }

    func onTabChange(tabItem: UITabBarItem) {
        guard let section = MediaItemsKeyboardSection(rawValue: tabItem.tag) else {
            return
        }

        setupCurrentSection(section)
    }
    
    func onOrientationChange() {
        let currentTab = sectionsTabBarController.currentTab
        let section = sections[currentTab].0
        let controller = sections[currentTab].1
        
        switch section {
        case .Favorites,
             .Recents:
            if let vc = controller as? KeyboardFavoritesAndRecentsViewController {
                vc.collectionView?.performBatchUpdates(nil, completion: nil)
            }
        case .Trending:
            if let _ = browseVC {
                browseVC!.collectionView?.reloadData()
            }
        default:
            break
        }
    }

    func setupCurrentSection(section: MediaItemsKeyboardSection, changeHeight: Bool = true) {
        switch section {
        case .Keyboard:
            sectionsTabBarController.tabBar.layer.zPosition = -1
            togglePanelButton.hidden = true
            keyboardExtraHeight = 44
        default:
            sectionsTabBarController.tabBar.layer.zPosition = 0
            togglePanelButton.hidden = false
            keyboardExtraHeight = 144
        }

        if changeHeight {
            keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
        }
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

    func didInsertMediaItem(notification: NSNotification) {
        if let item = notification.object as? MediaItem {
            mediaItem = item
        }
    }

    func closeToolTipButtonDidTap(sender: UIButton) {
        viewModel?.sessionManagerFlags.hasSeenKeyboardSearchBarToolTips = true

        UIView.animateWithDuration(0.3) {
            if let tabBarItem = self.sectionsTabBarController.tabBar.items?[1] {
                self.sectionsTabBarController.tabBar.selectedItem = tabBarItem

            }
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
