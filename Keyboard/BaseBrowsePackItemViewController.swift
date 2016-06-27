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

class BaseBrowsePackItemViewController: BrowseMediaItemViewController, CategoriesCollectionViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    var packCollectionListener: Listener? = nil
    var panelToggleListener: Listener?
    var HUDMaskView: UIView?
    var packViewModel: PackItemViewModel
    
    init(viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        self.packViewModel = viewModel

        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor

        collectionView?.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPackData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func groupAtIndex(_ index: Int) -> MediaItemGroup? {
        if index > viewModel.mediaItemGroups.count {
            return nil
        }
        return viewModel.groupAtIndex(index)
    }
    
    func hideMaskView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.HUDMaskView?.alpha = 0.0
            self.HUDMaskView?.isHidden = true
            }, completion: nil)
    }
    
    func showMaskView() {
        guard let maskView = HUDMaskView else {
            return
        }

        maskView.isHidden = false
        maskView.alpha = 0
        
        UIView.animate(withDuration: 0.1, animations: {
            maskView.alpha = 1.0
        }, completion: nil)
    }

    func setupHudView() {
        if HUDMaskView != nil {
            return
        }

        let toggleDrawerSelector = #selector(BaseBrowsePackItemViewController.toggleCategoryViewController)
        let hudRecognizer = UITapGestureRecognizer(target: self, action: toggleDrawerSelector)

        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.isHidden = true
        HUDMaskView?.isUserInteractionEnabled = true
        HUDMaskView?.addGestureRecognizer(hudRecognizer)

        view.addSubview(HUDMaskView!)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return 0
        }
        return group.items.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if packViewModel.typeFilter == .Gif {
            return 7.0
        }
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if packViewModel.typeFilter == .Gif {
            return 7.0
        }
        return 0.0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return UICollectionViewCell()
        }
        
        switch group.type {
        case .Gif:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gifCellReuseIdentifier, for: indexPath) as? GifCollectionViewCell else {
                return UICollectionViewCell()
            }

            guard let gif = group.items[(indexPath as NSIndexPath).row] as? GifMediaItem else {
                return cell
            }

            if let imageURL = gif.mediumImageURL {
                cell.setImageWith(imageURL)
            }

            cell.mediaLink = gif
            cell.delegate = self
            return cell
        case .Quote:
            let cell = parseMediaItemData(group.items, indexPath: indexPath, collectionView: collectionView)
            cell.style = .cell
            cell.type = .noMetadata
            return cell
        default:
            return UICollectionViewCell()
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return CGSize.zero
        }
        
        switch group.type {
        case .Gif:
            let width = UIScreen.main().bounds.width/2 - 12.5
            let height = width * (4/7)
            return CGSize(width: width, height: height)
        case .Quote:
            return CGSize(width: UIScreen.main().bounds.width, height: 75)
        default:
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif {
            return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 9.0, right: 9.0)
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

        let categoriesVC = CategoryCollectionViewController(viewModel: packViewModel, categories: pack.categories)
        categoriesVC.delegate = self
        presentViewControllerWithCustomTransitionAnimator(categoriesVC, direction: .left, duration: 0.25)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
        for cell in collectionView.visibleCells() {
            if let cell = cell as? BaseMediaItemCollectionViewCell where collectionView.indexPath(for: cell) != indexPath {
                cell.overlayVisible = false
            }
        }

        if let cell = collectionView.cellForItem(at: indexPath) as? GifCollectionViewCell {
            #if KEYBOARD
            cell.overlayVisible = !cell.overlayVisible
            #endif
            mediaLinkCollectionViewCellDidToggleCopyButton(cell, selected: true)
        }
    }
        
    func categoriesCollectionViewControllerDidSwitchCategory(_ CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {}
}
