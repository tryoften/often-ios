//
//  BrowseViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

private let BrowseHeadercellReuseIdentifier = "browseHeaderCell"

/**
    This view controller displays a search bar along with trending navigatable items (lyrics, songs, artists)
*/
class BrowseViewController: TrendingLyricsViewController, BrowseHeaderViewDelegate {
    var headerView: BrowseHeaderView?
    var searchController: UISearchController!

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel) {
      super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView?.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: BrowseHeadercellReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = true

        let baseURL = Firebase(url: BaseURL)
        let suggestionsViewModel = SearchSuggestionsViewModel(base: baseURL)
        let searchSuggestionsViewController = SearchSuggestionsViewController(viewModel: suggestionsViewModel)

        searchController = UISearchController(searchResultsController: searchSuggestionsViewController)
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.titleView = searchController.searchBar
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.translucent = false
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
            cell.leftText = "Top Artists"
        case .TrendingSongs:
            cell.leftText = "Top Songs"
        }

        return cell

    }

    func browseHeaderDidLoadFeaturedArtists(BrowseHeaderView: UICollectionReusableView, artists: [MediaLink]) {
        
    }

    func browseHeaderDidSelectFeaturedArtist(BrowseHeaderView: UICollectionReusableView, artist: MediaLink) {

    }
}