//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//

import UIKit

class UserProfileViewController: MediaItemsViewController, FavoritesAndRecentsTabDelegate,
    UICollectionViewDelegateFlowLayout {
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: MediaItemsSectionHeaderView?
    var viewModels: [MediaItemsCollectionType: MediaItemsViewModel]
    
    init(recentsViewModel: RecentsViewModel,
         favoritesViewModel: FavoritesService,
         packsViewModel: PacksService) {
        
        viewModels = [.Favorites: favoritesViewModel, .Recents: recentsViewModel, .Packs: packsViewModel]
        
        super.init(collectionViewLayout: self.dynamicType.provideCollectionViewLayout(), collectionType: .Packs, viewModel: packsViewModel)

        viewModel = viewModels[collectionType]!
        viewModel.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserProfileViewController.checkUserEmptyStateStatus), name: UIApplicationDidBecomeActiveNotification, object: nil)
        collectionView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 70.0, right: 0.0)
    
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "RecentlyUsedCellIdentifier")
        collectionView?.registerClass(PackProfileCollectionViewCell.self, forCellWithReuseIdentifier: BrowseMediaItemCollectionViewCellReuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let layout = CSStickyHeaderFlowLayout()
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 110)
        layout.parallaxHeaderReferenceSize = UserProfileHeaderView.preferredSize
        layout.parallaxHeaderAlwaysOnTop = true
        layout.disableStickyHeaders = false
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 95)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        promptUserToRegisterPushNotifications()
        reloadUserData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        checkUserEmptyStateStatus()
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height

        var headerHeight = UserProfileHeaderView.preferredSize.height
        if let headerViewFrame = headerView?.frame {
            headerHeight = CGRectGetHeight(headerViewFrame)
        }
        
        var tabBarHeight: CGFloat = 0.0
        if let tabBarController = tabBarController {
            tabBarHeight = CGRectGetHeight(tabBarController.tabBar.frame)
        }
        
        let contentFrame = CGRectMake(0, headerHeight, screenWidth, screenHeight - headerHeight - tabBarHeight)
        
        emptyStateView?.frame = contentFrame
        loaderView?.frame = contentFrame
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let profileViewHeight = headerView?.frame.height, profileViewCenter = headerView?.frame.midX, cells = collectionView?.visibleCells()
            where collectionType == .Favorites else {
                return
        }
        
        let point = CGPointMake(profileViewCenter, profileViewHeight + scrollView.contentOffset.y + 37)
        for cell in cells {
            if cell.frame.contains(point) {
                if let indexPath = collectionView?.indexPathForCell(cell) {
                    if let sectionView = sectionHeaders[indexPath.section] {
                        sectionView.rightText = viewModel.rightSectionHeaderTitle(indexPath)
                    }
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 && collectionType == .Recents {
            return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 120)
        }
        switch collectionType {
        case .Recents:  return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        case .Packs:    return CGSizeMake(171, 237)
        default:        return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 95)
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier, forIndexPath: indexPath) as? UserProfileHeaderView else {
                    return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
                headerView?.tabContainerView.delegate = self
                viewModel.fetchCollection()

            }
            
            return headerView!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell
        
        if indexPath.section == 0 && collectionType == .Recents {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecentlyUsedCellIdentifier", forIndexPath: indexPath)
            let lyricsHorizontalVC = provideRecentlyAddedLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC.group = viewModel.generateMediaItemGroups()[indexPath.section]
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            lyricsHorizontalVC.view.frame = cell.bounds
        } else {
            cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
        
        if let cell = cell as? MediaItemCollectionViewCell {
            cell.delegate = self
            cell.type = collectionType == .Recents ? .Metadata : .NoMetadata
            cell.inMainApp = true
            
            if let result = cell.mediaLink {
                cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(result)
            }
            
            cell.favoriteRibbon.hidden = collectionType == .Recents ? !cell.itemFavorited : true
        }

        return cell
    }
    
    override func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User) {
        reloadUserData()
    }
    
    override func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError) {
        reloadData()
    }
    
    func reloadUserData() {
        if let headerView = headerView, let user = viewModel.currentUser {
            headerView.sharedText = "\(SessionManagerFlags.defaultManagerFlags.userMessageCount) Lyrics Shared"
            headerView.nameLabel.text = user.name
            headerView.collapseNameLabel.text = user.name
            headerView.coverPhotoView.image = UIImage(named: user.backgroundImage)
            if let imageURL = NSURL(string: user.profileImageLarge) {
                headerView.profileImageView.setImageWithAnimation(imageURL, placeholderImage: UIImage(named: "userprofileplaceholder"))
                headerView.collapseProfileImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                    headerView.collapseProfileImageView.image = image
                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
                
                
            }
        }
    }
    
    func userPacksTabSelected() {
        viewModel = viewModels[.Packs]!
        collectionType = .Packs
    }
    
    func userFavoritesTabSelected() {
        viewModel = viewModels[.Favorites]!
        collectionType = .Favorites
    }
    
    func userRecentsTabSelected() {
        viewModel = viewModels[.Recents]!
        collectionType = .Recents
    }

    //MARK: Check for empty state
    func checkUserEmptyStateStatus() {
        collectionView?.scrollEnabled = false
        isKeyboardEnabled()
    }
    
    func isKeyboardEnabled() {
        if viewModel.sessionManagerFlags.isKeyboardInstalled {
            hideEmptyStateView()
            collectionView?.scrollEnabled = true
        } else {
            viewModel.userState = .NoKeyboard
            collectionView?.scrollEnabled = false
            showEmptyStateViewForState(.NoKeyboard)
            emptyStateView?.primaryButton.addTarget(self, action: #selector(UserProfileViewController.didTapSettingsButton), forControlEvents: .TouchUpInside)
        }
    }
       
    func promptUserToRegisterPushNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings( UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: []))
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionType == .Packs {
            return CGSizeZero
        }
        return CGSizeMake(UIScreen.mainScreen().bounds.width, MediaItemsSectionHeaderHeight)
    }
    
    // Empty States button actions
    func didTapSettingsButton() {
        if let appSettings = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.sharedApplication().openURL(appSettings)
        }
    }
    
    func didTapCancelButton() {
        hideEmptyStateView()
        isKeyboardEnabled()
        reloadData()
    }

    override func showEmptyStateViewForState(state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
        super.showEmptyStateViewForState(state, animated: animated, completion: completion)
        viewDidLayoutSubviews()
    }

}
