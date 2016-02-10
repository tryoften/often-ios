//
//  MediaItemGroupsViewController.swift
//  Often
//
//  Created by Luc Succes on 1/27/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class MediaItemGroupsViewController: MediaItemsCollectionBaseViewController, UICollectionViewDelegateFlowLayout {
    var lyricsHorizontalVC: TrendingLyricsHorizontalCollectionViewController?
    var artistsHorizontalVC: TrendingArtistsHorizontalCollectionViewController?
    var viewModel: BrowseViewModel
    var displayedData: Bool

    init(collectionViewLayout: UICollectionViewLayout = MediaItemGroupsViewController.getLayout(),
        viewModel: BrowseViewModel, textProcessor: TextProcessingManager? = nil) {
        self.viewModel = viewModel
        displayedData = false

        super.init(collectionViewLayout: collectionViewLayout)
        self.textProcessor = textProcessor

        collectionView?.backgroundColor = VeryLightGray
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: artistsCellReuseIdentifier)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: lyricsCellReuseIdentifier)
        collectionView?.registerClass(TrackCollectionViewCell.self, forCellWithReuseIdentifier: songCellReuseIdentifier)
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        do {
            try viewModel.fetchData()
        } catch _ {}
    }

    internal func groupAtIndex(index: Int) -> MediaItemGroup? {
        return viewModel.groupAtIndex(index)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.groups.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = groupAtIndex(section) else {
            return 1
        }

        switch group.type {
        case .Track:
            return group.items.count
        default:
            return 1
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let baseSize = CGSizeMake(screenWidth, 115)

        guard let group = groupAtIndex(indexPath.section) else {
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
        guard let group = groupAtIndex(section) else {
            return UIEdgeInsetsZero
        }

        switch group.type {
        case .Track:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        default:
            return UIEdgeInsetsZero
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 36)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showNavigationBar(true)

        guard let group = groupAtIndex(indexPath.section),
            let viewModel = viewModel as? BrowseViewModel,
            let item = group.items[indexPath.row] as? MediaItem else {
                return
        }

        switch item.type {
        case .Lyric:
            if let lyric = item as? LyricMediaItem {
                print(lyric)
            }
        case .Artist:
            if let artist = item as? ArtistMediaItem {
                let artistsVC = BrowseArtistCollectionViewController(artistId: artist.id, viewModel: viewModel, textProcessor: textProcessor)
                self.navigationController?.pushViewController(artistsVC, animated: true)
            }
        case .Track:
            if let track = item as? TrackMediaItem {
                Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.navigate), additionalProperties: AnalyticsAdditonalProperties.navigate("BrowseTrackCollectionViewController", itemID: track.id, itemIndex: String(indexPath.length), itemType: track.type.rawValue))

                let lyricsVC = BrowseTrackCollectionViewController(trackId: track.id, viewModel: viewModel, textProcessor: textProcessor)
                self.navigationController?.pushViewController(lyricsVC, animated: true)
            }
        default:
            break
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView,
            let group = groupAtIndex(indexPath.section) else {
                return UICollectionReusableView()
        }

        cell.topSeperator.hidden = indexPath.section == 0
        cell.leftText = group.title

        return cell
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = groupAtIndex(indexPath.section) else {
            return UICollectionViewCell()
        }

        switch group.type {
        case .Lyric:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(lyricsCellReuseIdentifier, forIndexPath: indexPath)
            let lyricsHorizontalVC = provideTrendingLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC.group = group

            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            lyricsHorizontalVC.view.frame = cell.bounds

            return cell
        case .Artist:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(artistsCellReuseIdentifier, forIndexPath: indexPath)
            let artistsHorizontalVC = provideTrendingArtistsHorizontalCollectionViewController()
            artistsHorizontalVC.group = group

            cell.contentView.addSubview(artistsHorizontalVC.view)
            artistsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            artistsHorizontalVC.view.frame = cell.bounds

            self.artistsHorizontalVC = artistsHorizontalVC
            return cell
        case .Track:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(songCellReuseIdentifier, forIndexPath: indexPath) as? TrackCollectionViewCell,
                let track = group.items[indexPath.row] as? TrackMediaItem else {
                    return TrackCollectionViewCell()
            }

            if let imageURLStr = track.mediumImage, let imageURL = NSURL(string: imageURLStr) {
                cell.imageView.setImageWithAnimation(imageURL)
            }
            cell.titleLabel.text = track.album_name
            cell.subtitleLabel.text = track.artist_name
            cell.titleLabel.text = track.title
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale

            if cellsAnimated[indexPath] != true {
                animateCell(cell, indexPath: indexPath)
                cellsAnimated[indexPath] = true
            }

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func presentBrowseArtistCollectionViewController(artistMediaItem: ArtistMediaItem) {
        let browseVC = BrowseArtistCollectionViewController(artistId: artistMediaItem.id, viewModel: viewModel, textProcessor: textProcessor)
        navigationController?.pushViewController(browseVC, animated: true)
        containerViewController?.resetPosition()
    }

    func presentBrowseTrackCollectionViewController(trackMediaItem: TrackMediaItem) {
        let trackVC = BrowseTrackCollectionViewController(trackId: trackMediaItem.id, viewModel: viewModel, textProcessor: textProcessor)
        navigationController?.pushViewController(trackVC, animated: true)
        containerViewController?.resetPosition()
    }

    func provideTrendingLyricsHorizontalCollectionViewController() -> TrendingLyricsHorizontalCollectionViewController {
        if lyricsHorizontalVC == nil {
            lyricsHorizontalVC = TrendingLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC?.parentVC = self
            lyricsHorizontalVC?.textProcessor = textProcessor
            addChildViewController(lyricsHorizontalVC!)
        }
        return lyricsHorizontalVC!
    }

    func provideTrendingArtistsHorizontalCollectionViewController() -> TrendingArtistsHorizontalCollectionViewController {
        if artistsHorizontalVC == nil {
            artistsHorizontalVC = TrendingArtistsHorizontalCollectionViewController(viewModel: viewModel)
            artistsHorizontalVC?.parentVC = self
            artistsHorizontalVC?.textProcessor = textProcessor
            addChildViewController(artistsHorizontalVC!)
        }

        return artistsHorizontalVC!
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        displayedData = true
        collectionView?.reloadData()
    }
}
