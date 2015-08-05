//
//  ServiceSettingsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let ServiceSettingsViewCell = "serviceCell"

class ServiceSettingsCollectionViewController: UICollectionViewController {

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 80 , 150)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.registerClass(ServiceSettingsCollectionViewCell.self, forCellWithReuseIdentifier: ServiceSettingsViewCell)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ServiceSettingsViewCell, forIndexPath: indexPath) as! ServiceSettingsCollectionViewCell
    
        cell.settingServicesType = .Venmo
        cell.serviceLogoImageView.image = UIImage(named: "venmo-off")
        cell.serviceSwitch.on = false
        cell.serviceSubtitleLabel.text = "Connect your Venmo account to start sending payments & requests from your keyboard."
        
        return cell
    }
}
