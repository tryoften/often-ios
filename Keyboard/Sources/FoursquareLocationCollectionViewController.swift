//
//  FoursquareLocationCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let foursquareCellIdentifier = "Cell"

class FoursquareLocationCollectionViewController: UICollectionViewController {
    var sectionHeaderView: FoursquareLocationSectionHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        if let collectionView = collectionView {
            collectionView.registerClass(FoursquareLocationCollectionViewCell.self, forCellWithReuseIdentifier: foursquareCellIdentifier)
            collectionView.registerClass(FoursquareLocationSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Vertical
        viewLayout.minimumInteritemSpacing = 5.0
        viewLayout.minimumLineSpacing = 5.0
        viewLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        viewLayout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 50.0)
        return viewLayout
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(foursquareCellIdentifier, forIndexPath: indexPath) as! FoursquareLocationCollectionViewCell
    
        let score = 9.3
        
        cell.titleLabel.text = "Gasoline Alley"
        cell.addressLabel.text = "325 Lafayette St, New York,..."
        cell.ratingLabel.text = "\(score)/10"
        cell.setRatingBackgroundColor(score)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! FoursquareLocationSectionHeader
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
}
