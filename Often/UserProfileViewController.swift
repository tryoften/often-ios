//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let UserProfileHeaderViewReuseIdentifier = "UserProfileHeaderView"

class UserProfileViewController: FavoritesAndRecentsBaseViewController,
    UserProfileHeaderDelegate,
    SlideNavigationControllerDelegate {
    var headerView: UserProfileHeaderView?
    
     override init(collectionViewLayout: UICollectionViewLayout, viewModel: MediaLinksViewModel) {
        super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUserEmptyStateStatus", name: UIApplicationDidBecomeActiveNotification, object: nil)
        checkUserEmptyStateStatus()
        
        view.backgroundColor = VeryLightGray
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
        let layout = CSStickyHeaderFlowLayout()
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 215)
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
                headerView?.tabContainerView.delegate = self
            }
            
            return headerView!
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaLinkCollectionViewCell
        cell = parseMediaLinkData(viewModel.mediaLinks, indexPath: indexPath, collectionView: collectionView)
        cell.delegate = self
        cell.inMainApp = true
        
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
    
    
    override func userProfileViewModelDidReceiveMediaLinks(userProfileViewModel: MediaLinksViewModel, links: [MediaLink]) {
        super.userProfileViewModelDidReceiveMediaLinks(userProfileViewModel, links: links)
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
    
    //MARK: Check for empty state
    func checkUserEmptyStateStatus() {
        collectionView?.scrollEnabled = false
        isKeyboardEnabled()
        isTwitterEnabled()
        hasLinks()
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
    
    override func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        super.mediaLinkCollectionViewCellDidToggleCopyButton(cell, selected: selected)
        
        if selected {
            DropDownErrorMessage().setMessage("Copied link!".uppercaseString, subtitle: cell.mainTextLabel.text!, duration: 2.0, errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }
  
}

