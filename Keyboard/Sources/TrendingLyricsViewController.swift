//
//  LyricsTrendingViewController.swift
//  Often
//
//  Created by Luc Succes on 12/8/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable line_length

import UIKit

enum TrendingLyricsSection: Int {
    case TrendingLyrics = 0
    case TrendingArtists = 1
    case TrendingSongs = 2
}

let cellReuseIdentifier = "cell"
let songCellReuseIdentifier = "songCell"

class TrendingLyricsViewController: FullScreenCollectionViewController, UICollectionViewDelegateFlowLayout,
    MediaItemGroupViewModelDelegate {

    var lyricsHorizontalVC: TrendingLyricsHorizontalCollectionViewController?
    var artistsHorizontalVC: TrendingArtistsHorizontalCollectionViewController?
    var viewModel: TrendingLyricsViewModel


    init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: collectionViewLayout)
        viewModel.delegate = self

        collectionView?.backgroundColor = VeryLightGray
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + 2, 0, 0, 0)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.registerClass(SongCollectionViewCell.self, forCellWithReuseIdentifier: songCellReuseIdentifier)
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try viewModel.fetchData()
        } catch _ {}
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }

    class func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.groups.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = viewModel.groupAtIndex(section) else {
            return 1
        }

        switch group.type {
        case .Track:
            return group.items.count
        default:
            return 1
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView,
            let group = viewModel.groupAtIndex(indexPath.row) else {
            return UICollectionReusableView()
        }

        cell.topSeperator.hidden = indexPath.section != 0
        cell.leftText = group.title

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let baseSize = CGSizeMake(screenWidth, 115)

        guard let group = viewModel.groupAtIndex(indexPath.section) else {
            return baseSize
        }

        switch group.type {
        case .Lyric:
            return CGSizeMake(screenWidth, 125)
        case .Artist:
            return CGSizeMake(screenWidth, 230)
        case .Track:
            return CGSizeMake(screenWidth - 20, 74)
        default:
            return baseSize
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let section = TrendingLyricsSection(rawValue: section) else {
            return UIEdgeInsetsZero
        }

        switch section {
        case .TrendingLyrics:
            return UIEdgeInsetsZero
        case .TrendingArtists:
            return UIEdgeInsetsZero
        case .TrendingSongs:
            return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 36)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = viewModel.groupAtIndex(indexPath.section) else {
            return UICollectionViewCell()
        }

        switch group.type {
        case .Lyric:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let lyricsHorizontalVC = provideTrendingLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC.group = group

            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.frame = cell.bounds

            return cell
        case .Artist:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let artistsHorizontalVC = provideTrendingArtistsHorizontalCollectionViewController()
            artistsHorizontalVC.group = group

            cell.contentView.addSubview(artistsHorizontalVC.view)
            artistsHorizontalVC.view.frame = cell.bounds

            self.artistsHorizontalVC = artistsHorizontalVC
            return cell
        case .Track:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(songCellReuseIdentifier, forIndexPath: indexPath) as? SongCollectionViewCell, let track = group.items[indexPath.row] as?TrackMediaItem else {
                return SongCollectionViewCell()
            }

            if let imageURLStr = track.song_art_image_url, let imageURL = NSURL(string: imageURLStr) {
                cell.albumCoverThumbnail.setImageWithURL(imageURL)
            }
            cell.albumTitleLabel.text = track.albumName
            cell.artistLabel.text = track.artist_name
            cell.albumTitleLabel.text = track.title
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func provideTrendingLyricsHorizontalCollectionViewController() -> TrendingLyricsHorizontalCollectionViewController {
        if lyricsHorizontalVC == nil {
            lyricsHorizontalVC = TrendingLyricsHorizontalCollectionViewController()
            addChildViewController(lyricsHorizontalVC!)
        }
        return lyricsHorizontalVC!
    }

    func provideTrendingArtistsHorizontalCollectionViewController() -> TrendingArtistsHorizontalCollectionViewController {
        if artistsHorizontalVC == nil {
            artistsHorizontalVC = TrendingArtistsHorizontalCollectionViewController()
            addChildViewController(artistsHorizontalVC!)
        }
        
        return artistsHorizontalVC!
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
    }
}