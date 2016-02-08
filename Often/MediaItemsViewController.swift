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
    var alphabeticalSidebar: CollectionViewAlphabeticalSidebar

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

        alphabeticalSidebar = CollectionViewAlphabeticalSidebar(frame: CGRectZero, indexTitles: SidebarIndexMap)
        alphabeticalSidebar.translatesAutoresizingMaskIntoConstraints = false

        collectionType = aCollectionType
        hasFetchedData = false
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.viewModel.delegate = self
        
        view.backgroundColor = VeryLightGray
        view.layer.masksToBounds = true

        alphabeticalSidebar.addTarget(self, action: "indexViewValueChanged:", forControlEvents: .ValueChanged)

        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.registerClass(MediaItemsSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

        }

        view.addSubview(alphabeticalSidebar)
        setupLayout()
    }

    func setupLayout() {
        view.addConstraints([
            alphabeticalSidebar.al_right == view.al_right,
            alphabeticalSidebar.al_width == 28.0,
            alphabeticalSidebar.al_bottom == view.al_bottom - 20,
            alphabeticalSidebar.al_top == view.al_top + KeyboardSearchBarHeight
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideEmptyStateView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideEmptyStateView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        requestData(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

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
        loaderTimeoutTimer?.invalidate()
        collectionView?.scrollEnabled = true

        if viewModel.isDataLoaded {
            setupSidebar()
            loaderView?.hidden = true
            collectionView?.scrollEnabled = true
            if !(viewModel.userState == .NoTwitter || viewModel.userState == .NoKeyboard) {
                let collection = viewModel.generateMediaItemGroupsForCollectionType(collectionType)
                
                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: showEmptyStateViewForState(.NoFavorites, animated: animated)
                    case .Recents: showEmptyStateViewForState(.NoRecents, animated: animated)
                    default: break
                    }
                } else {
                    emptyStateView?.hidden = true
                #if !(KEYBOARD)
                    collectionView?.setContentOffset(CGPointZero, animated: animated)
                #endif
                    collectionView?.reloadData()
                }
            } else {
                collectionView?.scrollEnabled = false
            }
        }
    }

    func setupSidebar() {
        switch collectionType {
        case .Favorites:
            alphabeticalSidebar.hidden = false
            viewModel.indexSectionHeaderTitles()
            alphabeticalSidebar.reloadData()

        default:
            alphabeticalSidebar.hidden = true
        }

    }

    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        alphabeticalSidebar.hidden = true
        super.scrollViewWillBeginDecelerating(scrollView)
    }

    func showData(animated: Bool = false) {
        collectionView?.alpha = 0.0
        collectionView?.reloadSections(NSIndexSet(index: 0))
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: {
            self.collectionView?.alpha = 1.0
        })
        collectionView?.scrollEnabled = true
    }

    func indexViewValueChanged(sender: BDKCollectionIndexView) {
        guard let sectionIndex = viewModel.sectionForSectionIndexTitleAtIndex(sender.currentIndexTitle) else {
            return
        }

        let path = NSIndexPath(forItem: 0, inSection: sectionIndex)
        collectionView?.scrollToItemAtIndexPath(path, atScrollPosition: .Top, animated: false)
        // If you're using a collection view, bump the y-offset by a certain number of points
        // because it won't otherwise account for any section headers you may have.
        collectionView?.contentOffset = CGPoint(x: collectionView!.contentOffset.x,
            y: collectionView!.contentOffset.y)

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
                    
                    sectionView.artistImageURL = nil
                    if collectionType == .Favorites {
                        if let url = viewModel.sectionHeaderImageURL(collectionType, index: indexPath.section) {
                            sectionView.artistImageURL = url
                        }
                    }
                    
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
        return CGSizeMake(UIScreen.mainScreen().bounds.width, MediaItemsSectionHeaderHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        if collectionType == .Favorites {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaItemCollectionViewCell {
                cell.favoriteRibbon.hidden = true
            }
        }
    }

    
    // MARK: MediaItemsViewModelDelegate
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User) {
        reloadData(false)
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

