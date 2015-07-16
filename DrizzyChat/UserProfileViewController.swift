//
//  UserProfileViewController.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    ArtistPickerCollectionViewDataSource,
    ArtistPickerCollectionViewControllerDelegate,
    UserProfileViewModelDelegate {
    
    var viewModel: UserProfileViewModel
    var keyboardManagerViewController: ArtistPickerCollectionViewController?
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    var artistPickerViewController: ArtistPickerCollectionViewController?
    var emptyState: UIImageView?
    var installation: PFInstallation
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        installation = PFInstallation.currentInstallation()
        super.init(collectionViewLayout: UserProfileViewController.getLayout())
        self.viewModel.delegate = self
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.delegate = nil
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        HUDProgressView.show()
        
        navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardServiceDidAddKeyboard:", name: "keyboard:added", object: nil)
        notificationCenter.addObserver(self, selector: "keyboardServiceDidRemoveKeyboard:", name: "keyboard:removed", object: nil)
        notificationCenter.addObserver(self, selector: "subscribeKeyboardsAsChannels", name: "pushNotificationsEnabled", object: nil)

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            if let height = tabBarController?.tabBar.bounds.size.height {
                var contentInset = collectionView.contentInset
                contentInset.bottom = height
                collectionView.contentInset = contentInset
            }
        }
        
        PKHUD.sharedHUD.hide(afterDelay: 3.0)
        
        delay(1.0) {
            self.registerPushNotifications()
        }
    }
    
    class func getLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 110)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 314)
        flowLayout.headerReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.itemSize = CGSizeMake(screenWidth, 240)
        flowLayout.disableStickyHeaders = false
        flowLayout.parallaxHeaderAlwaysOnTop = false

        return flowLayout
    }
    
    func registerPushNotifications() {
        var userNotificationTypes =
        UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound
        var settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        
        var application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    func subscribeKeyboardsAsChannels() {
        if let currentUser = viewModel.sessionManager.currentUser {
            installation.addUniqueObject(currentUser.id, forKey: "userId")
        }
        for i in 0..<viewModel.numberOfKeyboards {
            if let keyboard = viewModel.keyboardAtIndex(i) {
                
                let index = advance(keyboard.id.startIndex, 1)
                let id = keyboard.id[index..<keyboard.id.endIndex]
                installation.addUniqueObject(id, forKey: "channels")
            }
        }
        installation.saveInBackgroundWithBlock(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var installation = PFInstallation.currentInstallation()
        installation.badge = 0
        installation.saveInBackgroundWithBlock(nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()

        if indexPath.section == 0 && indexPath.row == 0 {
            let artistPicker = provideArtistPicker()

            cell.contentView.addSubview(artistPicker.view)
            artistPicker.view.frame = cell.bounds
            
            artistPickerViewController = artistPicker
            return cell
        }

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! UserProfileHeaderView
            cell.profileImageView.image = UIImage(named: "placeholder")
            cell.settingsButton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
            headerView = cell
            viewModel.requestData(completion: nil)
            return cell
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! UserProfileSectionHeaderView
            
            // TODO(luc):
            cell.editButton.addTarget(self, action: "didTapEditButton", forControlEvents: .TouchUpInside)
            sectionHeaderView = cell

            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 55.5)
    }
    
    func didTapEditButton() {
        if let artistPickerVC = artistPickerViewController {
            artistPickerVC.isDeletionModeOn = !artistPickerVC.isDeletionModeOn
            updateEditButton()
        }
    }
    
    func didTapSettingsButton() {
        let settingsVC = SettingsTableViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func updateEditButton() {
        if let artistPickerVC = artistPickerViewController {
            
            if let sectionHeaderView = sectionHeaderView {
                if artistPickerVC.isDeletionModeOn {
                    sectionHeaderView.editButton.setTitle("Done".uppercaseString, forState: .Normal)
                } else {
                    sectionHeaderView.editButton.setTitle("Edit".uppercaseString, forState: .Normal)
                }
            }
        }
    }
    
    private func provideArtistPicker() -> ArtistPickerCollectionViewController {
        var artistPicker = ArtistPickerCollectionViewController(edgeInsets: UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0))
        artistPicker.dataSource = self
        artistPicker.delegate = self
        keyboardManagerViewController = artistPicker
        artistPicker.view.backgroundColor = UIColor.clearColor()

        return artistPicker
    }
    
    private func showEmptyState() {
        if emptyState == nil {
            emptyState = UIImageView(image: UIImage(named: "UserProfileEmptyState"))
            emptyState?.setTranslatesAutoresizingMaskIntoConstraints(false)
            emptyState!.hidden = true
            if let keyboardManagerView = keyboardManagerViewController?.view {
                keyboardManagerView.addSubview(emptyState!)
                keyboardManagerView.addConstraints([
                    emptyState!.al_top == keyboardManagerView.al_top,
                    emptyState!.al_left == keyboardManagerView.al_left + 10,
                    emptyState!.al_right == keyboardManagerView.al_right,
                    emptyState!.al_bottom == keyboardManagerView.al_bottom
                ])
            }
        }
        emptyState!.hidden = false
        keyboardManagerViewController?.collectionView?.hidden = true
        sectionHeaderView?.editButton.hidden = true
    }
    
    private func hideEmptyState() {
        emptyState?.hidden = true
        keyboardManagerViewController?.collectionView?.hidden = false
        sectionHeaderView?.editButton.hidden = false
    }
    
    func keyboardServiceDidAddKeyboard(notification: NSNotification) {
        if let artistPicker = keyboardManagerViewController,
            let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int,
            let keyboardId = userInfo["keyboardId"] as? String {
                let id = keyboardId[advance(keyboardId.startIndex, 1)..<keyboardId.endIndex]
                installation.addUniqueObject(id, forKey: "channels")
                installation.saveInBackgroundWithBlock(nil)

                artistPicker.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        }
    }
    
    func keyboardServiceDidRemoveKeyboard(notification: NSNotification) {
        if let artistPicker = keyboardManagerViewController,
            let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int,
            let keyboardId = userInfo["keyboardId"] as? String {
                let id = keyboardId[advance(keyboardId.startIndex, 1)..<keyboardId.endIndex]
                installation.removeObjectForKey(id)
                installation.saveInBackgroundWithBlock(nil)
                artistPicker.collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        }
    }
    
    // MARK: UserProfileViewModelDelegate
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User) {
        if let headerView = headerView {
            headerView.profileImageView.setImageWithURL(NSURL(string: user.profileImageLarge), placeholderImage: UIImage(named: "placeholder"))
            headerView.nameLabel.text = user.name.uppercaseString
            headerView.coverPhotoView.image = UIImage(named: user.backgroundImage)
        }
    }
    
    func userProfileViewModelDidLoadKeyboardList(userProfileViewModel: UserProfileViewModel, keyboardList: [Keyboard]) {
        if let headerView = headerView {
            headerView.keyboardCountLabel.text = "\(keyboardList.count) cards".uppercaseString
        }
        
        if keyboardList.isEmpty {
            //TODO(luc): show empty state
            showEmptyState()
        } else {
            if let artistPicker = keyboardManagerViewController {
                hideEmptyState()
                artistPicker.collectionView?.reloadData()
            }
        }
        PKHUD.sharedHUD.hideAnimated()
    }
    
    // MARK: ArtistPickerCollectionViewDataSource
    func numberOfItemsInArtistPicker(artistPicker: ArtistPickerCollectionViewController) -> Int {
        return viewModel.numberOfKeyboards
    }
    
    func artistPickerItemAtIndex(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Keyboard? {
        return viewModel.keyboardAtIndex(index)
    }
    
    func artistPickerShouldHaveCloseButton(artistPicker: ArtistPickerCollectionViewController) -> Bool {
        return false
    }
    
    func artistPickerItemAtIndexIsSelected(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Bool {
        if let currentKeyboardId = viewModel.defaultKeyboardId,
            keyboard = viewModel.keyboardAtIndex(index) {
            return keyboard.id == currentKeyboardId
        }
        return false
    }
    
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard) {
        viewModel.defaultKeyboardId = keyboard.id
        
        var statusView = PKHUDStatusView(title: "\(keyboard.artistName.uppercaseString)", subtitle:"set as default card in your keyboard", image: PKHUDAssets.checkmarkImage)
        statusView.frame = CGRect(origin: CGPointZero, size: CGSizeMake(300, 325))
        statusView.backgroundColor = UIColor.whiteColor()
        
        statusView.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        statusView.imageView.contentMode = .ScaleAspectFit
        statusView.imageView.clipsToBounds = true
        statusView.imageView.alpha = 1.0
        statusView.imageView.layer.shadowColor = UIColor.blackColor().CGColor
        statusView.imageView.layer.shadowOffset = CGSizeMake(0, 3)
        statusView.imageView.layer.shadowOpacity = 0.54
        statusView.imageView.layer.shadowRadius = 8.0
        
        statusView.titleLabel.font = UIFont(name: "Oswald-Light", size: 24.0)
        statusView.titleLabel.backgroundColor = UIColor.clearColor()
        
        statusView.subtitleLabel.font = UIFont(name: "OpenSans", size: 12.0)
        statusView.subtitleLabel.backgroundColor = UIColor.clearColor()
        
        let imageURLLarge = NSURL(string: keyboard.artist!.imageURLLarge)!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let request = NSURLRequest(URL: imageURLLarge)
            statusView.imageView.setImageWithURLRequest(request, placeholderImage: UIImage(named: "placeholder"), success: { (req, res, image) in
                dispatch_async(dispatch_get_main_queue()) {
                    statusView.imageView.image = image
                    
                    PKHUD.sharedHUD.contentView = statusView
                    PKHUD.sharedHUD.show()
                    PKHUD.sharedHUD.hide(afterDelay: 1.0)
                }
            }, failure: { (req, res, err) in
            
            })
        }
        
        var data: [String: AnyObject] = [
            "keyboard_id": keyboard.id,
            "owner_name": keyboard.artistName,
            "index": keyboard.index
        ]
        
        if let artist = keyboard.artist {
            data["owner_id"] = artist.id
        }

        SEGAnalytics.sharedAnalytics().track("user-profile:card-tapped", properties: data)
    }

    func artistPickerCollectionViewControllerDidDeleteKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard, index: Int) {
        viewModel.deleteKeyboardWithId(keyboard.id, completion: { (err) -> () in
            self.updateEditButton()
            if self.viewModel.numberOfKeyboards == 0 {
                self.showEmptyState()
            } else {
                self.hideEmptyState()
            }
        })
    }
}
