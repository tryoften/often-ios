//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UICollectionViewController, UserProfileHeaderDelegate, UserProfileViewModelDelegate {
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    
    var setServicesRevealView: UIView
    var settingsRevealView: UIView
    var setServiceViewWidthConstraint: NSLayoutConstraint?
    var settingsViewWidthConstraint: NSLayoutConstraint?
    var contentFilterTabView: UserProfileFilterTabView
    var viewModel: UserProfileViewModel
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

     init(collectionViewLayout: UICollectionViewLayout, viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        contentFilterTabView = UserProfileFilterTabView()
        contentFilterTabView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        setServicesRevealView = UIView()
        setServicesRevealView.setTranslatesAutoresizingMaskIntoConstraints(false)
        setServicesRevealView.backgroundColor = TealColor
        
        settingsRevealView = UIView()
        settingsRevealView.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsRevealView.backgroundColor = TealColor
        
        setServiceViewWidthConstraint = setServicesRevealView.al_width == 0
        settingsViewWidthConstraint = settingsRevealView.al_width == 0
        
        super.init(collectionViewLayout: collectionViewLayout)
        self.viewModel.delegate = self
        
        view.addSubview(setServicesRevealView)
        view.addSubview(settingsRevealView)
        view.addSubview(contentFilterTabView)
        
        setupLayout()
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 360)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        flowLayout.itemSize = CGSizeMake(screenWidth, 300)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = WhiteColor
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(UserScrollTabCollectionViewContainerCell.self, forCellWithReuseIdentifier: "resultCell")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resultCell", forIndexPath: indexPath) as! UserScrollTabCollectionViewContainerCell
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "profile-header", forIndexPath: indexPath) as! UserProfileHeaderView
            
            if headerView == nil {
                headerView = cell
                headerView?.delegate = self
            }
            
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! UserProfileSectionHeaderView
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    func setupLayout() {
        setServiceViewWidthConstraint = setServicesRevealView.al_width == 0
        settingsViewWidthConstraint = settingsRevealView.al_width == 0
        
        view.addConstraints([
            setServicesRevealView.al_left == view.al_left,
            setServicesRevealView.al_bottom == view.al_bottom,
            setServicesRevealView.al_top == view.al_top,
            setServiceViewWidthConstraint!,
            
            settingsRevealView.al_right == view.al_right,
            settingsRevealView.al_top == view.al_top,
            settingsRevealView.al_bottom == view.al_bottom,
            settingsViewWidthConstraint!,
            
            contentFilterTabView.al_bottom == view.al_bottom,
            contentFilterTabView.al_left == view.al_left,
            contentFilterTabView.al_right == view.al_right,
            contentFilterTabView.al_height == 50
        ])
    }

    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User) {
        
    }
    
    func userProfileViewModelDidLoadSocialServiceList(userProfileViewModel: UserProfileViewModel, socialAccountList: [SocialAccount]) {
        
    }
    
    // User profile header delegate
    func revealSetServicesViewDidTap() {
        revealController.showViewController(leftViewController)
    }
    
    func revealSettingsViewDidTap() {
        revealController.showViewController(rightViewController)
    }
    
    func userFavoritesTabSelected() {
        println("Favorites")
    }
    
    func userRecentsTabSelected() {
        println("Recents")
    }
}
