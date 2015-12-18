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
let sectionHeaderReuseIdentifier = "sectionHeader"

class TrendingLyricsViewController: FullScreenCollectionViewController, UICollectionViewDelegateFlowLayout {

    var lyricsHorizontalVC: TrendingLyricsHorizontalCollectionViewController?
    var artistsHorizontalVC: TrendingArtistsHorizontalCollectionViewController?
    var viewModel: TrendingLyricsViewModel

    init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: collectionViewLayout)

        collectionView?.backgroundColor = VeryLightGray
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + 2, 0, 0, 0)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.registerClass(MediaLinkCollectionViewCell.self, forCellWithReuseIdentifier: songCellReuseIdentifier)
        collectionView?.registerClass(MediaLinksSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = TrendingLyricsSection(rawValue: section) else {
            return 0
        }

        switch section {
        case .TrendingLyrics:
            return 1
        case .TrendingArtists:
            return 1
        case .TrendingSongs:
            return 5
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaLinksSectionHeaderView, let section = TrendingLyricsSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        switch section {
        case .TrendingLyrics:
            cell.topSeperator.hidden = true
            cell.leftText = "Trending Lyrics"
        case .TrendingArtists:
            cell.topSeperator.hidden = false
            cell.leftText = "Trending Artists"
        case .TrendingSongs:
            cell.topSeperator.hidden = false
            cell.leftText = "Trending Songs"
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let baseSize = CGSizeMake(screenWidth, 115)

        guard let section = TrendingLyricsSection(rawValue: indexPath.section) else {
            return baseSize
        }

        switch section {
        case .TrendingLyrics:
            return CGSizeMake(screenWidth, 125)
        case .TrendingArtists:
            return CGSizeMake(screenWidth, 230)
        case .TrendingSongs:
            return CGSizeMake(screenWidth - 20, 115)
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
        guard let section = TrendingLyricsSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .TrendingLyrics:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let lyricsHorizontalVC = provideTrendingLyricsHorizontalCollectionViewController()

            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.frame = cell.bounds

            self.lyricsHorizontalVC = lyricsHorizontalVC
            return cell
        case .TrendingArtists:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let artistsHorizontalVC = provideTrendingArtistsHorizontalCollectionViewController()

            cell.contentView.addSubview(artistsHorizontalVC.view)
            artistsHorizontalVC.view.frame = cell.bounds

            self.artistsHorizontalVC = artistsHorizontalVC
            return cell
        case .TrendingSongs:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(songCellReuseIdentifier, forIndexPath: indexPath) as? MediaLinkCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.reset()
            cell.sourceLogoView.image = UIImage(named: "genius")
            cell.mainTextLabel.text = "3500"
            cell.leftHeaderLabel.text = "Travis Scott ft 2 Chainz & Future"
            cell.leftMetadataLabel.text = "Single"
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            return cell
        }
    }

    func provideTrendingLyricsHorizontalCollectionViewController() -> TrendingLyricsHorizontalCollectionViewController {
        return TrendingLyricsHorizontalCollectionViewController()
    }

    func provideTrendingArtistsHorizontalCollectionViewController() -> TrendingArtistsHorizontalCollectionViewController {
        return TrendingArtistsHorizontalCollectionViewController()
    }
}