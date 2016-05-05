//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//

import UIKit

class UserProfileViewController: MediaItemsCollectionBaseViewController, MediaItemGroupViewModelDelegate,
    UICollectionViewDelegateFlowLayout {
    var viewModel: PacksService
    var headerView: UserProfileHeaderView?
    private var packServiceListener: Listener?

    
    init(viewModel: PacksService) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: self.dynamicType.provideCollectionViewLayout())

        viewModel.delegate = self

        viewModel.fetchCollection()

        packServiceListener = PacksService.defaultInstance.didUpdatePacks.on { items in
            self.collectionView?.reloadData()
        }
        
        collectionView?.backgroundColor = WhiteColor
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
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 64)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 270)
        flowLayout.itemSize = CGSizeMake(screenWidth / 2 - 16.5, 225) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 6.0
        flowLayout.sectionInset = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        return flowLayout
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
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaItems.count
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier, forIndexPath: indexPath) as? UserProfileHeaderView else {
                    return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
                viewModel.fetchCollection()
            }
            
            return headerView!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell =  parsePackItemData(viewModel.mediaItems, indexPath: indexPath, collectionView: collectionView) as? PackProfileCollectionViewCell else {
             return PackProfileCollectionViewCell()
        }
        
        cell.addedBadgeView.hidden = true
        cell.primaryButton.tag = indexPath.row
        
        if viewModel.mediaItems.count == 1 {
            cell.primaryButton.hidden = true
        }
        
        cell.primaryButton.addTarget(self, action: #selector(UserProfileViewController.didTapRemovePackButton(_:)), forControlEvents: .TouchUpInside)


        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let pack = viewModel.mediaItems[indexPath.row] as? PackMediaItem , let id = pack.pack_id else {
            return
        }

        let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
        navigationController?.navigationBar.hidden = false
        navigationController?.pushViewController(packVC, animated: true)
    }

    func reloadUserData() {
        if let headerView = headerView, let user = SessionManager.defaultManager.currentUser {
            headerView.sharedText = "\(user.shareCount) snippets shared"
            headerView.nameLabel.text = user.name
            headerView.collapseNameLabel.text = user.name
            headerView.coverPhotoView.image = UIImage(named: user.backgroundImage)
            if let imageURL = NSURL(string: user.profileImageLarge) {
                headerView.profileImageView.nk_setImageWith(imageURL)
            }
        }
    }

    func didTapRemovePackButton(button: UIButton?) {
        guard let button = button else {
            return
        }

        if let pack = viewModel.mediaItems[button.tag] as? PackMediaItem where button.tag < viewModel.mediaItems.count {
            PacksService.defaultInstance.removePack(pack)
        }
    }

    func promptUserToRegisterPushNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings( UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: []))
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }

    // Empty States button actions
    func didTapSettingsButton() {
        if let appSettings = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.sharedApplication().openURL(appSettings)
        }
    }


    override func showEmptyStateViewForState(state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
        super.showEmptyStateViewForState(state, animated: animated, completion: completion)
        viewDidLayoutSubviews()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 9.0 as CGFloat
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
        reloadUserData()
    }
}
