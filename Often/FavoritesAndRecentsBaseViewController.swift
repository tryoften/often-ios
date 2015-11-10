//
//  FavoritesAndRecentsBaseViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class FavoritesAndRecentsBaseViewController: MediaLinksCollectionBaseViewController,
    UserProfileViewModelDelegate,
    FilterTabDelegate,
    FavoritesAndRecentsTabDelegate {
    var sectionHeaderView: UserProfileSectionHeaderView?
    var contentFilterTabView: MediaFilterTabView
    var viewModel: MediaLinksViewModel
    var emptyStateView: EmptySetView
    
    init(collectionViewLayout: UICollectionViewLayout, viewModel: MediaLinksViewModel ) {
        self.viewModel = viewModel
        
        contentFilterTabView = MediaFilterTabView(filterMap: DefaultFilterMap)
        contentFilterTabView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView = EmptySetView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.hidden = true
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.viewModel.delegate = self
        self.contentFilterTabView.delegate = self
        
        emptyStateView.settingbutton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
        emptyStateView.cancelButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        emptyStateView.twitterButton.addTarget(self, action: "didTapTwitterButton", forControlEvents: .TouchUpInside)
        emptyStateView.userInteractionEnabled = true
        
        do {
            try viewModel.requestData()
        } catch UserProfileViewModelError.RequestDataFailed {
            print("Failed to request data")
        } catch let error {
            print("Failed to request data \(error)")
        }
        
        view.backgroundColor = VeryLightGray
        view.layer.masksToBounds = true
        
        view.addSubview(contentFilterTabView)
        view.addSubview(emptyStateView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func userProfileViewModelDidLoginUser(userProfileViewModel: MediaLinksViewModel) {
        collectionView?.reloadData()
        
    }
    
    func userProfileViewModelDidReceiveMediaLinks(userProfileViewModel: MediaLinksViewModel, links: [MediaLink]) {
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        collectionView?.reloadSections(NSIndexSet(index: 0))
        hasLinks()
    }
    
    func userFavoritesTabSelected() {
        viewModel.currentCollectionType = .Favorites
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        hasLinks()
    }
    
    func userRecentsTabSelected() {
        viewModel.currentCollectionType = .Recents
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
        hasLinks()
    }
    
    func filterDidChange(filters: [MediaType]) {
        viewModel.filters = filters
    }
    
    func hasLinks() {
        collectionView?.scrollEnabled = false
        
        if !((emptyStateView.userState == .NoTwitter) || (emptyStateView.userState == .NoKeyboard)) {
            switch (viewModel.currentCollectionType) {
            case .Favorites:
                if (viewModel.userFavorites.isEmpty) {
                    emptyStateView.updateEmptyStateContent(.NoFavorites)
                    emptyStateView.hidden = false
                } else {
                    emptyStateView.hidden = true
                    collectionView?.scrollEnabled = true
                }
                
                break
            case .Recents:
                
                if (viewModel.userRecents.isEmpty) {
                    emptyStateView.updateEmptyStateContent(.NoRecents)
                    emptyStateView.hidden = false
                } else {
                    emptyStateView.hidden = true
                    collectionView?.scrollEnabled = true
                }
                
                break
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaLinks.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaLinkCollectionViewCell
        cell = parseMediaLinkData(viewModel.mediaLinks, indexPath: indexPath, collectionView: collectionView)
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
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaLinkCollectionViewCell,
            let cells = collectionView.visibleCells() as? [MediaLinkCollectionViewCell],
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
    
    // MARK: MediaLinkCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        viewModel.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }
    
    override func mediaLinkCollectionViewCellDidToggleDeleteButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        viewModel.toggleFavorite(!selected, result: result)
        cell.itemFavorited = !selected
    }
    
}