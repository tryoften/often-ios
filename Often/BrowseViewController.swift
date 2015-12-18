//
//  BrowseViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

private let BrowseHeadercellReuseIdentifier = "browseHeaderCell"

class BrowseViewController: TrendingLyricsViewController, BrowseHeaderViewDelegate {
    var headerView: BrowseHeaderView?
    var searchBar: SearchBarController?

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel) {
      super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel)

        self.collectionView?.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: BrowseHeadercellReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let layout = CSStickyHeaderFlowLayout()
        layout.parallaxHeaderReferenceSize = BrowseHeaderView.preferredSize
        layout.parallaxHeaderAlwaysOnTop = true
        layout.disableStickyHeaders = false
    
        return layout
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
                        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                            withReuseIdentifier: BrowseHeadercellReuseIdentifier, forIndexPath: indexPath) as? BrowseHeaderView else {
                                return UICollectionReusableView()
                        }
            
                        if headerView == nil {
                            headerView = cell
                            headerView?.delegate = self
                                        
                        }
            
                        return headerView!
                    }

        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaLinksSectionHeaderView, let section = TrendingLyricsSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        switch section {
        case .TrendingLyrics:
            cell.leftText = "Trending Lyrics"
        case .TrendingArtists:
            cell.leftText = "Trending Artists"
        case .TrendingSongs:
            cell.leftText = "Trending Songs"
        }

        return cell

    }

    func browseHeaderDidLoadFeaturedArtists(BrowseHeaderView: UICollectionReusableView, artists: [MediaLink]) {
        
    }

    func browseHeaderFeaturedArtistWasSelected(BrowseHeaderView: UICollectionReusableView, artist: MediaLink) {

    }
    
}