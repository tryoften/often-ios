//
//  RootViewController.swift
//  Often
//
//  Created by Luc Succes on 10/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    let sessionManager = SessionManager.defaultManager
    
    init() {
        super.init(nibName: nil, bundle: nil)

        styleTabBar()
        setupTabBarItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func styleTabBar() {
        tabBar.backgroundColor = WhiteColor
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.translucent = false
        tabBar.tintColor = BlackColor
        tabBar.layer.shadowOffset = CGSizeMake(0, 0)
        tabBar.layer.shadowOpacity = 0.8
        tabBar.layer.shadowColor = DarkGrey.CGColor
        tabBar.layer.shadowRadius = 4
    }

    func setupTabBarItems() {
        let userProfileVC = UserProfileViewController(
            collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(),
            viewModel: MediaItemsViewModel())

        let browseVC = ContainerNavigationController(rootViewController: MainAppBrowseViewController(
                collectionViewLayout: MainAppBrowseViewController.provideCollectionViewLayout(),
                viewModel: TrendingLyricsViewModel(), textProcessor: nil))

        let settingVC = ContainerNavigationController(rootViewController: AppSettingsViewController(
            viewModel: SettingsViewModel(sessionManager: sessionManager)))

        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfTrending(scale: 0.45), tag: 0)
        browseVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 20, -8, -20)

        userProfileVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfProfile(scale: 0.45), tag: 1)
        userProfileVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)

        settingVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSettings(scale: 0.45), tag: 2)
        settingVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, -20, -8, 20)

        viewControllers = [
            browseVC,
            userProfileVC,
            settingVC
        ]
        
        selectedIndex = 1
    }

}