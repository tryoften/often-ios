//
//  AccountManagerSettingsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let ServiceSettingsViewCell = "serviceCell"


class SocialAccountSettingsCollectionViewController: UICollectionViewController, AddServiceProviderDelegate, SocialAccountSettingsViewModelDelegate  {
    var headerView: UserProfileHeaderView?
    var viewModel: SocialAccountSettingsViewModel
    var sectionHeaderView: UserProfileSectionHeaderView?
    var serviceSettingsCell: SocialAccountSettingsCollectionViewCell?
   
    
    init(collectionViewLayout layout: UICollectionViewLayout, viewModel: SocialAccountSettingsViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
        self.viewModel.delegate = self
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Vertical
//        viewLayout.minimumInteritemSpacing = 5.0
//        viewLayout.minimumLineSpacing = 5.0
        viewLayout.sectionInset = UIEdgeInsetsMake(25.0, 5.0, 5.0, 5.0)
        viewLayout.itemSize = CGSizeMake(screenWidth - 30, 218)
        return viewLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(SocialAccountSettingsCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
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
        return viewModel.socialAccounts.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! SocialAccountSettingsCollectionViewCell
        if  viewModel.socialAccounts.count > indexPath.row {
            var socialAccount = viewModel.socialAccounts[indexPath.row]
            serviceSettingsCell = cell
            serviceSettingsCell?.delegate = self
            cell.settingServicesType = socialAccount.type!
            cell.serviceSwitch.on = socialAccount.activeStatus
            cell.serviceSwitch.tag = indexPath.row
            cell.checkButtonStatus(socialAccount.activeStatus)
        }
        
        return cell
    }
    
    func addServiceProviderCellDidTapSwitchButton(serviceSettingsCollectionView: SocialAccountSettingsCollectionViewCell, selected: Bool, buttonTag:Int ) {
        viewModel.socialAccounts[buttonTag ].activeStatus = !viewModel.socialAccounts[buttonTag].activeStatus
        switch serviceSettingsCollectionView.settingServicesType {
        case .Twitter:
            if selected {
                viewModel.sessionManager.login(.Twitter, completion: nil)
            } else {
                
            }
            
            break
        case .Spotify:
            if selected {
                UIApplication.sharedApplication().openURL(SPTAuth.defaultInstance().loginURL)
            } else {
                viewModel.spotifyAccountManager.spotifyAccount?.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(viewModel.spotifyAccountManager.spotifyAccount!, completion: { user,err  in
                    self.viewModel.updateLocalSocialAccount(.Spotify)
                })
            }
            break
        case .Soundcloud:
            if selected {
                let soundcloud = SoundcloudAccountManager()
                viewModel.soundcloudAccountManager.sendRequest({ err  in
                    println("it worked")
                })
            } else {
                viewModel.soundcloudAccountManager.soundcloudAccount?.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(viewModel.soundcloudAccountManager.soundcloudAccount!, completion: { user,err  in
                    self.viewModel.updateLocalSocialAccount(.Soundcloud)
                })
                
            }
            break
        case .Venmo:
            if selected {
                viewModel.venmoAccountManager.createRequest()
            } else {
                viewModel.venmoAccountManager.venmoAccount?.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(viewModel.venmoAccountManager.venmoAccount!, completion: { user,err  in
                      self.viewModel.updateLocalSocialAccount(.Venmo)
                })
            }
            break
        default:
            break
        }
    }
    
    func socialAccountSettingsViewModelDidLoginUser(userProfileViewModel: SocialAccountSettingsViewModel, user: User) {
        
    }
    
    func socialAccountSettingsViewModelDidLoadSocialAccountList(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: SocialAccount) {
        self.viewModel.sessionManager.setSocialAccountOnCurrentUser(socialAccount, completion: { user,err  in
            println("we did it")
            self.viewModel.updateLocalSocialAccount(socialAccount.type!)
        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0 as CGFloat
    }
}
