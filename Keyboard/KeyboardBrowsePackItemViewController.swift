//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Material

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, CategoriesCollectionViewControllerDelegate {
    var packServiceListener: Listener? = nil

    override init(panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        
        super.init(panelStyle: panelStyle, viewModel: viewModel, textProcessor: textProcessor)
        packViewModel.delegate = self
        showLoadingView()
        
        if viewModel.packId.isEmpty {
            packServiceListener = PacksService.defaultInstance.didUpdatePacks.once({ items in
                if let packId = items.first?.pack_id {
                    viewModel.packId = packId
                    self.loadPackData()
                }
            })
        }

        setupHudView()
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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: 40, right: 18)
        MaterialLayout.size(view, child: menuView, width: 45, height: 45)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPackData()
    }

    override func togglePack() {
        menuView.menu.close()
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance)
        packsVC.delegate = self
        packsVC.transitioningDelegate = self
        packsVC.title = "packsVC"
        packsVC.modalPresentationStyle = .Custom
        presentViewController(packsVC, animated: true, completion: nil)
    }

    override func setupCategoryCollectionViewController() {
        super.setupCategoryCollectionViewController()
        categoriesVC?.delegate = self
        categoriesVC?.currentCategory = categoriesVC?.categories.first
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

    func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
    }

    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animator = FadeInTransitionAnimator(presenting: true)

        if let VCTitle = presented.title where VCTitle == "packsVC" {
            animator = FadeInTransitionAnimator(presenting: true, direction: .Left, duration: 0.2)
        }

        return animator
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif {
            return UIEdgeInsets(top: 10.0, left: 12.0, bottom: 60.0, right: 12.0)
        }

        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }

}
