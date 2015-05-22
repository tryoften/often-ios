//
//  UserProfileViewController.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    UserProfileViewModelDelegate {
    
    var viewModel: UserProfileViewModel
    var keyboardManagerViewController: ArtistPickerCollectionViewController?
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UserProfileViewController.getLayout())
        self.viewModel.delegate = self
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestData(completion: nil)

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    class func getLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 200)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 314)
        flowLayout.headerReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.itemSize = CGSizeMake(screenWidth, 240)
        flowLayout.disableStickyHeaders = true
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
            var artistPicker = ArtistPickerCollectionViewController(collectionViewLayout: ArtistPickerCollectionViewController.provideCollectionViewLayout(CGRectZero))
            keyboardManagerViewController = artistPicker
            artistPicker.closeButton.removeFromSuperview()
            artistPicker.view.backgroundColor = UIColor.clearColor()
            
            var layout = ArtistPickerCollectionViewController.provideCollectionViewLayout(CGRectZero)
            layout.sectionInset = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 5.0)
            artistPicker.collectionView?.setCollectionViewLayout(layout, animated: false)

            if let keyboardList = viewModel.keyboardsList {
                artistPicker.keyboards = keyboardList
            }

            cell.contentView.addSubview(artistPicker.view)
            artistPicker.view.frame = cell.bounds
            return cell
        }

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! UserProfileHeaderView
            cell.profileImageView.setImageWithURL(NSURL(string: "https://scontent-atl.xx.fbcdn.net/hphotos-xfa1/v/l/t1.0-9/10858372_10152928508488584_1315316552519268754_n.jpg?oh=42ee8e85fc4c842be55c8314766c48ea&oe=55CF5AD7"))
            cell.coverPhotoView.setImageWithURL(NSURL(string: "https://scontent-iad3-1.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/p720x720/10362377_10152729420793584_4850878730011552484_n.jpg?oh=7790e73162ba6e2c946329513311c027&oe=55C99ED1"))
            cell.nameLabel.text = "Luc Succes".uppercaseString
            cell.keyboardCountLabel.text = "32 keyboards".uppercaseString
            return cell
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! UICollectionReusableView
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 55.5)
    }
    
    // MARK: UserProfileViewModelDelegate
    
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User) {
        
    }
    
    func userProfileViewModelDidLoadKeyboardList(userProfileViewModel: UserProfileViewModel, keyboardList: [Keyboard]) {
        if let artistPicker = keyboardManagerViewController {
            artistPicker.keyboards = keyboardList
        }
    }
}
