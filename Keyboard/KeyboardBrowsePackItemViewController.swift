//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, CategoriesCollectionViewControllerDelegate {
    var packServiceListener: Listener? = nil
    var packViewModel: PackItemViewModel

    override init(packId: String, panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        packViewModel = viewModel
        super.init(packId: packId, panelStyle: panelStyle, viewModel: viewModel, textProcessor: textProcessor)
        packViewModel.delegate = self
        showLoadingView()
        
        if packId.isEmpty {
            packServiceListener = PacksService.defaultInstance.didUpdatePacks.once({ items in
                if let packId = items.first?.pack_id {
                    self.packId = packId
                    self.loadPackData()
                }
            })
        }

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.populatePanelMetaData(self.pack?.name, itemCount: self.viewModel.getItemCount(), imageUrl: self.pack?.smallImageURL)
            self.hideLoadingView()
            self.collectionView?.reloadData()
        }

        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPackData()
    }

    override func togglePack() {
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance)
        packsVC.delegate = self
        packsVC.transitioningDelegate = self
        packsVC.modalPresentationStyle = .Custom
        presentViewController(packsVC, animated: true, completion: nil)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsetsMake(51.0, 0, 0, 0)
        } else if section == viewModel.mediaItemGroups.count - 1 {
            return UIEdgeInsetsMake(0, 0, SectionPickerViewHeight, 0)
        } else {
            return UIEdgeInsetsZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        guard let group = groupAtIndex(indexPath.section) else {
            return CGSizeZero
        }
        
        switch group.type {
        case .Gif:
            let itemsCount = group.items.count
            var height: CGFloat
            
            if itemsCount == 0 {
                height = 0
            } else {
                height = 103
            }
            
            return CGSizeMake(UIScreen.mainScreen().bounds.width, height)
        case .Quote:
            return CGSizeMake(UIScreen.mainScreen().bounds.width, 75)
        default:
            return CGSizeZero
        }
    }
    
    override func setupCategoryCollectionViewController() {
        super.setupCategoryCollectionViewController()
        categoriesVC?.delegate = self
        categoriesVC?.currentCategory = categoriesVC?.categories[SessionManagerFlags.defaultManagerFlags.lastCategoryIndex]
        categoriesVC?.panelView.switchKeyboardButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.switchKeyboardButtonDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    func switchKeyboardButtonDidTap(sender: UIButton) {
         NSNotificationCenter.defaultCenter().postNotificationName(SwitchKeyboardEvent, object: nil)
    }

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        packViewModel.packId = pack.id
        SessionManagerFlags.defaultManagerFlags.lastPack = pack.id
        loadPackData()
    }

    func categoriesCollectionViewControlleDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
    }
}
