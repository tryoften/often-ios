//
//  SearchResultsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let SearchResultsInsertLinkEvent = "SearchResultsCollectionViewCell.insertButton"

/// This class displays search results for a given response object
class SearchResultsCollectionViewController: MediaItemGroupsViewController,
    MessageBarDelegate, SearchViewModelDelegate, UISearchBarDelegate {
    weak var searchBarController: SearchBarController?
    var browseViewModel: BrowseViewModel?
    weak var searchViewController: SearchViewController?
    var searchViewModel: SearchViewModel
    var response: SearchResponse? {
        didSet {
            if let response = response {
                browseViewModel = BrowseViewModel(path: "responses/\(response.id)/results")
            }

            refreshTimer?.invalidate()
        }

        willSet(newValue) {
            if let response = response {
                oldResponse = response
            }
        }
    }
    
    // object the current response needs to be replaced/updated with, (use only if refresh button should be shown)
    var nextResponse: SearchResponse?
    private var noResultsTimer: NSTimer?
    private var searchResultNavigationBar: SearchResultNavigationBar
    private var refreshResultsButton: RefreshResultsButton?
    private var refreshResultsButtonTopConstraint: NSLayoutConstraint!
    private var refreshTimer: NSTimer?
    private var messageBarView: MessageBarView
    private var messageBarVisibleConstraint: NSLayoutConstraint?
    private var oldResponse: SearchResponse?

    var contentInset: UIEdgeInsets {
        didSet {
            collectionView?.contentInset = contentInset
        }
    }

    var isFullAccessEnabled: Bool {
        let pbWrapped: UIPasteboard? = UIPasteboard.generalPasteboard()
        if let _ = pbWrapped {
            return true
        } else {
            return false
        }
    }

    init(collectionViewLayout layout: UICollectionViewLayout = SearchResultsCollectionViewController.provideCollectionViewFlowLayout(),
        textProcessor: TextProcessingManager?, query: String, searchType: SearchRequestType = .Search) {
    #if KEYBOARD
        contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight, 0, 0, 0)
        searchResultNavigationBar = KeyboardSearchResultNavgationBar()
    #else
        contentInset = UIEdgeInsetsMake(64, 0, 40, 0)
        searchResultNavigationBar = MainAppSearchResultNavigationBar()
    #endif
        searchResultNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        searchResultNavigationBar.titleLabel.text = query

        messageBarView = MessageBarView()
        searchViewModel = SearchViewModel(base: Firebase(url: BaseURL))


        super.init(collectionViewLayout: layout, viewModel:  BrowseViewModel(), textProcessor: textProcessor)

        searchResultNavigationBar.doneButton.addTarget(self, action: "didTapDoneButton:", forControlEvents: .TouchUpInside)

        self.textProcessor = textProcessor

        
        view.layer.masksToBounds = true
        view.addSubview(messageBarView)
        view.addSubview(searchResultNavigationBar)

        messageBarView.delegate = self
        searchViewModel.delegate = self
        collectionView?.contentInset = contentInset
        
        setupLayout()

        searchViewModel.sendRequestForQuery(query, type: searchType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoadingView()
        noResultsTimer?.invalidate()
        noResultsTimer = NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: "showEmptyStateView", userInfo: nil, repeats: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if isFullAccessEnabled {
            hideMessageBar()
        } else {
            showMessageBar()
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.hidden = true
    }

    override func viewWillDisappear(animated: Bool) {
         navigationController?.navigationBar.hidden = false
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        return layout
    }

    func showRefreshResultsButtonIfNeeded() {
        if let refreshButton = refreshResultsButton {
            refreshButton.removeFromSuperview()
        }

        refreshResultsButton = RefreshResultsButton()
        refreshResultsButton!.translatesAutoresizingMaskIntoConstraints = false
        refreshResultsButton!.addTarget(self, action: "didTapRefreshResultsButton", forControlEvents: .TouchUpInside)
        view.addSubview(refreshResultsButton!)

        if let refreshResultsButton = refreshResultsButton {
            refreshResultsButtonTopConstraint = refreshResultsButton.al_top == view.al_top - 40

            view.addConstraints([
                refreshResultsButton.al_height == 30,
                refreshResultsButton.al_centerX == view.al_centerX,
                refreshResultsButtonTopConstraint
            ])

        }

        refreshTimer = NSTimer(
            timeInterval: NSTimeInterval(3.0),
            target: self,
            selector: "displayRefreshResultsButton",
            userInfo: nil,
            repeats: false)
    }

    func displayRefreshResultsButton() {
        refreshResultsButtonTopConstraint.constant = 20
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .CurveEaseIn,
            animations: {
                self.refreshResultsButton?.layoutIfNeeded()
            }, completion: nil)
    }

    func didTapDoneButton(sender: UIButton) {
        noResultsTimer?.invalidate()

        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: nil)
        navigationController?.popViewControllerAnimated(false)
    }

    func didTapRefreshResultsButton() {
        response = nextResponse
        refreshResultsButtonTopConstraint.constant = -40

        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .CurveEaseIn,
            animations: {
                self.refreshResultsButton?.layoutIfNeeded()
            }, completion: nil)

        refreshResults()
    }

    func didTapEmptyStateView() {
        response = oldResponse

        showLoadingView()
        noResultsTimer?.invalidate()
        noResultsTimer = NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: "showEmptyStateView", userInfo: nil, repeats: false)
    }

    internal override func groupAtIndex(section: Int) -> MediaItemGroup? {
        if let group = response?.groups[section] where section < response?.groups.count {
            return group
        }
        return nil
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let response = response {
            return response.groups.count
        }
        return 0
    }

    func refreshResults() {
        cellsAnimated = [:]
        
        guard let collectionView = collectionView, let response = response else {
            return
        }

        collectionView.reloadData()

        hideLoadingView()
        if !response.groups.isEmpty {
            hideEmptyStateView()
        } else {
            showEmptyStateViewForState(.NoResults)
        }

    #if KEYBOARD
        let yOffset = containerViewController?.tabBar == nil ? 0 : -2 * KeyboardSearchBarHeight + 2
        collectionView.setContentOffset(CGPointMake(0, yOffset), animated: false)
    #endif
    }
    
    func setupLayout() {
        var searchResultNavigationBarHeight: CGFloat = 64
        var searchResultNavigationBarTopPadding: CGFloat = 0
        #if KEYBOARD
            searchResultNavigationBarTopPadding = KeyboardSearchBarHeight
            searchResultNavigationBarHeight = KeyboardSearchBarHeight
        #endif

        messageBarVisibleConstraint = messageBarView.al_bottom == view.al_top
        
        view.addConstraints([
            searchResultNavigationBar.al_left == view.al_left,
            searchResultNavigationBar.al_right == view.al_right,
            searchResultNavigationBar.al_top == view.al_top + searchResultNavigationBarTopPadding,
            searchResultNavigationBar.al_height == searchResultNavigationBarHeight,


            messageBarView.al_left == view.al_left,
            messageBarView.al_right == view.al_right,
            messageBarVisibleConstraint!,
            messageBarView.al_height == 39
        ])
    }


    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        refreshResults()
    }
    
    // MediaItemCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }

        FavoritesService.defaultInstance.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }

    // MARK: MessageBarViewDelegate
    func showMessageBar() {
        messageBarVisibleConstraint?.constant = 39
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideMessageBar() {
        messageBarVisibleConstraint?.constant = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: EmptySetDelegate
    func updateEmptyStateContent(state: UserState, animated: Bool) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
        }
        
        super.showEmptyStateViewForState(state, completion: { emptyStateView in
                self.view.insertSubview(emptyStateView, belowSubview: self.searchResultNavigationBar)
                emptyStateView.primaryButton.addTarget(self, action: "didTapEmptyStateView", forControlEvents: .TouchUpInside)

        })
        
        if animated {
            UIView.commitAnimations()
        }
    }

    func showEmptyStateView() {
        updateEmptyStateContent(.NoResults, animated: true)
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = containerViewController,
            let searchBarController = searchBarController else {
            return
        }

        var frame = tabBarFrame
        var searchBarFrame = searchBarController.view.frame
        let tabBarHeight = CGRectGetHeight(frame)

        searchBarFrame.origin.y =  fmax(fmin(KeyboardSearchBarHeight + y, KeyboardSearchBarHeight), 0)
        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight)

        UIView.animateWithDuration(animated ? 0.1 : 0) {
            self.searchBarController?.view.frame = searchBarFrame
            containerViewController.tabBar.frame = frame
        }
    }

    // MARK: SearchViewModelDelegate
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool) {
        // TODO(luc): don't do anything if the keyboard is restored
        if response.groups.isEmpty {
            return
        }

        noResultsTimer?.invalidate()

        self.response = response
        refreshResults()
    }
}

