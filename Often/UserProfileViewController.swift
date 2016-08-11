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
    
    var presentFavorites: Bool = false {
        didSet {
            if viewModel.mediaItems.count > 0 {
                guard let pack = viewModel.favoritesPack, let id = pack.pack_id else {
                    return
                }
                
                let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
                navigationController?.navigationBar.hidden = false
                navigationController?.pushViewController(packVC, animated: true)
            }
        }
    }

    init(viewModel: PacksService) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: self.dynamicType.provideCollectionViewLayout())
        
        viewModel.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserProfileViewController.promptUserToChooseUsername), name: "DismissPushNotificationAlertView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserProfileViewController.presentFavoritesPack), name: AddContentTabDismissedEvent, object: nil)
        
        packServiceListener = viewModel.didUpdatePacks.on { items in
            self.collectionView?.reloadData()
            self.reloadUserData()
        }

        collectionView?.contentInset = UIEdgeInsetsZero
        collectionView?.backgroundColor = VeryLightGray
        collectionView?.registerClass(PackProfileCollectionViewCell.self, forCellWithReuseIdentifier: BrowseMediaItemCollectionViewCellReuseIdentifier)
        collectionView?.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "userProfileSectionHeader")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
                                     withReuseIdentifier: UserProfileHeaderViewReuseIdentifier)

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
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, screenHeight * 0.50)
        flowLayout.itemSize = CGSizeMake(screenWidth - 24, 74)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 6.0
        flowLayout.sectionInset = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let user = SessionManager.defaultManager.currentUser {
            if !user.pushNotificationStatus && !SessionManagerFlags.defaultManagerFlags.userHasSeenPushNotificationView {
                promptUserToRegisterPushNotifications()
            } else {
                promptUserToChooseUsername()
            }
        }
        reloadUserData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
                headerView?.backButton.addTarget(self, action:
                    #selector(UserProfileViewController.didTapBackButton), forControlEvents: .TouchUpInside)
                viewModel.fetchData()
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
        if let headerView = headerView, let user = viewModel.currentUser {
            headerView.isCurrentUser = viewModel.isCurrentUser
            headerView.nameLabel.text = user.name
            headerView.collapseNameLabel.text = "@\(user.username)"
            headerView.leftHeaderLabel.text = user.name
            if let imageURL = NSURL(string: user.profileImageLarge) {
                headerView.profileImageView.nk_setImageWith(imageURL)
            }
        }
    }

    func didTapBackButton(button: UIButton?) {
        navigationController?.popViewControllerAnimated(true)
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
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("hideHud"), userInfo: nil, repeats: false)
    }
    
    func promptUserToRegisterPushNotifications() {
        let AlertVC = PushNotificationAlertViewController()
        AlertVC.transitioningDelegate = self
        AlertVC.modalPresentationStyle = .Custom
        presentViewController(AlertVC, animated: true, completion: nil)
    }
    
    func promptUserToChooseUsername() {
        guard let _ = SessionManager.defaultManager.currentUser else {
            return
        }

        if !SessionManagerFlags.defaultManagerFlags.userHasUsername {
            let alertVC = UsernameAlertViewController(viewModel: UsernameViewModel())
            alertVC.transitioningDelegate = self
            alertVC.modalPresentationStyle = .Custom
            presentViewController(alertVC, animated: true, completion: nil)
        }

    }
    
    func presentFavoritesPack() {
        guard let pack = viewModel.favoritesPack, let id = pack.pack_id else {
            return
        }
        
        let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
        navigationController?.navigationBar.hidden = false
        navigationController?.pushViewController(packVC, animated: true)
    }
    
    override func requestForIndexPaths(indexPaths: [NSIndexPath]) -> [ImageRequest]? {
        var imageRequest: [ImageRequest] = []
        
        for index in indexPaths {
            if index.row < viewModel.mediaItems.count {
                if let url = viewModel.mediaItems[index.row].smallImageURL {
                    imageRequest.append (ImageRequest(URL: url))
                }
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
        if viewModel.isCurrentUser {
            let vc = ContainerNavigationController(rootViewController: AppSettingsViewController(viewModel: SettingsViewModel(sessionManager: SessionManager.defaultManager)))
            presentViewController(vc, animated: true, completion: nil)
        }
    }
}
