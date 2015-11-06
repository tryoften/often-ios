//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let UserProfileHeaderViewReuseIdentifier = "UserProfileHeaderView"

class UserProfileViewController: MediaLinksCollectionBaseViewController,
    UserProfileHeaderDelegate,
    UserProfileViewModelDelegate,
    SlideNavigationControllerDelegate,
    FilterTabDelegate,
    MediaLinkCollectionViewCellDelegate {
    
    var currentCollectionType: UserProfileCollectionType = .Favorites
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    var contentFilterTabView: MediaFilterTabView
    var viewModel: UserProfileViewModel
    var profileDelegate: UserProfileViewControllerDelegate?
    var emptyStateViewLayoutConstraint: NSLayoutConstraint?
    var emptyStateView: EmptySetView
    
    init(collectionViewLayout: UICollectionViewLayout, viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        contentFilterTabView = MediaFilterTabView(filterMap: DefaultFilterMap)
        contentFilterTabView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView = EmptySetView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.hidden = true
    
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.viewModel.delegate = self
        self.contentFilterTabView.delegate = self
        
        emptyStateView.settingbutton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
        emptyStateView.cancelButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        emptyStateView.twitterButton.addTarget(self, action: "didTapTwitterButton", forControlEvents: .TouchUpInside)
        emptyStateView.userInteractionEnabled = true
        
        
        do {
            try viewModel.requestData()
        } catch UserProfileViewModelError.RequestDataFailed {
            print("Failed to request data")
        } catch let error {
            print("Failed to request data \(error)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUserEmptyStateStatus", name: UIApplicationDidBecomeActiveNotification, object: nil)
        checkUserEmptyStateStatus()
        
        view.addSubview(contentFilterTabView)
        view.backgroundColor = VeryLightGray
        view.addSubview(emptyStateView)
        view.layer.masksToBounds = true
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 215)
        flowLayout.parallaxHeaderReferenceSize = UserProfileHeaderView.preferredSize
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 70.0, right: 10.0)

        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: UserProfileHeaderViewReuseIdentifier)
            
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

        switch(currentCollectionType) {
        case .Favorites:
            return viewModel.filteredUserFavorites.count
        case .Recents:
            return viewModel.filteredUserRecents.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaLinkCollectionViewCell
        
        switch(currentCollectionType) {
        case .Favorites:
            cell = parseMediaLinkData(viewModel.filteredUserFavorites, indexPath: indexPath, collectionView: collectionView)
        case .Recents:
            cell = parseMediaLinkData(viewModel.filteredUserRecents, indexPath: indexPath, collectionView: collectionView)
        }
        
         cell.delegate = self
        
        if let result = cell.mediaLink {
            if  viewModel.checkFavorite(result) {
                cell.itemFavorited = true
            } else {
                cell.itemFavorited = false
            }
        }
        
        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:UserProfileHeaderViewReuseIdentifier, forIndexPath: indexPath) as! UserProfileHeaderView
            if let user = viewModel.currentUser {
                cell.descriptionText = user.userDescription
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
            contentFilterTabView.al_height == 50,
            
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_top == view.al_top + UserProfileHeaderView.preferredSize.height,
            emptyStateView.al_bottom == view.al_bottom,
        ])
    }

    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel) {
        collectionView?.reloadData()
        
    }
    
    func userProfileViewModelDidReceiveFavorites(userProfileViewModel: UserProfileViewModel, favorites: [UserFavoriteLink]) {
        reloadCollectionView()
    }
    
    func userProfileViewModelDidReceiveRecents(userProfileViewModel: UserProfileViewModel, recents: [UserRecentLink]) {
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        collectionView?.reloadSections(NSIndexSet(index: 0))
        hasLinks()
        PKHUD.sharedHUD.hide(animated: true) 
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return true
    }
    
    // MARK: UserProfileHeaderDelegate
    func revealSetServicesViewDidTap() {
        SlideNavigationController.sharedInstance().openMenu(MenuLeft, withCompletion: nil)
    }
    
    func revealSettingsViewDidTap() {
        SlideNavigationController.sharedInstance().openMenu(MenuRight, withCompletion: nil)
    }
    
    func userFavoritesTabSelected() {
        currentCollectionType = .Favorites
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        hasLinks()
    }
    
    func userRecentsTabSelected() {
        currentCollectionType = .Recents
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        hasLinks()
    }
    
    //Mark: Check for empty state
    
    func checkUserEmptyStateStatus() {
        collectionView?.scrollEnabled = false
        isKeyboardEnabled()
        isTwitterEnabled()
        hasLinks()
    }
    
    func hasLinks() {
        collectionView?.scrollEnabled = false
        
        if !((emptyStateView.userState == .NoTwitter) || (emptyStateView.userState == .NoKeyboard)) {
            switch (currentCollectionType) {
            case .Favorites:
                if (viewModel.userFavorites.count == 0) {
                    emptyStateView.updateEmptyStateContent(.NoFavorites)
                    emptyStateView.hidden = false
                } else {
                    emptyStateView.hidden = true
                    collectionView?.scrollEnabled = true
                }
                
                break
            case .Recents:
                
                if (viewModel.userRecents.count == 0) {
                    emptyStateView.updateEmptyStateContent(.NoRecents)
                    emptyStateView.hidden = false
                } else {
                    emptyStateView.hidden = true
                    collectionView?.scrollEnabled = true
                }
                
                break
            }
        }
    }
    
    func isKeyboardEnabled() {
        if let keyboards = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()["AppleKeyboards"] as? [String] {
            if !keyboards.contains("com.tryoften.often.Keyboard") {
                collectionView?.scrollEnabled = false
                emptyStateView.updateEmptyStateContent(.NoKeyboard)
                emptyStateView.hidden = false
            } else {
                emptyStateView.updateEmptyStateContent(.NonEmpty)
            }
        }
        
    }
    
    func isTwitterEnabled() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        
        if let user = viewModel.currentUser {
            let twitterCheck = viewModel.baseRef.childByAppendingPath("users/\(user.id)/accounts")
            
            twitterCheck.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                PKHUD.sharedHUD.hide(animated: true)
                if snapshot.exists() {
                    if let value = snapshot.value as? [String: AnyObject] {
                        if let twitterStuff = value["twitter"] as? [String: AnyObject] {
                            let twitterAccount = SocialAccount()
                            twitterAccount.setValuesForKeysWithDictionary(twitterStuff)
                            
                            if !twitterAccount.activeStatus {
                                self.collectionView?.scrollEnabled = false
                                self.emptyStateView.updateEmptyStateContent(.NoTwitter)
                                self.emptyStateView.hidden = false
                            }
                            
                        }
                        
                    }
                }
            })
            
        }
        
        }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaLinkCollectionViewCell,
            let cells = collectionView.visibleCells() as? [MediaLinkCollectionViewCell],
            let result = cell.mediaLink else {
                return
        }
        
    
        for cell in cells {
            cell.overlayVisible = false
            cell.layer.shouldRasterize = false
        }
        
        if  viewModel.checkFavorite(result) {
            cell.itemFavorited = true
        } else {
            cell.itemFavorited = false
        }
        
        cell.overlayVisible = true
    }

    

    // Empty States button actions
    func didTapSettingsButton() {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(appSettings)
        }
        
    }
    
    func didTapCancelButton() {
        emptyStateView.updateEmptyStateContent(.NonEmpty)
        isKeyboardEnabled()
        hasLinks()
    }
    
    func didTapTwitterButton() {
        revealSetServicesViewDidTap()
        
    }
    
    func filterDidChange(filters: [MediaType]) {
        viewModel.filters = filters
    }
    
    // MediaLinkCollectionViewCellDelegate
    func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        viewModel.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }
    
    func mediaLinkCollectionViewCellDidToggleCancelButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        cell.overlayVisible = false
    }
    
    func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        UIPasteboard.generalPasteboard().string = result.getInsertableText()
        
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

