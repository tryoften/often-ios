//
//  ServiceSettingsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let ServiceSettingsViewCell = "serviceCell"

class ServiceSettingsCollectionViewController: UICollectionViewController, AddServiceProviderDelegate {
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    var serviceSettingsCell: ServiceSettingsCollectionViewCell?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
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
            collectionView.registerClass(ServiceSettingsCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
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
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! ServiceSettingsCollectionViewCell
        serviceSettingsCell = cell
        serviceSettingsCell?.delegate = self
        
        cell.settingServicesType = .Venmo
        cell.serviceLogoImageView.image = UIImage(named: "venmo-off")
        cell.serviceSwitch.on = false
        cell.serviceSubtitleLabel.text = "Connect your Venmo account to start sending payments & requests from your keyboard."
        
        return cell
    }
    
    func addServiceProviderCellDidTapSwitchButton(serviceSettingsCollectionView: ServiceSettingsCollectionViewCell, selected: Bool) {
        Venmo.startWithAppId(VenmoAppID, secret: VenmoAppSecret, name: "SWRV")
        Venmo.sharedInstance().requestPermissions(["make_payments", "access_profile", "access_friends"]) { (success, error) -> Void in
            if success {
                println("Permissions Success!")
            } else {
                println("Permissions Fail")
            }
        }
        
        if Venmo.isVenmoAppInstalled() {
            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API
        } else {
            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.AppSwitch
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0 as CGFloat
    }
}
