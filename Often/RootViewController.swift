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
    private let imageView: UIImageView
    private let dummyTabBar: UIView

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
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "tabBarLip")
        imageView.contentMode = .ScaleAspectFit

        dummyTabBar = UIView()
        dummyTabBar.backgroundColor = UIColor.oftWhiteColor()
        dummyTabBar.layer.shadowOffset = CGSizeMake(0, 0)
        dummyTabBar.layer.shadowOpacity = 0.8
        dummyTabBar.layer.shadowColor = DarkGrey.CGColor
        dummyTabBar.layer.shadowRadius = 4

        super.init(nibName: nil, bundle: nil)

        dummyTabBar.frame = tabBar.frame
        
        styleTabBar()
        setupTabBarItems()
        view.insertSubview(imageView, belowSubview: tabBar)
        view.insertSubview(dummyTabBar, belowSubview: imageView)

        setupLayout()

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

    func setupLayout() {
        view.addConstraints([
            imageView.al_centerX == view.al_centerX,
            imageView.al_bottom == view.al_bottom,
            imageView.al_height == 80,
            imageView.al_width == 80
            ])
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    func showAlert() {
        if SessionManagerFlags.defaultManagerFlags.userSeenKeyboardInstallWalkthrough {
            PKHUD.sharedHUD.hide(animated: true)
            let AlertVC = AlertViewController()

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
    }
    func setupTabBarItems() {

        var userProfileVC: UIViewController

        if SessionManagerFlags.defaultManagerFlags.userIsAnonymous {
            userProfileVC = SkipSignupViewController(viewModel: LoginViewModel(sessionManager: sessionManager))
        } else {
            userProfileVC = ContainerNavigationController(
                rootViewController: UserProfileViewController(viewModel: PacksService.defaultInstance))
        }

        let browseVC = ContainerNavigationController(rootViewController: BrowsePackCollectionViewController(viewModel: PacksViewModel()))
        
        let addContentVC = ContainerNavigationController(rootViewController: AddContentViewController())

        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfPacktab(scale: 0.55), tag: 0)
        browseVC.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 20, -4, -20)

        addContentVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfPluscopy(scale: 0.8), tag: 1)
        addContentVC.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        addContentVC.navigationBar.tintColor = TealColor

        userProfileVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfProfile(scale: 0.45), tag: 2)
        userProfileVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, -20, -8, 20)


        viewControllers = [
            browseVC,
            addContentVC,
            userProfileVC
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