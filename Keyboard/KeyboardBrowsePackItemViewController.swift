//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, CategoriesCollectionViewControllerDelegate, AwesomeMenuDelegate {
    var packServiceListener: Listener? = nil

    override init(panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        super.init(panelStyle: panelStyle, viewModel: viewModel, textProcessor: textProcessor)
        packViewModel.delegate = self
        showLoadingView()

        menuButton = AnimatedMenu(frame: CGRectMake(0, 0, view.frame.width, KeyboardHeight))
        menuButton!.delegate = self
        
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
        
        view.addSubview(menuButton!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        menuButton?.frame = view.bounds
        menuButton?.resetStartPoint()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPackData()
    }

    override func togglePack() {
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

    func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
    }

    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animator = FadeInTransitionAnimator(presenting: true)

        if let VCTitle = presented.title {
            if VCTitle == "packsVC" {
                animator = FadeInTransitionAnimator(presenting: true, direction: .Left, duration: 0.2)
            }
        }

        return animator
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
        guard let maskView = self.HUDMaskView else {
            return
        }

        view.insertSubview(menuButton!, aboveSubview: maskView)
        
        maskView.hidden = false
        maskView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: {
            maskView.alpha = 1.0
            }, completion: nil)
    }
    
    func awesomeMenuWillAnimateClose(menu: AwesomeMenu!) {
        hideMaskView()
    }

    func hideMaskView() {
        guard let maskView = self.HUDMaskView else {
            return
        }

        UIView.animateWithDuration(0.3, animations: {
            maskView.alpha = 0.0
            }, completion: nil)
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
