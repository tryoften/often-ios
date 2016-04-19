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
            self.populatePanelMetaData(self.pack?.name, itemCount: self.viewModel.filteredMediaItems.count, imageUrl: self.pack?.smallImageURL)
            self.hideLoadingView()
            self.collectionView?.reloadData()
        }

        collectionView?.contentInset = UIEdgeInsetsMake(7, 0, SectionPickerViewHeight, 0)

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

    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let topMargin = CGFloat(0)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, cellHeight)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 30.0, 0.0)

        return layout
    }

    override func togglePack() {
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance)
        packsVC.delegate = self
        packsVC.transitioningDelegate = self
        packsVC.modalPresentationStyle = .Custom
        presentViewController(packsVC, animated: true, completion: nil)
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
