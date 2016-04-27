//
//  BaseBrowsePackViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Nuke
import NukeAnimatedImagePlugin
import FLAnimatedImage

let gifCellReuseIdentifier = "gifCellIdentifier"

class BaseBrowsePackItemViewController: BrowseMediaItemViewController, CategoriesCollectionViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    var packCollectionListener: Listener? = nil
    var panelToggleListener: Listener?
    var menuButton: AnimatedMenu?
    var pack: PackMediaItem? {
        didSet {
            cellsAnimated = [:]
            delay(0.5) {
                self.collectionView?.reloadData()
            }
        }
    }
    var packViewModel: PackItemViewModel
    
    init(viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()

        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))
        self.packViewModel = viewModel
        
        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor
        
        collectionView?.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func groupAtIndex(index: Int) -> MediaItemGroup? {
        if index > viewModel.mediaItemGroups.count {
            return nil
        }
        return viewModel.groupAtIndex(index)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return 0
        }
        return group.items.count
    }

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if packViewModel.typeFilter == .Gif {
            return 8.0
        }
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if packViewModel.typeFilter == .Gif {
            return 8.0
        }
        return 0.0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return UICollectionViewCell()
        }
        
        switch group.type {
        case .Gif:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(gifCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
                return UICollectionViewCell()
            }

            guard let gif = group.items[indexPath.row] as? GifMediaItem else {
                return cell
            }

            if let imageURL = gif.mediumImageURL {
                cell.setImageWith(imageURL)
            }

            cell.mediaLink = gif
            cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(gif)
            cell.delegate = self
            return cell
        case .Quote:
            let cell = parseMediaItemData(group.items, indexPath: indexPath, collectionView: collectionView)
            cell.style = .Cell
            cell.type = .NoMetadata
            animateCell(cell, indexPath: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return CGSizeZero
        }
        
        switch group.type {
        case .Gif:
            return CGSizeMake(171.5, 100)
        case .Quote:
            return CGSizeMake(UIScreen.mainScreen().bounds.width, 75)
        default:
            return CGSizeZero
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif {
            return UIEdgeInsets(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)
        }

        return UIEdgeInsetsZero
    }


    func loadPackData()  {
        pack = nil
        collectionView?.reloadData()
        viewModel.fetchData()
    }    

    func toggleCategoryViewController() {
        guard let pack = pack else {
            return
        }

        let categoriesVC = CategoryCollectionViewController(viewModel: viewModel, categories: pack.categories)
        categoriesVC.delegate = self
        presentViewCotntrollerWithCustomTransitionAnimator(categoriesVC, direction: .Left)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        for cell in collectionView.visibleCells() {
            if let cell = cell as? BaseMediaItemCollectionViewCell where collectionView.indexPathForCell(cell) != indexPath {
                cell.overlayVisible = false
            }
        }

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell {
            cell.overlayVisible = !cell.overlayVisible
        }
    }

    func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {}

    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        if let viewModel = viewModel as? PackItemViewModel, pack = viewModel.pack {
            self.pack = pack
        }
    }

}
