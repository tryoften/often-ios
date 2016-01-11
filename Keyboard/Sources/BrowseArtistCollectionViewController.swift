//
//  TrendingArtistAlbumsCollectionCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 12/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let artistAlbumCellReuseIdentifier = "albumCell"

class BrowseArtistCollectionViewController: BrowseCollectionViewController {
    override class var cellHeight: CGFloat {
        return 75.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView?.registerClass(TrackCollectionViewCell.self, forCellWithReuseIdentifier: artistAlbumCellReuseIdentifier)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(artistAlbumCellReuseIdentifier, forIndexPath: indexPath) as? TrackCollectionViewCell
        
        cell?.imageView.image = UIImage(named: "weeknd")
        cell?.titleLabel.text = "Can't Feel My Face"
        cell?.subtitleLabel.text = "The Weeknd"
        
        return cell!
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let lyricsVC = BrowseLyricsCollectionViewController()
        lyricsVC.navigationBar.shouldDisplayOptions = false
        navigationController?.pushViewController(lyricsVC, animated: true)
    }
}
