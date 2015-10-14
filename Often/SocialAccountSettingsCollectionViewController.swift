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
    var sectionHeaderView: SocialAccountHeaderView?
    var shadowView:UIView
    var serviceSettingsCell: SocialAccountSettingsCollectionViewCell?
   
    
    init(collectionViewLayout layout: UICollectionViewLayout, viewModel: SocialAccountSettingsViewModel) {
        self.viewModel = viewModel
        
        shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = BlackColor
        shadowView.alpha = 0.10
        
        super.init(collectionViewLayout: layout)
        view.addSubview(shadowView)
        
        self.viewModel.delegate = self
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Vertical
        viewLayout.headerReferenceSize = CGSizeMake(screenWidth - 95, 250)
        viewLayout.sectionInset = UIEdgeInsetsMake(25.0, 5.0, 5.0, 70.0)
        viewLayout.itemSize = CGSizeMake(screenWidth - 95, 218)
        return viewLayout
    }
    
    func setupLayout() {
        view.addConstraints([
            shadowView.al_top == view.al_top,
            shadowView.al_bottom == view.al_bottom,
            shadowView.al_right == view.al_right,
            shadowView.al_width == 61,
            
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(SocialAccountSettingsCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
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
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! SocialAccountHeaderView
            sectionHeaderView = cell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! SocialAccountSettingsCollectionViewCell
            return cell
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! SocialAccountSettingsCollectionViewCell
            if  viewModel.socialAccounts.count > indexPath.row {
                let socialAccount = viewModel.socialAccounts[indexPath.row]
                serviceSettingsCell = cell
                serviceSettingsCell?.delegate = self
                cell.settingSocialAccount = socialAccount
                cell.serviceSwitch.on = socialAccount.activeStatus
                cell.serviceSwitch.tag = indexPath.row
                cell.checkButtonStatus(socialAccount.activeStatus)
            }
            
            return cell
        
    }
    
    func addServiceProviderCellDidTapSwitchButton(serviceSettingsCollectionView: SocialAccountSettingsCollectionViewCell, selected: Bool, buttonTag:Int ) {
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
                viewModel.sessionManager.setSocialAccountOnCurrentUser(serviceSettingsCollectionView.settingSocialAccount, completion: { user,err  in
                })
            }
            break
        case .Soundcloud:
            if selected {
                viewModel.soundcloudAccountManager.sendRequest({ err  in
                    print("it worked")
                })
            } else {
                serviceSettingsCollectionView.settingSocialAccount.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(serviceSettingsCollectionView.settingSocialAccount, completion: { user,err  in
                })
                
            }
            break
        case .Venmo:
            if selected {
                viewModel.venmoAccountManager.createRequest()
            } else {
                serviceSettingsCollectionView.settingSocialAccount.activeStatus = selected
                viewModel.sessionManager.setSocialAccountOnCurrentUser(serviceSettingsCollectionView.settingSocialAccount, completion: { user,err  in
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
        self.viewModel.sessionManager.setSocialAccountOnCurrentUser(socialAccount, completion: { user,err  in
            print("we did it")
        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0 as CGFloat
    }
    
}
