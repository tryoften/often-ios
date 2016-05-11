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
    var lyricsHorizontalVC: TrendingLyricsHorizontalCollectionViewController?
    var alphabeticalSidebar: CollectionViewAlphabeticalSidebar?
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
            collectionView.registerClass(MediaItemsSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        }
    }

    func setupAlphabeticalSidebar() {
        alphabeticalSidebar = CollectionViewAlphabeticalSidebar(frame: CGRectZero, indexTitles: AlphabeticalSidebarIndexTitles)

        if let alphabeticalSidebar = alphabeticalSidebar {
            alphabeticalSidebar.translatesAutoresizingMaskIntoConstraints = false
            alphabeticalSidebar.addTarget(self, action: #selector(MediaItemsViewController.indexViewValueChanged(_:)), forControlEvents: .ValueChanged)

            view.addSubview(alphabeticalSidebar)

            view.addConstraints([
                alphabeticalSidebar.al_right == view.al_right,
                alphabeticalSidebar.al_width == AlphabeticalSidebarWidth,
                alphabeticalSidebar.al_bottom == view.al_bottom - 20,
                alphabeticalSidebar.al_top == view.al_top + KeyboardSearchBarHeight - 0.5
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestData(false)
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

        viewModel.fetchCollection { success in
            self.reloadData(animated)
        }
    }
    
    func reloadData(animated: Bool = false, collectionTypeChanged: Bool = false) {
        loaderTimeoutTimer?.invalidate()

        if viewModel.isDataLoaded {
            hideLoadingView()

            if !(viewModel.userState == .NoTwitter || viewModel.userState == .NoKeyboard) {
                let collection = viewModel.generateMediaItemGroups()
                
                if collection.isEmpty {
                    switch collectionType {
                    case .Favorites: showEmptyStateViewForState(.NoFavorites, animated: animated)
                    case .Recents: showEmptyStateViewForState(.NoRecents, animated: animated)
                    default: break
                    }
                } else {
                    hideEmptyStateView()
                    collectionView?.reloadData()
                }
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

    func indexViewValueChanged(sender: BDKCollectionIndexView) {
        guard let sectionIndex = viewModel.sectionForSectionIndexTitle(sender.currentIndexTitle) else {
            return
        }

        var sectionHeaderPadding: CGFloat = 45

        if sectionIndex == 0 {
            sectionHeaderPadding = 0
        }

        let path = NSIndexPath(forItem: 0, inSection: sectionIndex)
        collectionView?.scrollToItemAtIndexPath(path, atScrollPosition: .Top, animated: false)
        collectionView?.contentOffset = CGPoint(x: collectionView!.contentOffset.x,
            y: collectionView!.contentOffset.y - sectionHeaderPadding)

    }

    override func didTapEmptyStateViewCloseButton() {
        super.didTapEmptyStateViewCloseButton()
        viewModel.hasSeenTwitter = true
        reloadData(false)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.generateMediaItemGroups().count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && collectionType == .Recents {
            return 1
        }
        return viewModel.mediaItemGroupItemsForIndex(section).count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        if collectionType == .Packs {
            cell = parsePackItemData(viewModel.mediaItemGroupItemsForIndex(indexPath.section), indexPath: indexPath, collectionView: collectionView) as BrowseMediaItemCollectionViewCell
        } else {
            cell = parseMediaItemData(viewModel.mediaItemGroupItemsForIndex(indexPath.section), indexPath: indexPath, collectionView: collectionView) as MediaItemCollectionViewCell
        }

        animateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                
                    sectionView.artistImageURL = nil
                    if let url = viewModel.sectionHeaderImageURL(indexPath) {
                        sectionView.artistImageURL = url
                    }
                
                    sectionView.leftText = viewModel.leftSectionHeaderTitle(indexPath.section)
                    sectionView.rightText = viewModel.rightSectionHeaderTitle(indexPath)

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

    //TODO(luc): move this method out into a subclass
    func provideRecentlyAddedLyricsHorizontalCollectionViewController() -> TrendingLyricsHorizontalCollectionViewController {
        if lyricsHorizontalVC == nil {
            lyricsHorizontalVC = RecentlyAddedHorizontalCollectionViewController()
            lyricsHorizontalVC?.parentVC = self
            lyricsHorizontalVC?.textProcessor = textProcessor
            addChildViewController(lyricsHorizontalVC!)
        }
        return lyricsHorizontalVC!
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
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
    
        cell.itemFavorited = selected
    }
}

