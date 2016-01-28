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
class SearchResultsCollectionViewController: MediaItemGroupsViewController, MessageBarDelegate {
    weak var searchBarController: SearchBarController?
    weak var searchViewController: SearchViewController?
    var browseViewModel: BrowseViewModel?
    var response: SearchResponse? {
        didSet {
            if let response = response {
                browseViewModel = BrowseViewModel(path: "responses/\(response.id)/results")
            }
            hideLoadingView()
            hideEmptyStateView()

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
        textProcessor: TextProcessingManager?) {
    #if KEYBOARD
        contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight, 0, 0, 0)
    #else
        contentInset = UIEdgeInsetsMake(68, 0, 40, 0)
    #endif
        messageBarView = MessageBarView()
        
        super.init(collectionViewLayout: layout, viewModel: BrowseViewModel(), textProcessor: textProcessor)
        self.textProcessor = textProcessor
        
        view.layer.masksToBounds = true
        view.addSubview(messageBarView)

        messageBarView.delegate = self
        collectionView?.contentInset = contentInset
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if isFullAccessEnabled {
            hideMessageBar()
        } else {
            showMessageBar()
        }
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
        
//        if !displayedData {
//            collectionView.reloadData()
//            displayedData = true
//        } else {
//            collectionView.performBatchUpdates({
//                if let oldResponse = self.oldResponse {
//                    let oldRange = NSMakeRange(0, oldResponse.groups.count)
//                    collectionView.deleteSections(NSIndexSet(indexesInRange: oldRange))
//                }
//
//                let range = NSMakeRange(0, response.groups.count)
//                collectionView.insertSections(NSIndexSet(indexesInRange: range))
//            }, completion: nil)
//
//        }
        collectionView.reloadData()

    #if KEYBOARD
        let yOffset = containerViewController?.tabBar == nil ? 0 : -2 * KeyboardSearchBarHeight + 2
        collectionView.setContentOffset(CGPointMake(0, yOffset), animated: false)
    #endif
    }
    
    func setupLayout() {
        messageBarVisibleConstraint = messageBarView.al_bottom == view.al_top
        
        view.addConstraints([
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
            if let searchViewController = self.searchViewController {
                emptyStateView.primaryButton.addTarget(searchViewController, action: "didTapEmptyStateView", forControlEvents: .TouchUpInside)
            }
        })
        
        if animated {
            UIView.commitAnimations()
        }
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
}

