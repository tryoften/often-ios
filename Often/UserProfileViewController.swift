//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let UserProfileHeaderViewReuseIdentifier = "UserProfileHeaderView"


class UserProfileViewController: FavoritesAndRecentsBaseViewController {
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
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 175)
        layout.parallaxHeaderReferenceSize = UserProfileHeaderView.preferredSize
        layout.parallaxHeaderAlwaysOnTop = true
        layout.disableStickyHeaders = false
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 70.0, right: 10.0)

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
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileSectionViewReuseIdentifier)
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
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier, forIndexPath: indexPath) as? UserProfileHeaderView else {
                return UICollectionReusableView()
            }

            if headerView == nil {
                headerView = cell
                headerView?.tabContainerView.delegate = self

                do {
                    try viewModel.requestData()
                } catch UserProfileViewModelError.RequestDataFailed {
                    print("Failed to request data")
                } catch let error {
                    print("Failed to request data \(error)")
                }
            }

            return headerView!
        }
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView : UserProfileSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: UserProfileSectionViewReuseIdentifier, forIndexPath: indexPath) as? UserProfileSectionHeaderView {
                sectionView.trendingLabel.attributedText = sectionHeaderTitle()
                sectionView.layer.shadowOffset = CGSizeMake(0, 0)
                sectionView.layer.shadowOpacity = 0.9
                sectionView.layer.shadowColor = DarkGrey.CGColor
                sectionView.layer.shadowRadius = 1


                return sectionView
            }
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

    //MARK: Check for empty state
    func checkUserEmptyStateStatus() {
        collectionView?.scrollEnabled = false
        isKeyboardEnabled()
        isTwitterEnabled()
        hasLinks()
    }
    
    func isKeyboardEnabled() {
        if viewModel.sessionManagerFlags.isKeyboardInstalled {
            emptyStateView.updateEmptyStateContent(.NonEmpty)
        } else {
            collectionView?.scrollEnabled = false
            emptyStateView.updateEmptyStateContent(.NoKeyboard)
            emptyStateView.hidden = false
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }

    override func userProfileViewModelDidLoginUser(userProfileViewModel: MediaLinksViewModel) {
        if  let headerView = headerView {
            if let user = viewModel.currentUser {
                headerView.descriptionText = user.userDescription
                headerView.nameLabel.text = user.name
                if let imageURL = NSURL(string: user.profileImageLarge) {
                    headerView.profileImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                        headerView.profileImageView.image = image
                        }, failure: { (req, res, error) in
                            print("Failed to load image: \(imageURL)")
                    })
                }
            }

        }
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
        emptyStateView.updateEmptyStateContent(.NonEmpty)
        isKeyboardEnabled()
        hasLinks()
    }
    
    func didTapTwitterButton() {
        print("did tap")
        
    }
    
    override func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        super.mediaLinkCollectionViewCellDidToggleCopyButton(cell, selected: selected)
        
        if selected {
            DropDownErrorMessage().setMessage("Copied link!".uppercaseString,
                subtitle: cell.mainTextLabel.text!, duration: 2.0, errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }
  
}
