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
        
        collectionView?.backgroundColor = VeryLightGray
        collectionView?.register(PackProfileCollectionViewCell.self, forCellWithReuseIdentifier: BrowseMediaItemCollectionViewCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.main().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSize(width: screenWidth, height: 64)
        flowLayout.parallaxHeaderReferenceSize = CGSize(width: screenWidth, height: 270)
        flowLayout.itemSize = CGSize(width: screenWidth / 2 - 16.5, height: 225) /// height of the cell
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
            collectionView.register(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        promptUserToRegisterPushNotifications()
        reloadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared().setStatusBarHidden(true, with: .none)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                withReuseIdentifier: UserProfileHeaderViewReuseIdentifier, for: indexPath) as? UserProfileHeaderView else {
                    return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
                viewModel.fetchCollection()
            }
            
            return headerView!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  parsePackItemData(viewModel.mediaItems, indexPath: indexPath, collectionView: collectionView) as? PackProfileCollectionViewCell else {
             return PackProfileCollectionViewCell()
        }
        
        cell.addedBadgeView.isHidden = true
        cell.primaryButton.tag = (indexPath as NSIndexPath).row
        cell.primaryButton.isHidden = false
        
        if viewModel.mediaItems.count == 1 {
            cell.primaryButton.isHidden = true
        }
        
        cell.primaryButton.addTarget(self, action: #selector(UserProfileViewController.didTapRemovePackButton(_:)), for: .touchUpInside)


        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pack = viewModel.mediaItems[(indexPath as NSIndexPath).row] as? PackMediaItem , let id = pack.pack_id else {
            return
        }

        let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(packVC, animated: true)
    }

    func reloadUserData() {
        if let headerView = headerView, let user = SessionManager.defaultManager.currentUser {
            headerView.sharedText = "\(user.shareCount) Quotes & Gifs shared"
            headerView.nameLabel.text = user.name
            headerView.collapseNameLabel.text = user.name
            headerView.coverPhotoView.image = UIImage(named: user.backgroundImage)
            if let imageURL = URL(string: user.profileImageLarge) {
                headerView.profileImageView.nk_setImageWith(imageURL)
            }
        }
    }

    func didTapRemovePackButton(_ button: UIButton?) {
        guard let button = button else {
            return
        }

        if let pack = viewModel.mediaItems[button.tag] as? PackMediaItem where button.tag < viewModel.mediaItems.count {
            PacksService.defaultInstance.removePack(pack)
        }
    }

    func promptUserToRegisterPushNotifications() {
        if let user = SessionManager.defaultManager.currentUser {
            if !user.pushNotificationStatus && !SessionManagerFlags.defaultManagerFlags.userHasSeenPushNotificationView {
                let AlertVC = PushNotificationAlertViewController()
                AlertVC.transitioningDelegate = self
                AlertVC.modalPresentationStyle = .custom
                present(AlertVC, animated: true, completion: nil)

            }
        }
    }

    // Empty States button actions
    func didTapSettingsButton() {
        if let appSettings = URL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.shared().openURL(appSettings)
        }
    }


    override func showEmptyStateViewForState(_ state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
        super.showEmptyStateViewForState(state, animated: animated, completion: completion)
        viewDidLayoutSubviews()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9.0 as CGFloat
    }

    func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
        reloadUserData()
    }
}
