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
    var visualEffectView: UIView
    var alertView: AlertView

    private var alertViewTopAndBottomMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 120
        }
        return 140
    }

    private var alertViewLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 32
        }
        return 42
    }
    
    init() {
        visualEffectView = UIView(frame: UIScreen.mainScreen().bounds)
        visualEffectView.backgroundColor = BlackColor
        visualEffectView.alpha = 0.74

        alertView = AlertView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.layer.cornerRadius = 5.0
        
        super.init(nibName: nil, bundle: nil)
        
        styleTabBar()
        setupTabBarItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delay(0.3) {
            self.showMajorKeyAlert()
        }
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    func showMajorKeyAlert() {
        if SessionManagerFlags.defaultManagerFlags.userSeenKeyboardInstallWalkthrough {
            PKHUD.sharedHUD.hide(animated: true)
            
            alertView.actionButton.addTarget(self, action: "actionButtonDidTap:", forControlEvents: .TouchUpInside)

            view.addSubview(visualEffectView)
            view.addSubview(alertView)
            view.addConstraints([
                alertView.al_centerX == view.al_centerX,
                alertView.al_centerY == view.al_centerY,
                alertView.al_top == view.al_top + alertViewTopAndBottomMargin,
                alertView.al_bottom == view.al_bottom - alertViewTopAndBottomMargin,
                alertView.al_right == view.al_right - alertViewLeftAndRightMargin,
                alertView.al_left == view.al_left + alertViewLeftAndRightMargin,
            ])

            alertView.animate()
            
        }
    }

    func actionButtonDidTap(sender: UIButton) {
        alertView.removeFromSuperview()
        visualEffectView.removeFromSuperview()
        SessionManagerFlags.defaultManagerFlags.userSeenKeyboardInstallWalkthrough = false
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
        var userProfileVC: UIViewController

        if SessionManagerFlags.defaultManagerFlags.userIsAnonymous {
            userProfileVC = SkipSignupViewController(viewModel: LoginViewModel(sessionManager: sessionManager))
        } else {
            userProfileVC = UserProfileViewController(
                collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(),
                viewModel: FavoritesService.defaultInstance)
        }

        let browseVC = ContainerNavigationController(rootViewController: MainAppBrowseViewController(
                collectionViewLayout: MainAppBrowseViewController.provideCollectionViewLayout(),
                viewModel: BrowseViewModel(), textProcessor: nil))

        let settingVC = ContainerNavigationController(rootViewController: AppSettingsViewController(
            viewModel: SettingsViewModel(sessionManager: sessionManager)))

        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfTrending(scale: 0.45), tag: 0)
        browseVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 20, -8, -20)

        userProfileVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfProfile(scale: 0.45), tag: 1)
        userProfileVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)

        settingVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfSettings(scale: 0.45), tag: 2)
        settingVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, -20, -8, 20)
        settingVC.navigationBar.tintColor = BlackColor

        viewControllers = [
            browseVC,
            userProfileVC,
            settingVC
        ]
        
        selectedIndex = 0
    }
}