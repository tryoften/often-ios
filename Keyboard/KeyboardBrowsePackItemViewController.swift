//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, AwesomeMenuDelegate {
   private var packServiceListener: Listener? = nil
    var panelView: CategoriesPanelView

     init(viewModel: PacksService, textProcessor: TextProcessingManager?) {
        panelView = CategoriesPanelView()

        super.init(viewModel: viewModel, textProcessor: textProcessor)
        packViewModel.delegate = self
        showLoadingView()

        panelView.switchKeyboardButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.switchKeyboardButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        panelView.backspaceButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.backspaceButtonDidTap), forControlEvents: .TouchUpInside)

        menuButton = AnimatedMenu(frame: CGRectMake(0, 0, view.frame.width, KeyboardHeight))
        menuButton!.delegate = self

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.populatePanelMetaData()
            self.hideLoadingView()
            self.collectionView?.reloadData()
        }

        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }

        view.addSubview(menuButton!)
        view.addSubview(panelView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        menuButton?.frame = view.bounds
        menuButton?.resetStartPoint()

        panelView.frame = CGRectMake(view.bounds.origin.x, view.bounds.height - SectionPickerViewHeight, view.bounds.width, SectionPickerViewHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPackData()
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

    // AwesomeMenu Delegate Methods
    func awesomeMenu(menu: AwesomeMenu!, didSelectIndex idx: Int) {
        hideMaskView()

        guard let item = AnimatedMenuItem(rawValue: idx) else {
            return
        }

        switch item { 
        case .Packs:
            togglePack()
        case .Categories:
            toggleCategoryViewController()
        case .Gifs:
            packViewModel.typeFilter = .Gif
        case .Quotes:
            packViewModel.typeFilter = .Quote
        }
    }
    
    func awesomeMenuWillAnimateOpen(menu: AwesomeMenu!) {

    }
    
    func awesomeMenuWillAnimateClose(menu: AwesomeMenu!) {
        hideMaskView()
    }

    func hideMaskView() {

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

        if let menuButton = menuButton, imageURL = pack.smallImageURL {
            menuButton.startButton.contentImageView.nk_setImageWith(imageURL)
        }
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
