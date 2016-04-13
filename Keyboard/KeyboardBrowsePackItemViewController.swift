//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate {

    override init(packId: String, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        super.init(packId: packId, viewModel: viewModel, textProcessor: textProcessor)

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.populatePanelMetaData(self.pack?.name, itemCount: self.viewModel.filteredMediaItems.count, imageUrl: self.pack?.smallImageURL)
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
        loadPackData(.Detailed)
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

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        packId = pack.id
        SessionManagerFlags.defaultManagerFlags.lastPack = packId
        loadPackData(.Detailed)
    }
}