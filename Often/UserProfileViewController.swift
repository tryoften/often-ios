//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: SearchResultsCollectionViewControllerBaseClass,
    UserProfileHeaderDelegate,
    UserProfileViewModelDelegate,
    SlideNavigationControllerDelegate,
    FilterTabDelegate {
    
    var collectionType: UserProfileCollectionType = .Favorites
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    var contentFilterTabView: UserProfileFilterTabView
    var viewModel: UserProfileViewModel
    var profileDelegate: UserProfileViewControllerDelegate?
    var headerDelegate: UserScrollHeaderDelegate?
    
    init(collectionViewLayout: UICollectionViewLayout, viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        contentFilterTabView = UserProfileFilterTabView()
        contentFilterTabView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(collectionViewLayout: collectionViewLayout)
        self.viewModel.delegate = self
        self.viewModel.requestData()
        
        contentFilterTabView.delegate = self
        
        view.addSubview(contentFilterTabView)
        view.layer.masksToBounds = true
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 215)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, screenHeight/2)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 40.0, right: 10.0)

        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = WhiteColor
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
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
        if let userFavorites = viewModel.userFavorites, userRecents = viewModel.userRecents {
            switch(collectionType) {
            case .Favorites:
                return userFavorites.count
            case .Recents:
                return userRecents.count
            }
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: SearchResultsCollectionViewCell
        
        switch(collectionType) {
        case .Favorites:
            cell = parseSearchResultsData(viewModel.userFavorites, indexPath: indexPath, collectionView: collectionView)
        case .Recents:
            cell = parseSearchResultsData(viewModel.userRecents, indexPath: indexPath, collectionView: collectionView)
        }
        
        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "profile-header", forIndexPath: indexPath) as! UserProfileHeaderView
            if let user = viewModel.currentUser {
                cell.descriptionLabel.text = user.userDescription
                cell.nameLabel.text = user.name
                if let imageURL = NSURL(string: user.profileImageLarge) {
                    cell.profileImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                        cell.profileImageView.image = image
                        }, failure: { (req, res, error) in
                            print("Failed to load image: \(imageURL)")
                    })
                }
                
            }

            if headerView == nil {
                headerView = cell
                headerView?.delegate = self
                headerDelegate = headerView
            }

            return headerView!
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
    
    func userProfileViewModelDidPullUserFavorites(userProfileViewModel: UserProfileViewModel) {
        collectionView?.reloadData()
        PKHUD.sharedHUD.hide(animated: true)
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return true
    }
    
    // User profile header delegate
    func revealSetServicesViewDidTap() {
        SlideNavigationController.sharedInstance().openMenu(MenuLeft, withCompletion: nil)
    }
    
    func revealSettingsViewDidTap() {
        SlideNavigationController.sharedInstance().openMenu(MenuRight, withCompletion: nil)
    }
    
    func userFavoritesTabSelected() {
        collectionType = .Favorites
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        
        headerDelegate?.userDidSelectTab(.Favorites)
    }
    
    func userRecentsTabSelected() {
        collectionType = .Recents
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        
        headerDelegate?.userDidSelectTab(.Recents)
    }
    
    func currentFilterState(filter: FilterFlag) {
        
    }
}

enum UserProfileCollectionType {
    case Favorites
    case Recents
}

protocol UserProfileViewControllerDelegate {
    func favoritesTabSelected()
    func recentsTabSelected()
}

protocol UserScrollHeaderDelegate  {
    func userDidSelectTab(type: UserProfileCollectionType)
}
