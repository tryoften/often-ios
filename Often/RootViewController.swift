//
//  RootViewController.swift
//  Often
//
//  Created by Luc Succes on 10/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class RootViewController: SlideNavigationController {
    let sessionManager = SessionManager.defaultManager
    
    init() {
         
        super.init(rootViewController: UserProfileViewController(collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(), viewModel: UserProfileViewModel()))
        
        let animator = SlideNavigationContorllerAnimatorScaleAndFade(maximumFadeAlpha: 0.8, fadeColor: VeryLightGray, andMinimumScale: 0.8)
        
        navigationBar.hidden = true
        menuRevealAnimator = animator
        enableShadow = false
        panGestureSideOffset = CGFloat(100)
        
        let socialAccountViewModel = SocialAccountSettingsViewModel(sessionManager: sessionManager)
        let leftViewController = SocialAccountSettingsCollectionViewController(collectionViewLayout: SocialAccountSettingsCollectionViewController.provideCollectionViewLayout(), viewModel: socialAccountViewModel)
        
        let settingsViewModel = SettingsViewModel(sessionManager: sessionManager)
        let rightViewController = AppSettingsViewController(viewModel: settingsViewModel)
        
        leftMenu = leftViewController
        rightMenu = rightViewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layer.shadowOffset = CGSizeMake(0, 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowColor = DarkGrey.CGColor
        view.layer.shadowRadius = 4
    }

}
