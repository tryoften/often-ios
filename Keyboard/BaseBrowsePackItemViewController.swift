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

class BaseBrowsePackItemViewController: BrowseMediaItemViewController, UICollectionViewDelegateFlowLayout {
    var packCollectionListener: Listener? = nil
    var categoriesVC: CategoryCollectionViewController? = nil
    var panelToggleListener: Listener?
    var HUDMaskView: UIView?
    var pack: PackMediaItem? {
        didSet {
            cellsAnimated = [:]
            delay(0.5) {
                self.collectionView?.reloadData()
            }
        }
    }
    var packId: String
    var panelStyle: CategoryPanelStyle
    var packViewModel: PackItemViewModel
    
    init(packId: String, panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()

        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))

        self.packId = packId
        self.panelStyle = panelStyle
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        HUDMaskView?.frame = view.bounds
        
        guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
            return
        }
        
        layoutCategoryPanelView()
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
    
    func setupCategoryCollectionViewController() {
        let categoriesVC = CategoryCollectionViewController(viewModel: viewModel, categories: pack!.categories)
        self.categoriesVC = categoriesVC
        self.categoriesVC?.panelView.style = panelStyle
        
        let togglePackSelector = #selector(BaseBrowsePackItemViewController.togglePack)
        let toggleRecognizer = UITapGestureRecognizer(target: self, action: togglePackSelector)
        let toggleDrawerSelector = #selector(BaseBrowsePackItemViewController.toggleCategoryViewController)
        let hudRecognizer = UITapGestureRecognizer(target: self, action: toggleDrawerSelector)
        
        categoriesVC.panelView.togglePackSelectedView.addGestureRecognizer(toggleRecognizer)
        categoriesVC.panelView.togglePackSelectedView.userInteractionEnabled = true
        
        
        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.hidden = true
        HUDMaskView?.userInteractionEnabled = true
        HUDMaskView?.addGestureRecognizer(hudRecognizer)
        
        view.addSubview(HUDMaskView!)
        view.addSubview(categoriesVC.view)
        addChildViewController(categoriesVC)
        
        panelToggleListener = categoriesVC.panelView.didToggle.on({ opening in
            guard let maskView = self.HUDMaskView else {
                return
            }
            
            if opening {
                maskView.alpha = 0.0
                maskView.hidden = false
            }
            
            UIView.animateWithDuration(0.3, animations: {
                maskView.alpha = opening ? 1.0 : 0.0
                }, completion: { done in
                    if !opening {
                        maskView.hidden = true
                    }
            })
        })
        
        layoutCategoryPanelView()
    }
    
    func layoutCategoryPanelView() {
        let height: CGFloat
        if categoriesVC?.panelView.style == .Detailed {
            height = CGRectGetHeight(view.frame) - SectionPickerViewHeight
        } else {
            height = CGRectGetHeight(view.frame)
        }
        if let panelView = categoriesVC?.view {
            panelView.frame = CGRectMake(CGRectGetMinX(view.frame),
                                         height,
                                         CGRectGetWidth(view.frame),
                                         SectionPickerViewOpenedHeight)
        }
    }
    
    func populatePanelMetaData(title: String?, itemCount: Int?, imageUrl: NSURL?) {
        guard let title = title, categoriesVC = categoriesVC else {
            return
        }
        
        categoriesVC.panelView.mediaItemTitleText = title
        
        if let itemCount = itemCount {
            categoriesVC.panelView.currentCategoryCount = String(itemCount)
        }
        
        if let imageURL = imageUrl {
            categoriesVC.panelView.mediaItemImageView.nk_setImageWith(imageURL)
        }
        
    }
    
    func togglePack() {
        
    }
    
    func toggleCategoryViewController() {
        categoriesVC?.panelView.toggleDrawer()
    }
    
    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        if let viewModel = viewModel as? PackItemViewModel, pack = viewModel.pack {
            self.pack = pack
        }
        
        if self.categoriesVC == nil {
            self.setupCategoryCollectionViewController()
        } else {
            if let pack = self.pack {
                self.categoriesVC?.handleCategories(pack.categories)
            }
        }
        self.layoutCategoryPanelView()
        self.populatePanelMetaData(self.pack?.name, itemCount: self.viewModel.getItemCount(), imageUrl: self.pack?.smallImageURL)
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
}
