//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UICollectionViewController,
UserProfileHeaderDelegate,
UserProfileViewModelDelegate,
UserScrollTabCellDelegate {
    
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    
    var contentFilterTabView: UserProfileFilterTabView
    var viewModel: UserProfileViewModel
    var profileDelegate: UserProfileViewControllerDelegate?
    var headerDelegate: UserScrollHeaderDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

     init(collectionViewLayout: UICollectionViewLayout, viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        contentFilterTabView = UserProfileFilterTabView()
        contentFilterTabView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(collectionViewLayout: collectionViewLayout)
        self.viewModel.delegate = self
        
        view.addSubview(contentFilterTabView)
        
        setupLayout()
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 215)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 360)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        flowLayout.itemSize = CGSizeMake(screenWidth, 7*118)
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
        
        profileDelegate = cell
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "profile-header", forIndexPath: indexPath) as! UserProfileHeaderView
            if let user = viewModel.currentUser {
                cell.descriptionLabel.text = user.userDescription
                cell.nameLabel.text = user.name
                if !user.profileImageLarge.isEmpty {
                    cell.profileImageView.setImageWithURL(NSURL(string: user.profileImageLarge)!)
                }
                
            }
    
    
            if headerView == nil {
                headerView = cell
                headerView?.delegate = self
                headerDelegate = headerView
            }
            
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! UserProfileSectionHeaderView
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    func setupLayout() {
        view.addConstraints([
            contentFilterTabView.al_bottom == view.al_bottom,
            contentFilterTabView.al_left == view.al_left,
            contentFilterTabView.al_right == view.al_right,
            contentFilterTabView.al_height == 50
        ])
    }

    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User) {
        collectionView?.reloadData()
        
    }
    
    // User profile header delegate
    func revealSetServicesViewDidTap() {
        revealController.showViewController(leftViewController)
    }
    
    func revealSettingsViewDidTap() {
        revealController.showViewController(rightViewController)
    }
    
    func userFavoritesTabSelected() {
        if let delegate = profileDelegate {
            delegate.favoritesTabSelected()
        }
    }
    
    func userRecentsTabSelected() {
        if let delegate = profileDelegate {
            delegate.recentsTabSelected()
        }
    }
    
    // UserScrollTabCellDelegate
    func userScrollViewDidScroll(offsetX: CGFloat) {
        headerDelegate?.userScrollViewDidScroll(offsetX)
    }
}

protocol UserProfileViewControllerDelegate {
    func favoritesTabSelected()
    func recentsTabSelected()
}

protocol UserScrollHeaderDelegate  {
    func userScrollViewDidScroll(offsetX: CGFloat)
}
