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
    SlideNavigationControllerDelegate {
    
    enum UserProfileCollectionType {
        case Favorites
        case Recents
    }
    
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
        
        view.addSubview(contentFilterTabView)
        view.layer.masksToBounds = true
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 215)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 360)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        flowLayout.itemSize = CGSizeMake(screenWidth, 118)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = WhiteColor
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "resultCell")
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
        if collectionType == .Favorites {
            return 7 // return the number of favorites for the current user
        } else if collectionType == .Recents {
            return 7 // return the number of recents for the current user
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // same cell for both right now
        if collectionType == .Favorites {
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
        } else {
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
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "profile-header", forIndexPath: indexPath) as! UserProfileHeaderView
            if let user = viewModel.currentUser {
                let subtitle = NSMutableAttributedString(string: user.userDescription)
                let subtitleRange = NSMakeRange(0, user.userDescription.characters.count)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
                subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
                cell.descriptionLabel.attributedText = subtitle
                cell.descriptionLabel.textAlignment = .Center
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
        
        headerDelegate?.userDidSelectTab("favorites")
    }
    
    func userRecentsTabSelected() {
        collectionType = .Recents
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        
        headerDelegate?.userDidSelectTab("recents")
    }
}

protocol UserProfileViewControllerDelegate {
    func favoritesTabSelected()
    func recentsTabSelected()
}

protocol UserScrollHeaderDelegate  {
    func userDidSelectTab(type: String)
}
