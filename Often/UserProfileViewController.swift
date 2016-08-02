//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//

import UIKit
import Preheat
import Nuke

class UserProfileViewController: MediaItemsCollectionBaseViewController, MediaItemGroupViewModelDelegate,
    UICollectionViewDelegateFlowLayout {
    var viewModel: PacksService
    var headerView: UserProfileHeaderView?
    private var packServiceListener: Listener?
    var editingActive: Bool = false {
        didSet {
            collectionView?.reloadData()
        }
    }

    init(viewModel: PacksService) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: self.dynamicType.provideCollectionViewLayout())

        viewModel.delegate = self
        viewModel.fetchCollection()

        packServiceListener = PacksService.defaultInstance.didUpdatePacks.on { items in
            self.collectionView?.reloadData()
        }

        collectionView?.contentInset = UIEdgeInsetsZero
        collectionView?.backgroundColor = VeryLightGray
        collectionView?.registerClass(PackProfileCollectionViewCell.self, forCellWithReuseIdentifier: BrowseMediaItemCollectionViewCellReuseIdentifier)
        collectionView?.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "userProfileSectionHeader")

        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 64)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, screenHeight * 0.40)
        flowLayout.itemSize = CGSizeMake(screenWidth, 74)
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

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .Default
            navigationBar.translucent = false
            navigationBar.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
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
                headerView?.rightHeaderButton.addTarget(self, action: #selector(UserProfileViewController.presentSettingsViewController), forControlEvents: .TouchUpInside)
                viewModel.fetchCollection()
            }
            
            return headerView!
        }
        
        if kind == UICollectionElementKindSectionHeader {
            if let sectionHeader: UserProfileSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "userProfileSectionHeader", forIndexPath: indexPath) as? UserProfileSectionHeaderView {
                sectionHeader.titleLabel.text = "\(viewModel.mediaItems.count) PACKS"
                sectionHeader.editButton.addTarget(self, action: #selector(UserProfileViewController.didSelectEditButton(_:)), forControlEvents: .TouchUpInside)
                return sectionHeader
            }
        }
        
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell =  parsePackItemData(viewModel.mediaItems, indexPath: indexPath, collectionView: collectionView) as? PackProfileCollectionViewCell else {
             return PackProfileCollectionViewCell()
        }
        
        cell.addedBadgeView.hidden = true
        cell.primaryButton.tag = indexPath.row
        cell.primaryButton.hidden = true
        
        if viewModel.mediaItems.count == 1 {
            cell.primaryButton.hidden = true
        }
        
        let result = viewModel.mediaItems[indexPath.row], pack = result as? PackMediaItem
        
        if editingActive == true && pack?.isFavorites == false {
            cell.disclosureIndicator.hidden = true
            cell.primaryButton.hidden = false
        } else {
            cell.disclosureIndicator.hidden = false
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
            headerView.nameLabel.text = user.name
            headerView.collapseNameLabel.text = user.name
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
            showHud()
            PacksService.defaultInstance.removePack(pack)
        }
    }

    override func showHud() {
        super.showHud()
        
        hudTimer?.invalidate()
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideHud", userInfo: nil, repeats: false)
    }

    func promptUserToRegisterPushNotifications() {
        if let user = SessionManager.defaultManager.currentUser {
            if !user.pushNotificationStatus && !SessionManagerFlags.defaultManagerFlags.userHasSeenPushNotificationView {
                let AlertVC = PushNotificationAlertViewController()
                AlertVC.transitioningDelegate = self
                AlertVC.modalPresentationStyle = .Custom
                presentViewController(AlertVC, animated: true, completion: nil)

            }
        }
    }

    override func requestForIndexPaths(indexPaths: [NSIndexPath]) -> [ImageRequest]? {
        var imageRequest: [ImageRequest] = []

        for index in indexPaths {
            if let url = viewModel.mediaItems[index.row].smallImageURL {
                imageRequest.append (ImageRequest(URL: url))
            }
        }

        return imageRequest
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

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
        reloadUserData()
    }
    
    func didSelectEditButton(button: UserProfileSettingsBarButton) {
        if editingActive == false {
            editingActive = true
            button.selected = true
        } else {
            editingActive = false
            button.selected = false
        }
    }
    
    func presentSettingsViewController() {
        let vc = ContainerNavigationController(rootViewController: AppSettingsViewController(viewModel: SettingsViewModel(sessionManager: SessionManager.defaultManager)))
        presentViewController(vc, animated: true, completion: nil)
    }
}
