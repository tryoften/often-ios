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
        self.viewModel.requestData()
        
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
        
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        
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
            return viewModel.userFavorites.count // return the number of favorites for the current user
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
            
            
            if indexPath.row >= viewModel.userFavorites.count {
                return cell
            }
            
            guard let result = viewModel.userFavorites[indexPath.row] else {
                return cell
            }
            
            cell.reset()
            
            switch(result.type) {
            case .Article:
                let article = (result as! ArticleSearchResult)
                cell.mainTextLabel.text = article.title
                cell.leftSupplementLabel.text = article.author
                cell.headerLabel.text = article.sourceName
                cell.rightSupplementLabel.text = article.date?.timeAgoSinceNow()
                cell.centerSupplementLabel.text = nil
            case .Track:
                let track = (result as! TrackSearchResult)
                cell.mainTextLabel.text = track.name
                cell.rightSupplementLabel.text = track.formattedCreatedDate
                
                switch(result.source) {
                case .Spotify:
                    cell.headerLabel.text = "Spotify"
                    cell.mainTextLabel.text = "\(track.name)"
                    cell.leftSupplementLabel.text = track.artistName
                    cell.rightSupplementLabel.text = track.albumName
                case .Soundcloud:
                    cell.headerLabel.text = track.artistName
                    cell.leftSupplementLabel.text = track.formattedPlays()
                default:
                    break
                }
            case .Video:
                let video = (result as! VideoSearchResult)
                cell.mainTextLabel.text = video.title
                cell.headerLabel.text = video.owner
                
                if let viewCount = video.viewCount {
                    cell.leftSupplementLabel.text = "\(Double(viewCount).suffixNumber) views"
                }
                
                if let likeCount = video.likeCount {
                    cell.centerSupplementLabel.text = "\(Double(likeCount).suffixNumber) likes"
                }
                
                cell.rightSupplementLabel.text = video.date?.timeAgoSinceNow()
                
            default:
                break
            }
            
            cell.searchResult = result
            cell.overlayVisible = false
            cell.contentImageView.image = nil
            if  let image = result.image,
                let imageURL = NSURL(string: image) {
                    print("Loading image: \(imageURL)")
                    cell.contentImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                        cell.contentImageView.image = image
                        }, failure: { (req, res, error) in
                            print("Failed to load image: \(imageURL)")
                    })
            }
            
            cell.sourceLogoView.image = result.iconImageForSource()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resultCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
            
            
            if indexPath.row >= viewModel.userRecents.count {
                return cell
            }
            
            guard let result = viewModel.userRecents[indexPath.row] else {
                return cell
            }
            
            cell.reset()
            
            switch(result.type) {
            case .Article:
                let article = (result as! ArticleSearchResult)
                cell.mainTextLabel.text = article.title
                cell.leftSupplementLabel.text = article.author
                cell.headerLabel.text = article.sourceName
                cell.rightSupplementLabel.text = article.date?.timeAgoSinceNow()
                cell.centerSupplementLabel.text = nil
            case .Track:
                let track = (result as! TrackSearchResult)
                cell.mainTextLabel.text = track.name
                cell.rightSupplementLabel.text = track.formattedCreatedDate
                
                switch(result.source) {
                case .Spotify:
                    cell.headerLabel.text = "Spotify"
                    cell.mainTextLabel.text = "\(track.name)"
                    cell.leftSupplementLabel.text = track.artistName
                    cell.rightSupplementLabel.text = track.albumName
                case .Soundcloud:
                    cell.headerLabel.text = track.artistName
                    cell.leftSupplementLabel.text = track.formattedPlays()
                default:
                    break
                }
            case .Video:
                let video = (result as! VideoSearchResult)
                cell.mainTextLabel.text = video.title
                cell.headerLabel.text = video.owner
                
                if let viewCount = video.viewCount {
                    cell.leftSupplementLabel.text = "\(Double(viewCount).suffixNumber) views"
                }
                
                if let likeCount = video.likeCount {
                    cell.centerSupplementLabel.text = "\(Double(likeCount).suffixNumber) likes"
                }
                
                cell.rightSupplementLabel.text = video.date?.timeAgoSinceNow()
                
            default:
                break
            }
            
            cell.searchResult = result
            cell.overlayVisible = false
            cell.contentImageView.image = nil
            if  let image = result.image,
                let imageURL = NSURL(string: image) {
                    print("Loading image: \(imageURL)")
                    cell.contentImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                        cell.contentImageView.image = image
                        }, failure: { (req, res, error) in
                            print("Failed to load image: \(imageURL)")
                    })
            }
            
            cell.sourceLogoView.image = result.iconImageForSource()
            
            return cell
        }
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
        PKHUD.sharedHUD.hide(animated: true)
        
    }
    
    func userProfileViewModelDidPullUserFavorites(userProfileViewModel: UserProfileViewModel) {
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
