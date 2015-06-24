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
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UserProfileViewController.getLayout())
        self.viewModel.delegate = self
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        viewModel.requestData(completion: nil)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            if let height = tabBarController?.tabBar.bounds.size.height {
                var contentInset = collectionView.contentInset
                contentInset.bottom = height + 20
                collectionView.contentInset = contentInset
            }
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            return cell
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! UserProfileSectionHeaderView
            
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
            
            if let sectionHeaderView = sectionHeaderView {
                if artistPickerVC.isDeletionModeOn {
                    sectionHeaderView.editButton.setTitle("Done".uppercaseString, forState: .Normal)
                } else {
                    sectionHeaderView.editButton.setTitle("Edit".uppercaseString, forState: .Normal)
                }
            }
        }
    }
    
    func didTapSettingsButton() {
        let settingsVC = SettingsTableViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func provideArtistPicker() -> ArtistPickerCollectionViewController {
        var artistPicker = ArtistPickerCollectionViewController(edgeInsets: UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0))
        artistPicker.dataSource = self
        keyboardManagerViewController = artistPicker
        artistPicker.view.backgroundColor = UIColor.clearColor()

        return artistPicker
    }
    
    // MARK: UserProfileViewModelDelegate
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User) {
        if let headerView = headerView {
            headerView.profileImageView.setImageWithURL(NSURL(string: user.profileImageLarge), placeholderImage: UIImage(named: "placeholder"))
            headerView.nameLabel.text = user.fullName.uppercaseString
            headerView.coverPhotoView.image = UIImage(named: "user-profile-bg-\(arc4random_uniform(4) + 1)")
        }
    }
    
    func userProfileViewModelDidLoadKeyboardList(userProfileViewModel: UserProfileViewModel, keyboardList: [Keyboard]) {
        if let headerView = headerView {
            headerView.keyboardCountLabel.text = "\(keyboardList.count) cards".uppercaseString
        }
        if let artistPicker = keyboardManagerViewController {
            artistPicker.collectionView?.reloadData()
        }
        PKHUD.sharedHUD.hideAnimated()
    }
    
    // MARK: ArtistPickerCollectionViewDataSource
    func numberOfItemsInArtistPicker(artistPicker: ArtistPickerCollectionViewController) -> Int {
        if let keyboards = viewModel.keyboardsList {
            return keyboards.count
        }
        return 0
    }
    
    func artistPickerItemAtIndex(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Keyboard? {
        if let keyboards = viewModel.keyboardsList {
            if index < keyboards.count {
                return keyboards[index]
            }
        }
        return nil
    }
    
    func artistPickerShouldHaveCloseButton(artistPicker: ArtistPickerCollectionViewController) -> Bool {
        return false
    }
    
    func artistPickerItemAtIndexIsSelected(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Bool {
        return false
    }
    
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard) {
        
    }

    func artistPickerCollectionViewControllerDidDeleteKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard, index: Int) {
        viewModel.deleteKeyboardWithId(keyboard.id, completion: { (err) -> () in
            
        })
    }
}
