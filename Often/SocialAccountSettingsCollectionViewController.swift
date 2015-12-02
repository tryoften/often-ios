//
//  AccountManagerSettingsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let ServiceSettingsViewCell = "serviceCell"

class SocialAccountSettingsCollectionViewController: UICollectionViewController, AddServiceProviderDelegate, SocialAccountSettingsViewModelDelegate {
    var headerView: UserProfileHeaderView?
    var viewModel: SocialAccountSettingsViewModel
    var sectionHeaderView: SocialAccountHeaderView?
    var serviceSettingsCell: SocialAccountSettingsCollectionViewCell?
    
    init(collectionViewLayout layout: UICollectionViewLayout, viewModel: SocialAccountSettingsViewModel) {
        self.viewModel = viewModel
    
        super.init(collectionViewLayout: layout)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Vertical
        viewLayout.headerReferenceSize = CGSizeMake(screenWidth - 85, 250)
        viewLayout.sectionInset = UIEdgeInsetsMake(-10.0, 5.0, 15.0, 65.0)
        viewLayout.itemSize = CGSizeMake(screenWidth - 85, 180)
        return viewLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(SocialAccountSettingsCollectionViewCell.self, forCellWithReuseIdentifier: ServiceSettingsViewCell)
            collectionView.registerClass(SocialAccountHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if viewModel.socialAccounts.isEmpty {
            viewModel.sessionManager.fetchSocialAccount()
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

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as? SocialAccountHeaderView {
                sectionHeaderView = cell
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ServiceSettingsViewCell, forIndexPath: indexPath) as? SocialAccountSettingsCollectionViewCell {
                return cell
            }
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard viewModel.socialAccounts.count > indexPath.row,
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ServiceSettingsViewCell, forIndexPath: indexPath) as? SocialAccountSettingsCollectionViewCell else {
            return UICollectionViewCell()
        }

        let socialAccount = viewModel.socialAccounts[indexPath.row]
        serviceSettingsCell = cell
        serviceSettingsCell?.delegate = self
        cell.settingSocialAccount = socialAccount
        cell.serviceSwitch.on = socialAccount.activeStatus
        cell.serviceSwitch.tag = indexPath.row
        cell.checkButtonStatus(socialAccount.activeStatus)

        return cell
    }
    
    func addServiceProviderCellDidTapSwitchButton(serviceSettingsCollectionView: SocialAccountSettingsCollectionViewCell, selected: Bool, buttonTag: Int) {
        viewModel.socialAccounts[buttonTag ].activeStatus = !viewModel.socialAccounts[buttonTag].activeStatus
        switch serviceSettingsCollectionView.settingSocialAccount.type {
        case .Twitter:
            if selected {
                do {
                    try viewModel.sessionManager.login(.Twitter, completion: { results  -> Void in
                        PKHUD.sharedHUD.hide(animated: true)
                        switch results {
                        case .Success(_): self.collectionView?.reloadData()
                        case .Error(let e): print("Error", e)
                        default: break
                        }
                    })
                } catch {
                    
                }
            } else {
                viewModel.sessionManager.logout()
                
            }
            
            break
        case .Spotify:
            if selected {
                UIApplication.sharedApplication().openURL(SPTAuth.defaultInstance().loginURL)
            } else {
                serviceSettingsCollectionView.settingSocialAccount.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(serviceSettingsCollectionView.settingSocialAccount, completion: { user, err  in
                })
            }
            break
        case .Soundcloud:
            if selected {
                viewModel.soundcloudAccountManager?.sendRequest({ err  in
                })
            } else {
                serviceSettingsCollectionView.settingSocialAccount.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(serviceSettingsCollectionView.settingSocialAccount, completion: { user, err  in
                })
            }
            break
        default:
            break
        }
    }
    
    func socialAccountSettingsViewModelDidLoginUser(userProfileViewModel: SocialAccountSettingsViewModel, user: User) {
        
    }
    
    func socialAccountSettingsViewModelDidLoadSocialAccountList(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: [SocialAccount]) {
        self.collectionView?.reloadData()
    }
    
    func socialAccountSettingsViewModelDidLoadSocialAccount(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: SocialAccount) {
        self.viewModel.sessionManager.setSocialAccountOnCurrentUser(socialAccount, completion: { user, err  in

        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0 as CGFloat
    }
    
}
