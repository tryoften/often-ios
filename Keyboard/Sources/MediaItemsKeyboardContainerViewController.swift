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
    TextProcessingManagerDelegate {
    var mediaItem: MediaItem?
    var viewModel: KeyboardViewModel?
    var togglePanelButton: TogglePanelButton
    var tabChangeListener: Listener?
    var orientationChangeListener: Listener?

    var viewModelsLoaded: dispatch_once_t = 0
    var sectionsTabBarController: KeyboardSectionsContainerViewController
    var sections: [(MediaItemsKeyboardSection, UIViewController)]

    override init(extraHeight: CGFloat) {
        togglePanelButton = TogglePanelButton()
        togglePanelButton.mode = .SwitchKeyboard

        sectionsTabBarController = KeyboardSectionsContainerViewController()
        sections = []
        
        super.init(extraHeight: extraHeight)

        tabChangeListener = sectionsTabBarController.didChangeTab.on(onTabChange)
        
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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didInsertMediaItem:", name: "mediaItemInserted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupSections() {
        // Keyboard
        let keyboardVC = KeyboardContainerViewController(textProcessor: textProcessor!)
        keyboardVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfKeyboard(scale: 0.45), tag: 0)

        // Packs
        var packId = ""

        if let lastPack = SessionManagerFlags.defaultManagerFlags.lastPack {
            packId = lastPack
        }

        let packsVC = KeyboardBrowsePackItemViewController(packId: packId, viewModel: BrowseViewModel(), textProcessor: textProcessor)
        packsVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfPacktab(scale: 0.45), tag: 1)
        sections = [
            (.Keyboard, keyboardVC),
            (.Favorites, packsVC)
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

        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: "Changed Tab"), additionalProperties: [
            "item": tabItem.tag
        ])

        setupCurrentSection(section)
    }
    
    func onOrientationChanged() {
        let currentTab = sectionsTabBarController.currentTab
        let section = sections[currentTab].0

        if section != .Keyboard {
            hideKeyboard()
        }
    }

    func setupCurrentSection(section: MediaItemsKeyboardSection, changeHeight: Bool = true) {
        switch section {
        case .Keyboard:
            sectionsTabBarController.tabBar.layer.zPosition = -1
            togglePanelButton.hidden = true
            keyboardExtraHeight = 44
        case .Favorites:
            sectionsTabBarController.tabBar.layer.zPosition = 0
            togglePanelButton.hidden = true
            keyboardExtraHeight = 108
        default:
            sectionsTabBarController.tabBar.layer.zPosition = 0
            togglePanelButton.hidden = false
            keyboardExtraHeight = 108
        }
        
        if let navvc = sections[sectionsTabBarController.currentTab].1 as? UINavigationController, bvc = navvc.viewControllers.first as? BrowseViewController {
            bvc.collectionView?.performBatchUpdates(nil, completion: nil)
        }

        if changeHeight {
            keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        center.addObserver(self, selector: "hideKeyboard:", name: CollapseKeyboardEvent, object: nil)
        center.addObserver(self, selector: "showKeyboard:", name: RestoreKeyboardEvent, object: nil)
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

    func toggleShowKeyboardButton(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let hide = userInfo["hide"] as? Bool else {
                return
        }

        togglePanelButton.hidden = hide
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
