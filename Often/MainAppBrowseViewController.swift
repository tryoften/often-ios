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
    var headerView: BrowseHeaderView?
    var searchBar: MainAppSearchBar!
    var scrollsStatusBar: Bool = false
    var scrollsNavigationbar: Bool = false
    var navBarBackground: UIView

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        navBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 64))
        navBarBackground.backgroundColor = UIColor.whiteColor()
        super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel, textProcessor: textProcessor)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView?.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: BrowseHeadercellReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        setupSearchBar()

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
        if let cancelButton = searchBar.valueForKey("cancelButton") as? UIButton {
            cancelButton.setTitle("done".uppercaseString, forState: UIControlState.Normal)
        }
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        if !scrollsNavigationbar {
            return
        }

        super.setNavigationBarOriginY(y, animated: animated)

        guard let navigationController = navigationController as? ContainerNavigationController,
            let collectionView = collectionView else {
                return
        }

        let frame = navigationController.navigationBar.frame
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let bottomLimit = CGFloat(20.0)
        let baseY = frame.origin.y + frame.size.height
        let topLimit = CGRectGetHeight(frame) + statusBarHeight
        let boundedY = fmin(fmax(baseY, bottomLimit), topLimit)
        let contentOffset = collectionView.contentOffset

        func setStatusBarYOffset(statusBarY: CGFloat) {
            if let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow") as? UIWindow {
                var statusBarFrame = statusBar.frame
                statusBarFrame.origin.y = fmin(fmax(0, y), 20) - statusBarHeight
                statusBar.frame = statusBarFrame
            }
        }

        var contentInset = collectionView.contentInset
        contentInset.top = boundedY

        if contentOffset.y > bottomLimit || contentOffset.y < -topLimit {
            collectionView.contentInset = contentInset
            if scrollsStatusBar {
                setStatusBarYOffset(0)
            }
            return
        }

        UIView.animateWithDuration(0.2) {
            collectionView.contentInset = contentInset
            collectionView.contentOffset = contentOffset
            if self.scrollsStatusBar {
                setStatusBarYOffset(y)
            }
        }
    }
}