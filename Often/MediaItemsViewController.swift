//
//  MediaItemsViewController.swift
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

    var hasFetchedData: Bool
    var collectionType: MediaItemsCollectionType {
        didSet {
            do {
                sectionHeaders = [:]
                try viewModel.fetchCollection(collectionType) { success in
                    self.reloadData(false, collectionTypeChanged: true)
                }
            } catch let error {
                print("Failed to request data \(error)")
            }
        }
    }
    var sectionHeaders: [Int: MediaItemsSectionHeaderView] = [:]
    override var isDataLoaded: Bool {
        return viewModel.isDataLoaded
    }

    init(collectionViewLayout: UICollectionViewLayout, collectionType aCollectionType: MediaItemsCollectionType, viewModel: MediaItemsViewModel) {
        self.viewModel = viewModel
        
        collectionType = aCollectionType
        hasFetchedData = false
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.viewModel.delegate = self
        
        view.backgroundColor = VeryLightGray
        view.layer.masksToBounds = true
        
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

    override func requestData(animated: Bool = false) {
        super.requestData(animated)

        do {
            try viewModel.fetchCollection(collectionType) { success in
                self.reloadData(animated)
            }
        } catch let error {
            print("Failed to request data \(error)")
        }
    }
    
    func reloadData(animated: Bool = false, collectionTypeChanged: Bool = false) {
        if viewModel.isDataLoaded {
            loaderView?.hidden = true
            collectionView?.scrollEnabled = true
            if !(viewModel.userState == .NoTwitter || viewModel.userState == .NoKeyboard) {
                let collection = viewModel.generateMediaItemGroupsForCollectionType(collectionType)
                
                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: showEmptyStateViewForState(.NoFavorites)
                    case .Recents: showEmptyStateViewForState(.NoRecents)
                    default: break
                    }
                    emptyStateView?.hidden = false
                } else {
                    emptyStateView?.hidden = true
                    collectionView?.reloadData()
                }
            } else {
                collectionView?.scrollEnabled = false
            }
        }
    }

    func showData(animated: Bool = false) {
        collectionView?.alpha = 0.0
        collectionView?.reloadSections(NSIndexSet(index: 0))
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: {
            self.collectionView?.alpha = 1.0
        })
        collectionView?.scrollEnabled = true
    }

    override func didTapEmptyStateViewCloseButton() {
        super.didTapEmptyStateViewCloseButton()
        viewModel.hasSeenTwitter = true
        reloadData(false)
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
        
        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    
                    sectionView.artistImage = nil

                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: true, indexPath: indexPath)
                    if collectionType == .Recents {
                        sectionView.rightText = ""
                    } else {
                        sectionView.rightText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: false, indexPath: indexPath)
                    }
                    sectionHeaders[indexPath.section] = sectionView
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
        reloadData(false)
    }
    
    func mediaLinksViewModelDidReceiveMediaItems(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, links: [MediaItem]) {
        reloadData(false)
        loaderView?.hidden = true
        collectionView?.hidden = false
    }
    
    func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError) {
        loaderView?.hidden = true
        collectionView?.hidden = false
    }
    
    func mediaLinksViewModelDidCreateMediaItemGroups(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup]) {
        reloadData(false, collectionTypeChanged: true)
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

