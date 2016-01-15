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

    var artist: ArtistMediaItem

    init(artistMediaItem: ArtistMediaItem, viewModel: BrowseViewModel) {
        artist = artistMediaItem
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView?.registerClass(TrackCollectionViewCell.self, forCellWithReuseIdentifier: artistAlbumCellReuseIdentifier)
        navigationItem.backBarButtonItem?.title = ""
    }

    override func headerViewDidLoad() {
        if let image = artist.image, let imageURL = NSURL(string: image), let name = artist.name {
            setupHeaderView(imageURL, title: name, subtitle: "")
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artist.tracks.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(artistAlbumCellReuseIdentifier, forIndexPath: indexPath) as? TrackCollectionViewCell,
            let track = artist.tracks[indexPath.row] as? TrackMediaItem where indexPath.row < artist.tracks.count else {
                return UICollectionViewCell()
        }

        if let imageURLString = track.image, let imageURL = NSURL(string: imageURLString) {
            cell.imageView.setImageWithAnimation(imageURL)
        }
        cell.titleLabel.text = track.title
        cell.subtitleLabel.text = track.album_name
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let track = artist.tracks[indexPath.row] as? TrackMediaItem where indexPath.row < artist.tracks.count else {
            return
        }

        viewModel.getTrackWithOftenid(track.id) { track in
            let lyricsVC = BrowseLyricsCollectionViewController(trackMediaItem: track, viewModel: self.viewModel)
            self.navigationController?.pushViewController(lyricsVC, animated: true)
        }
    }
}
