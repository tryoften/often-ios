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

class MediaItemsAndFilterBarViewController: MediaItemsCollectionBaseViewController, MediaItemsViewModelDelegate {
    var viewModel: MediaItemsViewModel
    var emptyStateView: EmptyStateView?
    var loaderView: AnimatedLoaderView
    var loadingTimer: NSTimer?
    var loaderTimeoutTimer: NSTimer?
    var userState: UserState
    var collectionType: MediaItemsCollectionType {
        didSet {
            do {
                try viewModel.fetchCollection(collectionType) { success in
                    self.reloadData()
                }
            } catch let error {
                print("Failed to request data \(error)")
            }
        }
    }


    init(collectionViewLayout: UICollectionViewLayout, collectionType aCollectionType: MediaItemsCollectionType, viewModel: MediaItemsViewModel) {
        self.viewModel = viewModel
        
        loaderView = AnimatedLoaderView()
        loaderView.hidden = true

        collectionType = aCollectionType

        userState = .NonEmpty
        
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
        
        loadingTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showLoader", userInfo: nil, repeats: false)
        
        do {
            try viewModel.fetchCollection(collectionType) { success in
                self.reloadData()
            }
        } catch let error {
            print("Failed to request data \(error)")
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        loadingTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showLoader", userInfo: nil, repeats: false)
        
        do {
            try viewModel.fetchCollection(collectionType) { success in
                self.reloadData()
            }
        } catch let error {
            print("Failed to request data \(error)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyStateView?.frame = view.bounds
        loaderView.frame = view.bounds
    }
    
    func reloadData() {
        if viewModel.isDataLoaded {
            loaderView.hidden = true
            collectionView?.scrollEnabled = true
            if !(userState == .NoTwitter || userState == .NoKeyboard) {
                let collection = viewModel.filteredMediaItemsForCollectionType(collectionType)

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
    
    func showLoader() {
        if !viewModel.isDataLoaded {
//            loaderView.hidden = false
//            loaderTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "timeoutLoader", userInfo: nil, repeats: false)

        }
    }
    
    func timeoutLoader() {
        loaderView.hidden = true
    }
    
    func fadeInData() {
        collectionView?.alpha = 0.0
        collectionView?.layer.transform = CATransform3DMakeScale(0.90, 0.90, 0.90)
        
        collectionView?.reloadSections(NSIndexSet(index: 0))
        
        UIView.animateWithDuration(0.3, animations: {
            self.collectionView?.alpha = 1.0
            self.collectionView?.layer.transform = CATransform3DIdentity
        })
        collectionView?.scrollEnabled = true
    }
    
    func updateEmptyStateContent(state: UserState) {
        userState = state
        
        guard state != .NonEmpty else {
            emptyStateView?.removeFromSuperview()
            return
        }
        
        if let emptyStateView = emptyStateView {
            emptyStateView.removeFromSuperview()
        }
        
        emptyStateView = EmptyStateView.emptyStateViewForUserState(state)
        
        if let emptyStateView = emptyStateView {
            view.addSubview(emptyStateView)
            viewDidLayoutSubviews()
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMediaItemsForCollectionType(collectionType).count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaItemCollectionViewCell
        cell = parseMediaItemData(viewModel.filteredMediaItemsForCollectionType(collectionType), indexPath: indexPath, collectionView: collectionView)
        cell.delegate = self
        
        if let result = cell.mediaLink {
            if  viewModel.checkFavorite(result) {
                cell.itemFavorited = true
            } else {
                cell.itemFavorited = false
            }
        }
        
        animateCell(cell, indexPath: indexPath)
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaItemCollectionViewCell,
            let cells = collectionView.visibleCells() as? [MediaItemCollectionViewCell],
            let result = cell.mediaLink else {
                return
        }
        
        for cell in cells {
            cell.overlayVisible = false
            cell.layer.shouldRasterize = false
        }
        
        if  viewModel.checkFavorite(result) {
            cell.itemFavorited = true
        } else {
            cell.itemFavorited = false
        }
        cell.prepareOverlayView()
        cell.overlayVisible = true
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType)
                    return sectionView
            }
        }

        return UICollectionReusableView()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }
    
    // MARK: MediaItemsViewModelDelegate
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User) {
        reloadData()
    }
    
    func mediaLinksViewModelDidReceiveMediaItems(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, links: [MediaItem]) {
        reloadData()
        loaderView.hidden = true
    }

    // MARK: MediaItemCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        viewModel.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }
}

