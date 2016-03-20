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
class MainAppBrowseViewController: BrowseViewController, SearchViewControllerDelegate {
    private var featuredArtistHorizontalVC: FeaturedArtistViewController?
    var searchBar: MainAppSearchBar!
    var scrollsStatusBar: Bool = false
    var scrollsNavigationbar: Bool = false
    var navBarBackground: UIView
    var browseHeader: UICollectionReusableView?
    var hudTimer: NSTimer?


    override init(collectionViewLayout: UICollectionViewLayout, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        navBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 64))
        navBarBackground.backgroundColor = UIColor.whiteColor()
        super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel, textProcessor: textProcessor)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: BrowseHeadercellReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        setupSearchBar()

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .Default
            navigationBar.translucent = true
            view.insertSubview(navBarBackground, belowSubview: navigationBar)
        }
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
        self.searchBar = searchBar
        searchBar.keyboardType = .WebSearch
        
        navigationItem.titleView = searchBar

        addChildViewController(searchViewController)
        view.addSubview(searchViewController.view)

        searchViewController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    }

    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let layout = CSStickyHeaderFlowLayout()
        layout.parallaxHeaderReferenceSize = FeaturedArtistView.preferredSize
        layout.parallaxHeaderAlwaysOnTop = true
        layout.disableStickyHeaders = false
    
        return layout
    }

    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)
        hideHud()
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: BrowseHeadercellReuseIdentifier, forIndexPath: indexPath)
            let featuredArtistsHorizontalVC = provideFeaturedArtistsCollectionViewController()

            cell.backgroundColor = UIColor.clearColor()
            cell.addSubview(featuredArtistsHorizontalVC.view)
            featuredArtistsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            featuredArtistsHorizontalVC.view.frame = cell.bounds
            browseHeader = cell
            
            return cell

        }

        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView,
            let group = viewModel.groupAtIndex(indexPath.section) else {
            return UICollectionReusableView()
        }
        cell.leftText = group.title
        return cell
    }

    func searchViewControllerSearchBarDidTextDidBeginEditing(viewController: SearchViewController, searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

        if let cancelButton = searchBar.valueForKey("cancelButton") as? UIButton {
            if cancelButton.currentTitle == "done".uppercaseString {
                cancelButton.setTitle("cancel".uppercaseString, forState: UIControlState.Normal)
                cancelButton.sizeToFit()
                searchBar.sizeToFit()

            }
        }
    }

    func searchViewControllerSearchBarDidTapCancel(viewController: SearchViewController, searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()

        searchViewController?.searchBarController.searchBar.reset()
    }

    func searchViewControllerDidReceiveResponse(viewController: SearchViewController) {
    }

    func provideFeaturedArtistsCollectionViewController() -> FeaturedArtistViewController {
        if featuredArtistHorizontalVC == nil {
            featuredArtistHorizontalVC = FeaturedArtistViewController(textProcessor: textProcessor)
            addChildViewController(featuredArtistHorizontalVC!)
        }
        return featuredArtistHorizontalVC!
    }

    func showHud() {
        hudTimer?.invalidate()
        if !displayedData {
            PKHUD.sharedHUD.contentView = HUDProgressView()
            PKHUD.sharedHUD.show()
            hudTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "hideHud", userInfo: nil, repeats: false)
        }

    }

    func hideHud() {
        PKHUD.sharedHUD.hide(animated: true)
        hudTimer?.invalidate()
    }
}