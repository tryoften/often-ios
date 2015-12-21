//
//  MediaLinksAndFilterBarViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

let MediaLinksSectionHeaderViewReuseIdentifier = "MediaLinksSectionHeader"

class MediaLinksAndFilterBarViewController: MediaLinksCollectionBaseViewController {
    var viewModel: MediaLinksViewModel
    var emptyStateView: EmptySetView
    var collectionType: MediaLinksCollectionType {
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


    init(collectionViewLayout: UICollectionViewLayout, collectionType aCollectionType: MediaLinksCollectionType, viewModel: MediaLinksViewModel) {
        self.viewModel = viewModel

        emptyStateView = EmptySetView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.hidden = true

        collectionType = aCollectionType

        super.init(collectionViewLayout: collectionViewLayout)

        view.backgroundColor = VeryLightGray
        view.layer.masksToBounds = true
        view.addSubview(emptyStateView)

        setupLayout()

        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.registerClass(MediaLinksSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        do {
            try viewModel.fetchCollection(collectionType) { success in
                self.reloadData()
            }
        } catch let error {
            print("Failed to request data \(error)")
        }
    }

    func setupLayout() {
        view.addConstraints([
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_top == view.al_top,
            emptyStateView.al_bottom == view.al_bottom,
        ])
    }
    
    func reloadData() {
        if viewModel.isDataLoaded {
            collectionView?.scrollEnabled = false
            if !(emptyStateView.userState == .NoTwitter || emptyStateView.userState == .NoKeyboard) {
                let collection = viewModel.filteredMediaLinksForCollectionType(collectionType)

                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: emptyStateView.updateEmptyStateContent(.NoFavorites)
                    case .Recents: emptyStateView.updateEmptyStateContent(.NoRecents)
                    default: break
                    }
                    emptyStateView.hidden = false
                } else {
                    emptyStateView.hidden = true
                    collectionView?.reloadSections(NSIndexSet(index: 0))
                    collectionView?.scrollEnabled = true
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMediaLinksForCollectionType(collectionType).count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MediaLinkCollectionViewCell
        cell = parseMediaLinkData(viewModel.filteredMediaLinksForCollectionType(collectionType), indexPath: indexPath, collectionView: collectionView)
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

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaLinksSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaLinksSectionHeaderView {
                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType)
                    return sectionView
            }
        }

        return UICollectionReusableView()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }

    // MARK: MediaLinkCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        viewModel.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }
}

