//
//  TredingAlbumLyricsCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 12/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let albumLyricCellReuseIdentifier = "albumLyricCell"

class BrowseLyricsCollectionViewController: BrowseCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView?.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: albumLyricCellReuseIdentifier)
    }

    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = BrowseCollectionViewController.provideCollectionViewLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        return layout
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(albumLyricCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        cell.reset()
        cell.leftHeaderLabel.text = "The Hills"
        cell.rightHeaderLabel.text = "Single"
        cell.mainTextLabel.text = "Your man on the road he doin' promo\nYou said, \"Keep your business on the low-low\""
        cell.mainTextLabel.textAlignment = .Center
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        cell.showImageView = false
    
        return cell
    }
}
