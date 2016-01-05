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
class BrowseViewController: TrendingLyricsViewController, BrowseHeaderViewDelegate, SearchViewControllerDelegate {
    var headerView: BrowseHeaderView?
    var searchViewController: SearchViewController!
    var searchBar: MainAppSearchBar!

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel) {
      super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView?.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: BrowseHeadercellReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = true

        setupSearchBar()
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

    func setupSearchBar() {
        let baseURL = Firebase(url: BaseURL)

        searchViewController = SearchViewController(
            viewModel: SearchViewModel(base: baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            textProcessor: nil,
            SearchBarControllerClass: SearchBarController.self,
            SearchBarClass: MainAppSearchBar.self)
        searchViewController.delegate = self
        searchViewController.view.hidden = true
        searchViewController.searchSuggestionsViewController.contentInset = mainAppSearchSuggestionsViewControllerContentInsets
        searchViewController.searchResultsViewController.contentInset = mainAppSearchResultsCollectionViewControllerContentInsets

        guard let searchBar = searchViewController.searchBarController.searchBar as? MainAppSearchBar else {
            return
        }

        self.searchBar = searchBar

        let attributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "Montserrat", size: 11)!,
            NSForegroundColorAttributeName: BlackColor
        ]

        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .Minimal
        searchBar.backgroundColor = WhiteColor
        searchBar.tintColor = UIColor(fromHexString: "#14E09E")
        searchBar.placeholder = SearchBarPlaceholderText
        searchBar.setValue("cancel".uppercaseString, forKey:"_cancelButtonText")

        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([MainAppSearchBar.self]).setTitleTextAttributes(attributes, forState: .Normal)
        } else {
            UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
        }

        addChildViewController(searchViewController)
        view.addSubview(searchViewController.view)

        searchViewController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
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

    func browseHeaderDidLoadFeaturedArtists(BrowseHeaderView: UICollectionReusableView, artists: [MediaLink]){

    }

    func browseHeaderDidSelectFeaturedArtist(BrowseHeaderView: UICollectionReusableView, artist: MediaLink) {

    }

    func searchViewControllerSearchBarDidTextDidBeginEditing(viewController: SearchViewController, searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

        navigationController?.hidesBarsOnSwipe = false
        searchViewController.view.hidden = false

        if let cancelButton = searchBar.valueForKey("cancelButton") as? UIButton {
            if cancelButton.currentTitle == "Done".uppercaseString {
                cancelButton.setTitle("cancel".uppercaseString, forState: UIControlState.Normal)
            }
        }
    }

    func searchViewControllerSearchBarDidTapCancel(viewController: SearchViewController, searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()

        searchViewController.view.hidden = true
        searchViewController.searchBarController.searchBar.reset()
    }

    func searchViewControllerDidReceiveResponse(viewController: SearchViewController) {
        if let cancelButton = searchBar.valueForKey("cancelButton") as? UIButton {
            cancelButton.setTitle("Done".uppercaseString, forState: UIControlState.Normal)

        }

        navigationController?.hidesBarsOnSwipe = true
    }
}