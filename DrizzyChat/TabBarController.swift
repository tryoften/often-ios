//
//  TabBarController.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var backgroundView: UIView
    var barBorderView: UIView
    var sessionManager: SessionManager

    init (sessionManager: SessionManager = SessionManager.defaultManager) {
        self.sessionManager = sessionManager
        
        backgroundView = UIView()
        backgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        barBorderView = UIView()
        barBorderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        barBorderView.backgroundColor = UIColor(fromHexString: "#f9b341")

        super.init(nibName: nil, bundle: nil)
        
        backgroundView.backgroundColor = UIColor.blackColor()

        tabBar.barStyle = .Black
        tabBar.tintColor = UIColor(fromHexString: "#f9b341")
        tabBar.addSubview(backgroundView)
        tabBar.addSubview(barBorderView)
        
        view.addConstraints([
            barBorderView.al_width == tabBar.al_width,
            barBorderView.al_left == tabBar.al_left,
            barBorderView.al_height == 3,
            barBorderView.al_top == tabBar.al_top - 3,
            
            backgroundView.al_width == tabBar.al_width,
            backgroundView.al_top == barBorderView.al_bottom,
            backgroundView.al_left == tabBar.al_left,
            backgroundView.al_height == tabBar.al_height
        ])
        
        var viewModel = UserProfileViewModel(sessionManager: sessionManager)
        var userProfileVC = BaseNavigationController(rootViewController: UserProfileViewController(viewModel: viewModel))

        var addKeyboardsVC = BrowseCollectionViewController(viewModel: BrowseViewModel())
        var trendingVC = TrendingCollectionViewController(viewModel: TrendingViewModel(sessionManager: sessionManager))
        
        var iconInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        userProfileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ProfileIcon"), tag: 0)
        userProfileVC.tabBarItem.imageInsets = iconInsets
        
        addKeyboardsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "AddKeyboardIcon"), tag: 1)
        addKeyboardsVC.tabBarItem.imageInsets = iconInsets
        
        trendingVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "TrendingIcon"), tag: 2)
        trendingVC.tabBarItem.imageInsets = iconInsets
        
        viewControllers = [
            userProfileVC,
            addKeyboardsVC,
            trendingVC
        ]
    }
    
    deinit {
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
