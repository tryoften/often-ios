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
let imageCellReuseIdentifier = "imageCellIdentifier"

class BaseBrowsePackItemViewController: BrowseMediaItemViewController, CategoriesCollectionViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    var packCollectionListener: Listener? = nil
    var panelToggleListener: Listener?
    var HUDMaskView: UIView?
    var packViewModel: PackItemViewModel
    
    init(viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        self.packViewModel = viewModel

        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor

        collectionView?.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)
        collectionView?.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: imageCellReuseIdentifier)
        setupHudView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delay(0.5) {
            self.loadPackData()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        HUDMaskView?.frame = view.bounds
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadPackData()
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
        guard let maskView = HUDMaskView else {
            return
        }

        maskView.hidden = false
        maskView.alpha = 0
        
        UIView.animateWithDuration(0.1, animations: {
            maskView.alpha = 1.0
        }, completion: nil)
    }

    func setupHudView() {
        if HUDMaskView != nil {
            return
        }

        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.hidden = true
        HUDMaskView?.userInteractionEnabled = true

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

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if packViewModel.typeFilter == .Gif || packViewModel.typeFilter == .Image {
            return 7.0
        }
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if packViewModel.typeFilter == .Gif || packViewModel.typeFilter == .Image  {
            return 7.0
        }
        return 0.0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return UICollectionViewCell()
        }
        
        guard let item = group.items[indexPath.row] as? MediaItem else {
            return UICollectionViewCell()
        }

        return setupCell(group, item: item, indexPath: indexPath, collectionView: collectionView)

    }
    
    func setupCell(group: MediaItemGroup, item: MediaItem, indexPath: NSIndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        switch item.type {
        case .Gif:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(gifCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let gif = item as? GifMediaItem else {
                return cell
            }
            
            if let imageURL = gif.mediumImageURL {
                cell.setImageWith(imageURL)
            }
            
            cell.mediaLink = gif
            cell.delegate = self
            return cell
        case .Image:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imageCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let image = item as? ImageMediaItem else {
                return cell
            }
            
            if let imageURL = image.mediumImageURL {
                cell.setImageWith(imageURL)
            }
            
            cell.mediaLink = image
            cell.delegate = self
            return cell
        case .Quote:
            let cell = parseMediaItemData(group.items, indexPath: indexPath, collectionView: collectionView)
            cell.style = .Cell
            cell.type = .Metadata
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
            let width = UIScreen.mainScreen().bounds.width/2 - 12.5
            let height = width * (4/7)
            return CGSizeMake(width, height)
        case .Image:
            let width = UIScreen.mainScreen().bounds.width/2 - 12.5
            let height = width
            return CGSizeMake(width, height)
        case .Quote:
            return CGSizeMake(UIScreen.mainScreen().bounds.width, 75)
        default:
            return CGSizeZero
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif || packViewModel.typeFilter == .Image {
            return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 9.0, right: 9.0)
        }

        return UIEdgeInsetsZero
    }

    func loadPackData()  {
        collectionView?.reloadData()
        viewModel.fetchData()
        hideMaskView()
    }

    override func requestForIndexPaths(indexPaths: [NSIndexPath]) -> [ImageRequest]? {
        var imageRequest: [ImageRequest] = []

        for index in indexPaths {
            if let group = packViewModel.getMediaItemGroupForCurrentType() where index.row < group.items.count {
                if let url = group.items[index.row].smallImageURL {
                    imageRequest.append (ImageRequest(URL: url))
                }
            }
        }

        return imageRequest
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        
        for cell in collectionView.visibleCells() {
            if let cell = cell as? BaseMediaItemCollectionViewCell where collectionView.indexPathForCell(cell) != indexPath {
                cell.overlayVisible = false
            }
        }

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell {
            #if KEYBOARD
                cell.overlayVisible = !cell.overlayVisible
            #endif
                mediaLinkCollectionViewCellDidToggleCopyButton(cell, selected: true)
        }
    }
        
    func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {}
}
