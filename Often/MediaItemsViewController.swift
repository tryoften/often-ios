//
//  MediaItemsViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

public enum UserState {
    case noTwitter
    case noFavorites
    case noRecents
    case noKeyboard
    case nonEmpty
    case noResults
}

let MediaItemsSectionHeaderViewReuseIdentifier = "MediaItemsSectionHeader"

class MediaItemsViewController: MediaItemsCollectionBaseViewController, MediaItemsViewModelDelegate {
    var viewModel: MediaItemsViewModel
    var hasFetchedData: Bool
    var collectionType: MediaItemsCollectionType {
        didSet {
            sectionHeaders = [:]
            requestData(true)
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
            collectionView.register(MediaItemsSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestData(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestData(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func requestData(_ animated: Bool = false) {
        super.requestData(animated)

        viewModel.fetchCollection { success in
            self.reloadData(animated)
        }
    }
    
    func reloadData(_ animated: Bool = false, collectionTypeChanged: Bool = false) {
        loaderTimeoutTimer?.invalidate()

        if viewModel.isDataLoaded {
            hideLoadingView()

            if !(viewModel.userState == .noTwitter || viewModel.userState == .noKeyboard) {
                let collection = viewModel.generateMediaItemGroups()
                
                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: showEmptyStateViewForState(.noFavorites, animated: animated)
                    case .Recents: showEmptyStateViewForState(.noRecents, animated: animated)
                    default: break
                    }
                } else {
                    hideEmptyStateView()
                    collectionView?.reloadData()
                }
            }
        }
    }

    func showData(_ animated: Bool = false) {
        collectionView?.alpha = 0.0
        collectionView?.reloadSections(IndexSet(integer: 0))
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.collectionView?.alpha = 1.0
        })
        collectionView?.isScrollEnabled = true
    }

    override func didTapEmptyStateViewCloseButton() {
        super.didTapEmptyStateViewCloseButton()
        viewModel.hasSeenTwitter = true
        reloadData(false)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.generateMediaItemGroups().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && collectionType == .Recents {
            return 1
        }
        return viewModel.mediaItemGroupItemsForIndex(section).count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        if collectionType == .Packs {
            cell = parsePackItemData(viewModel.mediaItemGroupItemsForIndex((indexPath as NSIndexPath).section), indexPath: indexPath, collectionView: collectionView) as BrowseMediaItemCollectionViewCell
        } else {
            cell = parseMediaItemData(viewModel.mediaItemGroupItemsForIndex((indexPath as NSIndexPath).section), indexPath: indexPath, collectionView: collectionView) as MediaItemCollectionViewCell
        }

        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, for: indexPath) as? MediaItemsSectionHeaderView {
                
                    sectionView.artistImageURL = nil
                    if let url = viewModel.sectionHeaderImageURL(indexPath) {
                        sectionView.artistImageURL = url
                    }
                
                    sectionView.leftText = viewModel.leftSectionHeaderTitle((indexPath as NSIndexPath).section)
                    sectionView.rightText = viewModel.rightSectionHeaderTitle(indexPath)

                    sectionHeaders[(indexPath as NSIndexPath).section] = sectionView
                    return sectionView
            }
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main().bounds.width, height: MediaItemsSectionHeaderHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)

        if collectionType == .Favorites {
            if let cell = collectionView.cellForItem(at: indexPath) as? MediaItemCollectionViewCell {
                cell.favoriteRibbon.isHidden = true
            }
        }
    }

    //TODO(luc): move this method out into a subclass

    
    // MARK: MediaItemsViewModelDelegate
    func mediaLinksViewModelDidAuthUser(_ mediaLinksViewModel: MediaItemsViewModel, user: User) {
        reloadData(false)
    }
    
    func mediaLinksViewModelDidFailLoadingMediaItems(_ mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError) {
        loaderView?.isHidden = true
        collectionView?.isHidden = false
    }
    
    func mediaLinksViewModelDidCreateMediaItemGroups(_ mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup]) {
        reloadData(false, collectionTypeChanged: true)
    }
    
    // MARK: MediaItemCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(_ cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
    
        cell.itemFavorited = selected
    }
}

