//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//

import UIKit

class UserProfileViewController: MediaItemsViewController, FavoritesAndRecentsTabDelegate {
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: MediaItemsSectionHeaderView?
    
    init(collectionViewLayout: UICollectionViewLayout, viewModel: MediaItemsViewModel) {
        super.init(collectionViewLayout: collectionViewLayout, collectionType: .Favorites, viewModel: viewModel)
        
        viewModel.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUserEmptyStateStatus", name: UIApplicationDidBecomeActiveNotification, object: nil)
        checkUserEmptyStateStatus()
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
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 70.0, right: 10.0)
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: UserProfileHeaderViewReuseIdentifier)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewModel.isDataLoaded {
            PKHUD.sharedHUD.contentView = HUDProgressView()
            PKHUD.sharedHUD.show()
        }
        
        reloadUserData()
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let headerHeight = UserProfileHeaderView.preferredSize.height
        
        var tabBarHeight: CGFloat = 0.0
        if let tabBarController = tabBarController {
            tabBarHeight = CGRectGetHeight(tabBarController.tabBar.frame)
        }
        
        let contentFrame = CGRectMake(0, headerHeight, screenWidth, screenHeight - headerHeight - tabBarHeight)
        
        emptyStateView?.frame = contentFrame
        loaderView.frame = contentFrame
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier, forIndexPath: indexPath) as? UserProfileHeaderView else {
                    return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
                headerView?.tabContainerView.delegate = self
                
                do {
                    try viewModel.fetchCollection(collectionType)
                } catch MediaItemsViewModelError.FetchingCollectionDataFailed {
                    print("Failed to request data")
                } catch let error {
                    print("Failed to request data \(error)")
                }
            }
            
            return headerView!
        }
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: true, indexPath: indexPath)
                    sectionView.rightText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: false, indexPath: indexPath)
                    return sectionView
            }
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaItemCollectionViewCell
        cell = parseMediaItemData(viewModel.mediaItemGroupItemsForIndex(indexPath.section, collectionType: collectionType), indexPath: indexPath, collectionView: collectionView)
        cell.delegate = self
        cell.inMainApp = true
        
        if let result = cell.mediaLink {
            if FavoritesService.defaultInstance.checkFavorite(result) {
                cell.itemFavorited = true
            } else {
                cell.itemFavorited = false
            }
        }
        
        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User) {
        reloadUserData()
    }
    
    override func mediaLinksViewModelDidReceiveMediaItems(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, links: [MediaItem]) {
        reloadData()
    }
    
    override func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError) {
        reloadData()
        PKHUD.sharedHUD.hide(animated: true)
    }
    
    func reloadUserData() {
        if let headerView = headerView, let user = viewModel.currentUser {
            headerView.sharedText = "85 Lyrics Shared"
            headerView.nameLabel.text = user.name
            headerView.collapseNameLabel.text = user.name
            headerView.coverPhotoView.image = UIImage(named: user.backgroundImage)
            if let imageURL = NSURL(string: user.profileImageLarge) {
                headerView.profileImageView.setImageWithAnimation(imageURL)
                
                headerView.collapseProfileImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                    headerView.collapseProfileImageView.image = image
                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
                
                
            }
        }
    }
    
    func userFavoritesTabSelected() {
        collectionType = .Favorites
    }
    
    func userRecentsTabSelected() {
        collectionType = .Recents
    }
    
    //MARK: Check for empty state
    func checkUserEmptyStateStatus() {
        collectionView?.scrollEnabled = false
        isKeyboardEnabled()
        isTwitterEnabled()
        reloadData()
    }
    
    func isKeyboardEnabled() {
        if viewModel.sessionManagerFlags.isKeyboardInstalled {
            updateEmptyStateContent(.NonEmpty)
        } else {
            collectionView?.scrollEnabled = false
            updateEmptyStateContent(.NoKeyboard)
            emptyStateView?.primaryButton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
            emptyStateView?.hidden = false
        }
    }
    
    func isTwitterEnabled() {
        // TODO(kervs): Move this to a view model
        if let user = viewModel.currentUser {
            let twitterCheck = Firebase(url: BaseURL).childByAppendingPath("users/\(user.id)/accounts")
            
            twitterCheck.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                if snapshot.exists() {
                    if let value = snapshot.value as? [String: AnyObject] {
                        if let twitterStuff = value["twitter"] as? [String: AnyObject] {
                            let twitterAccount = SocialAccount()
                            twitterAccount.setValuesForKeysWithDictionary(twitterStuff)
                            
                            if !twitterAccount.activeStatus {
                                self.collectionView?.scrollEnabled = false
                                self.updateEmptyStateContent(.NoTwitter)
                                self.emptyStateView?.hidden = false
                            }
                            
                        }
                        
                    }
                }
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }
    
    // Empty States button actions
    func didTapSettingsButton() {
        var appSettingsString = UIApplicationOpenSettingsURLString
        
        if #available(iOS 9, *) {
            appSettingsString = "prefs:root=General&path=Keyboard/KEYBOARDS"
        }
        
        if let appSettings = NSURL(string: appSettingsString) {
            UIApplication.sharedApplication().openURL(appSettings)
        }
    }
    
    func didTapCancelButton() {
        updateEmptyStateContent(.NonEmpty)
        isKeyboardEnabled()
        reloadData()
    }
    
    func didTapTwitterButton() {
        print("did tap")
    }
    
    override func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        super.mediaLinkCollectionViewCellDidToggleCopyButton(cell, selected: selected)
        
        if selected {
            DropDownErrorMessage().setMessage("Copied link!".uppercaseString,
                subtitle: cell.mainTextLabel.text!, duration: 2.0, errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }
    
}
