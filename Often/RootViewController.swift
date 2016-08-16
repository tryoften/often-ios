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
    private var userProfilePresented: Bool = false
    private enum SelectedTab: Int {
        case Browse = 0
        case AddContent = 1
        case UserProfile = 2
    }

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.addContentViewDidDismiss(_:)), name: AddContentViewDismissedEvent, object: nil)

        styleTabBar()
        setupTabBarItems()
        view.insertSubview(imageView, belowSubview: tabBar)
        view.insertSubview(dummyTabBar, belowSubview: imageView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func setupLayout() {
        view.addConstraints([
            imageView.al_centerX == view.al_centerX,
            imageView.al_bottom == view.al_bottom,
            imageView.al_height == 75,
            imageView.al_width == 75
        ])
    }

    func showAlert() {
        if !SessionManagerFlags.defaultManagerFlags.isKeyboardInstalled {
            PKHUD.sharedHUD.hide(animated: true)

            let AlertVC = KeyboardInstallAlertViewController(alertView: KeyboardInstallAlertView.self)

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

        browseVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfCollectionsCards(scale: 0.55), tag: 0)
        browseVC.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 20, -4, -20)

        addContentVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfPluscopy().imageWithRenderingMode(.AlwaysOriginal), tag: 1)
        addContentVC.navigationBar.tintColor = TealColor

        userProfileVC.tabBarItem = UITabBarItem(title: "", image: StyleKit.imageOfProfile(scale: 0.45), tag: 2)
        userProfileVC.tabBarItem.imageInsets = UIEdgeInsetsMake(8, -20, -8, 20)

        viewControllers = [
            browseVC,
            addContentVC,
            userProfileVC
        ]
        
        selectedIndex = SelectedTab.Browse.rawValue
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInTransitionAnimator(presenting: true)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: false)
        return animator
    }
    
    func addContentViewDidDismiss(notification: NSNotification) {
        let mediaItem = notification.object as? MediaItem
        selectedIndex = SelectedTab.UserProfile.rawValue
        NSNotificationCenter.defaultCenter().postNotificationName(AddContentTabDismissedEvent, object: mediaItem)
    }
}