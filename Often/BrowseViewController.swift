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

    var navigationBarFrame: CGRect {
        guard let containerViewController = mainAppContainerViewController else {
            return CGRectZero
        }

        return containerViewController.navigationBar.frame
    }

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel) {
      super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView?.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: BrowseHeadercellReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaLinksSectionHeaderView,
            let section = TrendingLyricsSection(rawValue: indexPath.section) else {
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

    func browseHeaderDidSelectFeaturedArtist(BrowseHeaderView: UICollectionReusableView, artist: MediaLink) {

    }

    override func showNavigationBar(animated: Bool) {
        setNavigationBarOriginY(0, animated: true)
    }

    override func hideNavigationBar(animated: Bool) {
        let top = -CGRectGetHeight(navigationBarFrame)
        setNavigationBarOriginY(top, animated: true)
    }

    override func moveNavigationBar(deltaY: CGFloat, animated: Bool) {
        let frame = navigationBarFrame
        let nextY = frame.origin.y + deltaY

        setNavigationBarOriginY(nextY, animated: animated)
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = mainAppContainerViewController else {
            return
        }

        var frame = navigationBarFrame
        let tabBarHeight = CGRectGetHeight(frame) + 20.0

        frame.origin.y = fmax(fmin(y, 20), -tabBarHeight + 2)

        UIView.animateWithDuration(animated ? 0.1 : 0) {
            containerViewController.navigationBar.frame = frame
        }
    }

    
    
}