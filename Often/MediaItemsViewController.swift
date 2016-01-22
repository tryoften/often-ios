//
//  MediaItemsAndFilterBarViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

public enum UserState {
    case NoTwitter
    case NoFavorites
    case NoRecents
    case NoKeyboard
    case NonEmpty
    case NoResults
}

let MediaItemsSectionHeaderViewReuseIdentifier = "MediaItemsSectionHeader"

class MediaItemsViewController: MediaItemsCollectionBaseViewController, MediaItemsViewModelDelegate {
    var viewModel: MediaItemsViewModel
    var emptyStateView: EmptyStateView?
    var loaderView: AnimatedLoaderView
    var loadingTimer: NSTimer?
    var loaderTimeoutTimer: NSTimer?
    var hasFetchedData: Bool
    var collectionType: MediaItemsCollectionType {
        didSet {
            do {
                try viewModel.fetchCollection(collectionType) { success in
                    self.reloadData(false)
                }
            } catch let error {
                print("Failed to request data \(error)")
            }
        }
    }
    var sectionHeaders: [Int: MediaItemsSectionHeaderView] = [:]


    init(collectionViewLayout: UICollectionViewLayout, collectionType aCollectionType: MediaItemsCollectionType, viewModel: MediaItemsViewModel) {
        self.viewModel = viewModel
        
        loaderView = AnimatedLoaderView()
        loaderView.hidden = true
        
        collectionType = aCollectionType
        hasFetchedData = false
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.viewModel.delegate = self
        
        view.backgroundColor = VeryLightGray
        view.layer.masksToBounds = true
        view.addSubview(loaderView)

        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.registerClass(MediaItemsSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !hasFetchedData {
            requestData(true)
            hasFetchedData = false
        } else {
            requestData(false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyStateView?.frame = view.bounds
        loaderView.frame = view.bounds
    }

    func requestData(animated: Bool = false) {
        loadingTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "loaderIfNeeded", userInfo: nil, repeats: false)

        do {
            try viewModel.fetchCollection(collectionType) { success in
                self.reloadData(animated)
            }
        } catch let error {
            print("Failed to request data \(error)")
        }
    }
    
    func reloadData(animated: Bool = false) {
        if viewModel.isDataLoaded {
            loaderView.hidden = true
            collectionView?.scrollEnabled = true
            if !(viewModel.userState == .NoTwitter || viewModel.userState == .NoKeyboard) {
                let collection = viewModel.generateMediaItemGroupsForCollectionType(collectionType)
                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: updateEmptyStateContent(.NoFavorites)
                    case .Recents: updateEmptyStateContent(.NoRecents)
                    default: break
                    }
                    emptyStateView?.hidden = false
                } else {
                    emptyStateView?.hidden = true
                    collectionView?.reloadSections(NSIndexSet(index: 0))
                }
            }
        }
    }
    
    func loaderIfNeeded() {
        if !viewModel.isDataLoaded {
            loaderView.hidden = false
            loaderTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "timeoutLoader", userInfo: nil, repeats: false)
        } else {
            collectionView?.hidden = false
        }
    }
    
    func timeoutLoader() {
        loaderView.hidden = true
        updateEmptyStateContent(.NoResults)
    }
    
    func showData(animated: Bool = false) {
        collectionView?.alpha = 0.0
        collectionView?.reloadSections(NSIndexSet(index: 0))
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: {
            self.collectionView?.alpha = 1.0
        })
        collectionView?.scrollEnabled = true
    }
    
    func updateEmptyStateContent(state: UserState) {
        viewModel.userState = state
        
        guard state != .NonEmpty else {
            emptyStateView?.removeFromSuperview()
            return
        }
        
        if let emptyStateView = emptyStateView {
            emptyStateView.removeFromSuperview()
        }
        
        emptyStateView = EmptyStateView.emptyStateViewForUserState(state)
        emptyStateView?.closeButton.addTarget(self, action: "closeButtonDidTap", forControlEvents: .TouchUpInside)
        
        if let emptyStateView = emptyStateView {
            view.addSubview(emptyStateView)
            viewDidLayoutSubviews()
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.generateMediaItemGroupsForCollectionType(collectionType).count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaItemGroupItemsForIndex(section, collectionType: collectionType).count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaItemCollectionViewCell
        cell = parseMediaItemData(viewModel.mediaItemGroupItemsForIndex(indexPath.section, collectionType: collectionType), indexPath: indexPath, collectionView: collectionView)
        cell.delegate = self
        cell.type = .NoMetadata
        
        animateCell(cell, indexPath: indexPath)
        
        if let sectionView = sectionHeaders[indexPath.section] {
            sectionView.rightText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: false, indexPath: indexPath)
        }
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: true, indexPath: indexPath)
                    sectionView.rightText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: false, indexPath: indexPath)
                    sectionHeaders[indexPath.section] = sectionView
                    return sectionView
            }
        }

        return UICollectionReusableView()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }
    
    func closeButtonDidTap() {
        viewModel.hasSeenTwitter = true
        reloadData(false)
        
        UIView.animateWithDuration(0.4, animations: {
            self.emptyStateView?.alpha = 0
        })
        
        emptyStateView?.removeFromSuperview()
        viewDidLoad()
        updateEmptyStateContent(viewModel.userState)
    }
    
    // MARK: MediaItemsViewModelDelegate
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User) {
        reloadData(false)
    }
    
    func mediaLinksViewModelDidReceiveMediaItems(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, links: [MediaItem]) {
        reloadData(false)
        loaderView.hidden = true
        collectionView?.hidden = false
    }

    func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError) {
        loaderView.hidden = true
        collectionView?.hidden = false
    }
    
    func mediaLinksViewModelDidCreateMediaItemGroups(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup]) {
        reloadData(false)
        
    }

    // MARK: MediaItemCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        FavoritesService.defaultInstance.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }
}

