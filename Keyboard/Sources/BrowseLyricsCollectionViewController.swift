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
    var track: TrackMediaItem

    init(trackMediaItem: TrackMediaItem, viewModel: BrowseViewModel) {
        track = trackMediaItem
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView?.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: albumLyricCellReuseIdentifier)
    }

    override func headerViewDidLoad() {
        if let imageURLStr = track.song_art_image_url,
            let imageURL = NSURL(string: imageURLStr) {
            headerView?.coverPhoto.setImageWithAnimation(imageURL)
            headerView?.titleLabel.text = track.title
        }
    }

    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = BrowseCollectionViewController.provideCollectionViewLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 55)
        return layout
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return track.lyrics.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(albumLyricCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell,
            let lyric = track.lyrics[indexPath.row] as? LyricMediaItem where indexPath.row < track.lyrics.count else {
                return UICollectionViewCell()
        }
        
        cell.reset()
        cell.mainTextLabel.text = lyric.text
        cell.mainTextLabel.textAlignment = .Center
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        cell.showImageView = false

        print(lyric.text, lyric.score)

        return cell
    }
}
