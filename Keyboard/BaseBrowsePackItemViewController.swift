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
import Material

let gifCellReuseIdentifier = "gifCellIdentifier"

class BaseBrowsePackItemViewController: BrowseMediaItemViewController, CategoriesCollectionViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    var packCollectionListener: Listener? = nil
    var panelToggleListener: Listener?
    var HUDMaskView: UIView?
    var menuView: AnimatedMenuView
    var packViewModel: PackItemViewModel
    
    init(viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()
        menuView = AnimatedMenuView()


        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))
        self.packViewModel = viewModel

        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor

        collectionView?.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)

        menuView.startMenuItem.addTarget(self, action: #selector(BaseBrowsePackItemViewController.startMenuItemPressed), forControlEvents: .TouchUpInside)

        for view in menuView.menu.views! {
            if let buttonView = view as? AnimatedMenuButton {
                buttonView.button.addTarget(self, action: #selector(BaseBrowsePackItemViewController.menuButtonPressed(_:)), forControlEvents: .TouchUpInside)
            }
        }

        if packViewModel.typeFilter == .Gif {
            menuView.gifsMenuItem.selected = true
        } else {
            menuView.quotesMenuItem.selected = true
        }

        setupHudView() 
        view.addSubview(menuView)
    }
    
    func closeAnimatedMenu() {
        menuView.menu.close()
        hideMaskView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        HUDMaskView?.frame = view.bounds
    }
    
    func menuButtonPressed(sender: AnimatedMenuButton) {
        guard let type = AnimatedMenuItem(rawValue: sender.tag) else {
            return
        }
        
        switch type {
        case .Gifs:
            packViewModel.typeFilter = .Gif
            closeAnimatedMenu()
        case .Quotes:
            packViewModel.typeFilter = .Quote
            closeAnimatedMenu()
        case .Categories:
            toggleCategoryViewController()
            closeAnimatedMenu()
        default:
            break
        }
    }

    func startMenuItemPressed() {
        if menuView.menu.opened {
            menuView.menu.close()
            hideMaskView()
        } else {
            menuView.menu.open()
            showMaskView()
        }
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
    
    func hideMaskView() {
        UIView.animateWithDuration(0.3, animations: {
            self.HUDMaskView?.alpha = 0.0
            self.HUDMaskView?.hidden = true
            }, completion: nil)
    }
    
    func showMaskView() {
        guard let maskeView = HUDMaskView else {
            return
        }

        view.insertSubview(menuView, aboveSubview: maskeView)
        maskeView.hidden = false
        maskeView.alpha = 0
        
        UIView.animateWithDuration(0.1, animations: {
            maskeView.alpha = 1.0
            }, completion: nil)
    }

    func setupHudView() {
        if HUDMaskView != nil {
            return
        }

        let toggleDrawerSelector = #selector(BaseBrowsePackItemViewController.startMenuItemPressed)
        let hudRecognizer = UITapGestureRecognizer(target: self, action: toggleDrawerSelector)

        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.hidden = true
        HUDMaskView?.userInteractionEnabled = true
        HUDMaskView?.addGestureRecognizer(hudRecognizer)

        view.addSubview(HUDMaskView!)
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
            let cellWidth = (UIScreen.mainScreen().bounds.width / 2) - 16
            return CGSizeMake(cellWidth, 100)
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
        collectionView?.reloadData()
        viewModel.fetchData()
        hideMaskView()
        
    }    


    func toggleCategoryViewController() {
        guard let pack = packViewModel.pack  else {
            return
        }
        menuView.menu.close()

        let categoriesVC = CategoryCollectionViewController(viewModel: viewModel, categories: pack.categories)
        categoriesVC.delegate = self
        presentViewCotntrollerWithCustomTransitionAnimator(categoriesVC, direction: .Left, duration: 0.25)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        
        for cell in collectionView.visibleCells() {
            if let cell = cell as? BaseMediaItemCollectionViewCell where collectionView.indexPathForCell(cell) != indexPath {
                cell.overlayVisible = false
            }
        }

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell {
            cell.overlayVisible = !cell.overlayVisible
            mediaLinkCollectionViewCellDidToggleCopyButton(cell, selected: true)
        }
    }
    
    func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {}

    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)

        if let imageURL = self.packViewModel.pack?.smallImageURL, image = UIImage(data: NSData(contentsOfURL: imageURL)!) {
            menuView.startMenuItem.setImage(image, forState: .Normal)
        }
    }

}
