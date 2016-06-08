//
//  RootViewController.swift
//  Often
//
//  Created by Luc Succes on 10/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController, UIViewControllerTransitioningDelegate {
    let sessionManager = SessionManager.defaultManager

    private var alertViewTopAndBottomMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 120
        }
        return 140
    }

    private var alertViewLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 32
        }
        return 42
    }
    
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
        delay(0.3) {
            self.showAlert()
        }
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    func showAlert() {
        if SessionManagerFlags.defaultManagerFlags.userSeenKeyboardInstallWalkthrough {
            PKHUD.sharedHUD.hide(animated: true)
            var AlertVC = AlertViewViewController()

            AlertVC.transitioningDelegate = self
            AlertVC.modalPresentationStyle = .Custom
            presentViewController(AlertVC, animated: true, completion: nil)
        }
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
            userProfileVC = ContainerNavigationController(
                rootViewController: UserProfileViewController(viewModel: PacksService.defaultInstance)
            )
        }

        let browseVC = ContainerNavigationController(rootViewController: BrowsePackCollectionViewController(viewModel: PacksViewModel()))

        let settingVC = ContainerNavigationController(rootViewController: AppSettingsViewController(
            viewModel: SettingsViewModel(sessionManager: sessionManager)))

        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfPacktab(scale: 0.55), tag: 0)
        browseVC.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 20, -4, -20)

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

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInTransitionAnimator(presenting: true)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: false)

        return animator
    }
}