//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Material


class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate {
   private var packServiceListener: Listener? = nil
    var panelView: CategoriesPanelView

     init(viewModel: PacksService, textProcessor: TextProcessingManager?) {
        panelView = CategoriesPanelView()

        super.init(viewModel: viewModel, textProcessor: textProcessor)
        packViewModel.delegate = self
        showLoadingView()

        panelView.switchKeyboardButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.switchKeyboardButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        panelView.backspaceButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.backspaceButtonDidTap), forControlEvents: .TouchUpInside)

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.populatePanelMetaData()
            self.hideLoadingView()
            self.collectionView?.reloadData()
        }

        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }

        view.addSubview(panelView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        panelView.frame = CGRectMake(view.bounds.origin.x, view.bounds.height - SectionPickerViewHeight, view.bounds.width, SectionPickerViewHeight)
        
        MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: 40, right: 18)
        MaterialLayout.size(view, child: menuView, width: 45, height: 45)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPackData()
    }

    override func menuButtonPressed(sender: AnimatedMenuButton) {
        super.menuButtonPressed(sender)

        guard let type = AnimatedMenuItem(rawValue: sender.tag) else {
            return
        }

        switch type {
        case .Packs:
            togglePack()
            closeAnimatedMenu()
        default:
            break
        }
    }

    func togglePack() {
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance)
        packsVC.delegate = self
        presentViewCotntrollerWithCustomTransitionAnimator(packsVC, direction: .Left, duration: 0.2)
    }

    func switchKeyboardButtonDidTap(sender: UIButton) {
         NSNotificationCenter.defaultCenter().postNotificationName(SwitchKeyboardEvent, object: nil)
    }

    func backspaceButtonDidTap(sender:UIButton) {
        textProcessor?.deleteBackward()
    }

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        PacksService.defaultInstance.switchCurrentPack(pack.id)
        loadPackData()
    }

    override func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
        populatePanelMetaData()
    }

    func populatePanelMetaData() {
        guard let packsService = viewModel as? PacksService, let pack = packsService.pack,
            let mediaItemTitleText = pack.name, let category =  viewModel.currentCategory, let currentCategoryText = category.name as? String else {
            return
        }
        
        panelView.mediaItemTitleText = mediaItemTitleText
        panelView.currentCategoryText = currentCategoryText

    }

    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)

        guard let viewModel = viewModel as? PackItemViewModel, pack = viewModel.pack else {
            return
        }

        hideLoadingView()

        populatePanelMetaData()
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
