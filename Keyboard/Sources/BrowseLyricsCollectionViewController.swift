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
    var track: TrackMediaItem? {
        didSet {
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadSections(NSIndexSet(index: 0))
            }, completion: nil)
            headerViewDidLoad()
        }
    }

    var trackId: String

    init(trackId: String, viewModel: BrowseViewModel) {
        self.trackId = trackId
        super.init(viewModel: viewModel)

        #if KEYBOARD
        collectionView?.contentInset = UIEdgeInsetsMake(63.0 + KeyboardSearchBarHeight, 0, 0, 0)
        #endif
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView?.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: albumLyricCellReuseIdentifier)

        viewModel.getTrackWithOftenid(trackId) { track in
            self.track = track
        }
    }


    override func headerViewDidLoad() {
        if let imageURLStr = track?.song_art_image_url,
            let title = track?.title,
            let subtitle = track?.artist_name,
            let imageURL = NSURL(string: imageURLStr) {
            setupHeaderView(imageURL, title: title, subtitle: subtitle)
        }
    }

    override func sectionHeaderTitleAtIndexPath(indexPath: NSIndexPath) -> String {
        if indexPath.row == 0 {
            return "All Lyrics"
        }
        return ""
    }

    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = BrowseCollectionViewController.provideCollectionViewLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 95)
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return layout
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = track?.lyrics.count {
            return count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MediaItemCollectionViewCell = parseMediaItemData(track?.lyrics, indexPath: indexPath, collectionView: collectionView)
        cell.delegate = self
        cell.type = .NoMetadata

        #if !(KEYBOARD)
            cell.inMainApp = true
        #endif

        animateCell(cell, indexPath: indexPath)

        return cell
    }
}
