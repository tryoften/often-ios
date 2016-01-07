//
//  SearchResultsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let SearchResultsInsertLinkEvent = "SearchResultsCollectionViewCell.insertButton"

/**
 SearchResultsCollectionViewController

 Collection view that can display any type of service provider cell because they are all
 the same size.

 Types of providers:

 Song Cell
 Video Cell
 Article Cell
 Tweet Cell

 */
class SearchResultsCollectionViewController: MediaLinksCollectionBaseViewController, UICollectionViewDelegateFlowLayout, MessageBarDelegate {
    var backgroundImageView: UIImageView
    var textProcessor: TextProcessingManager?
    var searchBarController: SearchBarController?
    var response: SearchResponse? {
        didSet {
            refreshTimer?.invalidate()
            emptyStateView.alpha = 0.0
        }
    }
    
    // object the current response needs to be replaced/updated with
    var nextResponse: SearchResponse?
    var viewModel: SearchResultsViewModel?
    var refreshResultsButton: RefreshResultsButton
    var refreshResultsButtonTopConstraint: NSLayoutConstraint!
    var refreshTimer: NSTimer?
    var emptyStateView: EmptyStateView
    var messageBarView: MessageBarView
    var messageBarVisibleConstraint: NSLayoutConstraint?
    var isFullAccessEnabled: Bool

    var contentInset: UIEdgeInsets {
        didSet {
            collectionView?.contentInset = contentInset
        }
    }

    init(collectionViewLayout layout: UICollectionViewLayout, textProcessor: TextProcessingManager?) {
        contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight + 2, 0, 0, 0)

        backgroundImageView = UIImageView(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .Center
        backgroundImageView.contentScaleFactor = 2.5
        
        viewModel = SearchResultsViewModel()
        
        refreshResultsButton = RefreshResultsButton()
        refreshResultsButton.translatesAutoresizingMaskIntoConstraints = false
        
        messageBarView = MessageBarView()
        
        isFullAccessEnabled = false
        
        emptyStateView = EmptyStateView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.alpha = 0.0
        
        self.textProcessor = textProcessor
        
        super.init(collectionViewLayout: layout)
        
        emptyStateView.primaryButton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
        emptyStateView.closeButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        emptyStateView.userInteractionEnabled = true
        
        view.layer.masksToBounds = true
        view.insertSubview(backgroundImageView, belowSubview: collectionView!)
        view.addSubview(refreshResultsButton)
        view.backgroundColor = VeryLightGray
        view.addSubview(messageBarView)
        view.addSubview(emptyStateView)

        messageBarView.delegate = self
        refreshResultsButton.addTarget(self, action: "didTapRefreshResultsButton", forControlEvents: .TouchUpInside)
        
        // Register cell classes
        if let collectionView = collectionView {
            collectionView.registerClass(MediaLinkCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
             collectionView.contentInset = contentInset
        }
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textProcessor: TextProcessingManager?) {
        self.init(collectionViewLayout: SearchResultsCollectionViewController.provideCollectionViewFlowLayout(), textProcessor: textProcessor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let pbWrapped: UIPasteboard? = UIPasteboard.generalPasteboard()
        if let _ = pbWrapped {
            let _ = viewModel?.isFullAccessEnabled
            hideMessageBar()
        } else {
            showMessageBar()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyStateView.frame = view.bounds
    }
    
    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 40.0, right: 10.0)
        return layout
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let response = response {
            return response.results.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = CGRectGetWidth(view.frame) - 20
        if let result = response?.results[indexPath.row] {
            switch (result.type) {
            case .Track:
                return CGSizeMake(width, 105)
            default:
                break
            }
        }
        
        return CGSizeMake(width, 105)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = parseMediaLinkData(response?.results, indexPath: indexPath, collectionView: collectionView)
        cell.delegate = self
        
        if let result = cell.mediaLink {
            if let favorited = viewModel?.checkFavorite(result) {
                cell.itemFavorited = favorited
            } else {
                cell.itemFavorited = false
            }
        }
        
        animateCell(cell, indexPath: indexPath)
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaLinkCollectionViewCell,
            let cells = collectionView.visibleCells() as? [MediaLinkCollectionViewCell],
            let result = response?.results[indexPath.row] else {
            return
        }
        
        cell.layer.shouldRasterize = false
        
        for cell in cells {
            cell.overlayVisible = false
            cell.layer.shouldRasterize = false
        }
        
        if let favorited = viewModel?.checkFavorite(result) {
            cell.itemFavorited = favorited
        } else {
            cell.itemFavorited = false
        }
        
        cell.prepareOverlayView()
        cell.overlayVisible = true
    }
    
    func refreshResults() {
        cellsAnimated = [:]
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.reloadData()

        let yOffset = containerViewController?.tabBar == nil ? 0 : -2 * KeyboardSearchBarHeight + 2
        collectionView.setContentOffset(CGPointMake(0, yOffset), animated: false)

        backgroundImageView.hidden = (response != nil && !response!.results.isEmpty)
    }
    
    func showRefreshResultsButton() {
        refreshTimer = NSTimer(timeInterval: NSTimeInterval(3.0), target: self, selector: "displayRefreshResultsButton", userInfo: nil, repeats: false)
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
                self.refreshResultsButton.layoutIfNeeded()
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
                self.refreshResultsButton.layoutIfNeeded()
            }, completion: nil)

        refreshResults()
    }
    
    func setupLayout() {
        refreshResultsButtonTopConstraint = refreshResultsButton.al_top == view.al_top - 40
        
        view.addConstraints([
            backgroundImageView.al_top == view.al_top,
            backgroundImageView.al_left == view.al_left,
            backgroundImageView.al_width == view.al_width,
            backgroundImageView.al_height == view.al_height - 30,
            
            refreshResultsButton.al_height == 30,
            refreshResultsButton.al_centerX == view.al_centerX,
            refreshResultsButtonTopConstraint
        ])

        
        messageBarVisibleConstraint = messageBarView.al_bottom == view.al_top
        
        view.addConstraints([
            messageBarView.al_left == view.al_left,
            messageBarView.al_right == view.al_right,
            messageBarVisibleConstraint!,
            messageBarView.al_height == 39,
            
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_height == 100,
            emptyStateView.al_top == view.al_top
        ])
    }
    
    // MediaLinkCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        viewModel?.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }
    
    override func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }

        if selected {
            self.textProcessor?.defaultProxy.insertText(result.getInsertableText())
            NSNotificationCenter.defaultCenter().postNotificationName(SearchResultsInsertLinkEvent, object: cell.mediaLink)
        } else {
            for var i = 0, len = result.getInsertableText().utf16.count; i < len; i++ {
                textProcessor?.defaultProxy.deleteBackward()
            }
        }
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
    func updateEmptySetVisible(visible: Bool, animated: Bool = false) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
        }
        
        if visible {
            emptyStateView.removeFromSuperview()
            
            if let newEmptyState = EmptyStateView.emptyStateViewForUserState(.NoResults) {
                emptyStateView = newEmptyState
            }
            
            view.addSubview(emptyStateView)
            viewDidLayoutSubviews() 
            emptyStateView.alpha = 1.0
        } else {
            self.emptyStateView.alpha = 0.0
        }
        
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

