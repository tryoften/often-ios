//
//  TrendingLyricsHorizontalCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let TrendingLyricsCellReuseIdentifier = "TrendingLyricsCell"

class TrendingLyricsHorizontalCollectionViewController: MediaItemsCollectionBaseViewController {
    var parentVC: MediaItemsCollectionBaseViewController?
    var group: MediaItemGroup? {
        didSet {
            collectionView?.reloadData()
        }
    }

    init() {
        super.init(collectionViewLayout: TrendingLyricsHorizontalCollectionViewController.provideLayout())
        #if KEYBOARD
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)
        #endif
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: TrendingLyricsCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.showsHorizontalScrollIndicator = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 60, 105)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return layout
    }

    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let group = group {
            return group.items.count
        }
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if screenHeight < screenWidth {
            return CGSizeMake(screenWidth - 60, 90)
        } else {
            return CGSizeMake(screenWidth - 60, 105)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrendingLyricsCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.reset()

        guard let lyric = group?.items[indexPath.row] as? LyricMediaItem else {
            return cell
        }

        if let url = lyric.smallImage, let imageURL = NSURL(string: url) {
            cell.avatarImageURL = imageURL
        }

        cell.leftHeaderLabel.text = lyric.artist_name
        cell.rightHeaderLabel.text = lyric.track_title
        cell.mainTextLabel.text = lyric.text
        cell.mainTextLabel.textAlignment = .Center
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        cell.showImageView = false
        cell.mediaLink = lyric
        cell.type = .Metadata
        cell.delegate = self

        #if !(KEYBOARD)
           cell.inMainApp = true
        #endif
        
        cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(lyric)
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)

        if let lyric = group?.items[indexPath.row] as? LyricMediaItem,
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrendingLyricsCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell {
                cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(lyric)
        }
    }
}
