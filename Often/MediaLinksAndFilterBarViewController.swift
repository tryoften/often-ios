//
//  MediaLinksAndFilterBarViewController.swift
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

let MediaLinksSectionHeaderViewReuseIdentifier = "MediaLinksSectionHeader"

class MediaLinksAndFilterBarViewController: MediaLinksCollectionBaseViewController, MediaLinksViewModelDelegate {
    var viewModel: MediaLinksViewModel
    var emptyStateView: EmptyStateView?
    var loaderImageView: UIImageView
    var loadingTimer: NSTimer?
    var userState: UserState
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
        
        loaderImageView = UIImageView(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
        loaderImageView.contentMode = .Center
        loaderImageView.contentScaleFactor = 2.5
        loaderImageView.hidden = true

        collectionType = aCollectionType

        userState = .NonEmpty
        
        super.init(collectionViewLayout: collectionViewLayout)

        self.viewModel.delegate = self
        
        view.backgroundColor = VeryLightGray
        view.layer.masksToBounds = true
        view.addSubview(loaderImageView)

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
        loaderImageView.frame = view.bounds
    }
    
    func setupLayout() {
        
    }
    
    func reloadData() {
        if viewModel.isDataLoaded {
            collectionView?.scrollEnabled = false
            if !(userState == .NoTwitter || userState == .NoKeyboard) {
                let collection = viewModel.filteredMediaLinksForCollectionType(collectionType)

                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: updateEmptyStateContent(.NoFavorites)
                    case .Recents: updateEmptyStateContent(.NoRecents)
                    default: break
                    }
                    emptyStateView?.hidden = false
                } else {
                    emptyStateView?.hidden = true
                    fadeInData()
                }
            }
        }
    }
    
    func showLoader() {
        if !viewModel.isDataLoaded {
            loaderImageView.hidden = false
        }
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
        if let emptyStateView = emptyStateView {
            emptyStateView.removeFromSuperview()
        }
        
        emptyStateView = EmptyStateView.emptyStateViewForUserState(state)
        
        if let emptyStateView = emptyStateView {
            view.addSubview(emptyStateView)
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
    
    // MARK: MediaLinksViewModelDelegate
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaLinksViewModel, user: User) {
        reloadData()
    }
    
    func mediaLinksViewModelDidReceiveMediaLinks(mediaLinksViewModel: MediaLinksViewModel, collectionType: MediaLinksCollectionType, links: [MediaLink]) {
        reloadData()
        loaderImageView.hidden = true
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

