//
//  TabBarController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    var backgroundView: UIView
    
    init () {
        backgroundView = UIView()
        backgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(nibName: nil, bundle: nil)
        
        backgroundView.backgroundColor = WhiteColor
        
        tabBar.barStyle = .Default
        tabBar.tintColor = TealColor
        tabBar.addSubview(backgroundView)
        
        view.addConstraints([
            backgroundView.al_width == tabBar.al_width,
            backgroundView.al_top == tabBar.al_top,
            backgroundView.al_left == tabBar.al_left,
            backgroundView.al_height == tabBar.al_height
        ])
        
        var userProfileVC = ServiceSettingsCollectionViewController(collectionViewLayout: ServiceSettingsCollectionViewController.provideCollectionViewLayout())
        var settingsVC = SettingsViewController()
        
        var iconInsets = UIEdgeInsetsMake(3, -3, -3, 3)
        
        userProfileVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfUser(frame: CGRectMake(0, 0, 30, 30), color: DarkGrey), tag: 0)
        userProfileVC.tabBarItem.imageInsets = iconInsets
        
        settingsVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSettings(frame: CGRectMake(0, 0, 30, 30), color: DarkGrey), tag: 1)
        settingsVC.tabBarItem.imageInsets = iconInsets

        viewControllers = [
            settingsVC,
            userProfileVC
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
