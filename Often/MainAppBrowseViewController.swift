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
class MainAppBrowseViewController: BrowseViewController, BrowseHeaderViewDelegate, SearchViewControllerDelegate {
    var headerView: BrowseHeaderView?
    var searchBar: MainAppSearchBar!

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel, textProcessor: TextProcessingManager?) {
      super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel, textProcessor: textProcessor)
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
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.translucent = false
    }

    override func setupSearchBar() {
        let baseURL = Firebase(url: BaseURL)

        searchViewController = SearchViewController(
            viewModel: SearchViewModel(base: baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            textProcessor: nil,
            SearchBarControllerClass: SearchBarController.self,
            SearchBarClass: MainAppSearchBar.self)

        guard let searchViewController = searchViewController, searchBar = searchViewController.searchBarController.searchBar as? MainAppSearchBar else {
            return
        }

        searchViewController.delegate = self
        searchViewController.searchSuggestionsViewController.contentInset = mainAppSearchSuggestionsViewControllerContentInsets
        searchViewController.searchResultsViewController.contentInset = mainAppSearchResultsCollectionViewControllerContentInsets

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

        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView,
            let group = viewModel.groupAtIndex(indexPath.section) else {
            return UICollectionReusableView()
        }

        cell.leftText = group.title

        return cell

    }

    func browseHeaderDidLoadFeaturedArtists(BrowseHeaderView: UICollectionReusableView, artists: [MediaItem]){

    }

    func browseHeaderDidSelectFeaturedArtist(BrowseHeaderView: UICollectionReusableView, artist: MediaItem) {

    }

    func searchViewControllerSearchBarDidTextDidBeginEditing(viewController: SearchViewController, searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

        navigationController?.hidesBarsOnSwipe = false

        if let cancelButton = searchBar.valueForKey("cancelButton") as? UIButton {
            if cancelButton.currentTitle == "done".uppercaseString {
                cancelButton.setTitle("cancel".uppercaseString, forState: UIControlState.Normal)
                cancelButton.sizeToFit()
                searchBar.sizeToFit()

            }
        }
    }

    func searchViewControllerSearchBarDidTapCancel(viewController: SearchViewController, searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()

        searchViewController?.searchBarController.searchBar.reset()
    }

    func searchViewControllerDidReceiveResponse(viewController: SearchViewController) {
        if let cancelButton = searchBar.valueForKey("cancelButton") as? UIButton {
            cancelButton.setTitle("done".uppercaseString, forState: UIControlState.Normal)

        }

        navigationController?.hidesBarsOnSwipe = true
    }
}