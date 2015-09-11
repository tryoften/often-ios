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
        flowLayout.sectionInset = UIEdgeInsetsMake(25.0, 5.0, 5.0, 5.0)
        flowLayout.itemSize = CGSizeMake(screenWidth - 20, 118)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "resultCell")
        }
//        var emailDic = ["email":"kervins@tryoften.com",
//            "username":"often",
//            "password":"kervs123",
//            "name":"often name"]
//        viewModel.sessionManager.signupUser(.Email, data: emailDic) { err in
//            if err == nil {
//                println("made a email")
//            }
//        }
        
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
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resultCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
        
        cell.sourceLogoView.image = UIImage(named: "complex")
        cell.headerLabel.text = "@ComplexMag"
        cell.mainTextLabel.text = "In the heat of the battle, @Drake dropped some new flames in his new track, Charged Up, via..."
        cell.leftSupplementLabel.text = "3.1K Retweets"
        cell.centerSupplementLabel.text = "4.5K Favorites"
        cell.rightSupplementLabel.text = "July 25, 2015"
        cell.rightCornerImageView.image = UIImage(named: "twitter")
        cell.contentImage = UIImage(named: "ovosound")
        
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0 as CGFloat
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
