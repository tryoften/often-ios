//
//  TrendingArtistAlbumsCollectionCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 12/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let artistAlbumCellReuseIdentifier = "albumCell"

class BrowseArtistCollectionViewController: BrowseMediaItemViewController {
    override class var cellHeight: CGFloat {
        return 75.0
    }

    var artist: ArtistMediaItem? {
        didSet {
            delay(0.5) {
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.reloadSections(NSIndexSet(index: 0))
                }, completion: nil)
            }
            headerViewDidLoad()
        }
    }

    var artistId: String

    init(artistId: String, viewModel: BrowseViewModel) {
        self.artistId = artistId
        super.init(viewModel: viewModel)

    #if KEYBOARD
        collectionView?.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
    #else
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
    #endif
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView?.registerClass(TrackCollectionViewCell.self, forCellWithReuseIdentifier: artistAlbumCellReuseIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        artist = nil
        collectionView?.reloadData()
        shouldSendScrollEvents = true

        viewModel.getArtistWithOftenId(artistId) { model in
            self.artist = model

        #if !(KEYBOARD)
            self.hideHud()
        #endif
        }

    }

    override func viewWillDisappear(animated: Bool) {
        shouldSendScrollEvents = false
    }

    override func headerViewDidLoad() {
        if let image = artist?.image, let imageURL = NSURL(string: image), let name = artist?.name,
            let tracksCount = artist?.tracks_count {
            setupHeaderView(imageURL, title: name, subtitle: "\(tracksCount) tracks")
        }
    }

    override func sectionHeaderTitleAtIndexPath(indexPath: NSIndexPath) -> String {
        if indexPath.section == 0 {
            return "Top Songs"
        }
        return ""
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tracksCount = artist?.tracks.count {
            return tracksCount
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(artistAlbumCellReuseIdentifier, forIndexPath: indexPath) as? TrackCollectionViewCell,
            let track = artist?.tracks[indexPath.row] else {
                return UICollectionViewCell()
        }

        if let imageURLString = track.image, let imageURL = NSURL(string: imageURLString) {
            cell.imageURL = imageURL
        }
        cell.titleLabel.text = track.title
        cell.subtitleLabel.text = track.album_name

        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true

        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let track = artist?.tracks[indexPath.row] else {
            return
        }

        let tracksVC = BrowseTrackCollectionViewController(trackId: track.id, viewModel: self.viewModel)
        tracksVC.textProcessor = textProcessor

        self.navigationController?.pushViewController(tracksVC, animated: true)
    }
}
