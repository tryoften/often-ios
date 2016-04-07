//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardBrowsePackItemViewController: BrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        HUDMaskView?.frame = view.bounds

        guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
            return
        }

        layoutCategoryPanelView()
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

        loadPackData()
    }
}