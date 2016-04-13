//
//  BaseBrowsePackViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class BaseBrowsePackItemViewController: BrowseMediaItemViewController {
    var packCollectionListener: Listener? = nil
    var categoriesVC: CategoryCollectionViewController? = nil
    var panelToggleListener: Listener?
    var HUDMaskView: UIView?
    var pack: PackMediaItem? {
        didSet {
            cellsAnimated = [:]
            delay(0.5) {
                self.collectionView?.reloadData()
            }
            headerViewDidLoad()
        }
    }
    var packId: String

    init(packId: String, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        self.packId = packId

        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        HUDMaskView?.frame = view.bounds

        guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
            return
        }

        layoutCategoryPanelView()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMediaItems.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 75)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MediaItemCollectionViewCell
        cell = parseMediaItemData(viewModel.filteredMediaItems, indexPath: indexPath, collectionView: collectionView) as MediaItemCollectionViewCell
        cell.style = .Cell
        cell.type = .NoMetadata

        animateCell(cell, indexPath: indexPath)

        return cell
    }

    func loadPackData(panelStyle: CategoryPanelStyle)  {
        if packId.isEmpty {
            return
        }

        self.pack = nil

        collectionView?.reloadData()

        viewModel.getPackWithOftenId(packId) { model in
            self.pack = model
            if self.categoriesVC == nil {
                self.setupCategoryCollectionViewController(panelStyle)
            } else {
                if let pack = self.pack {
                    self.categoriesVC?.handleCategories(pack.categories)
                }
            }
            self.layoutCategoryPanelView()
            self.populatePanelMetaData(self.pack?.name, itemCount: self.viewModel.filteredMediaItems.count, imageUrl: self.pack?.smallImageURL)
        }
    }


    func setupCategoryCollectionViewController(panelStyle: CategoryPanelStyle) {
        let categoriesVC = CategoryCollectionViewController(viewModel: viewModel, categories: pack!.categories)
        self.categoriesVC = categoriesVC
        self.categoriesVC?.panelView.style = panelStyle

        let togglePackSelector = #selector(BaseBrowsePackItemViewController.togglePack)
        let toggleRecognizer = UITapGestureRecognizer(target: self, action: togglePackSelector)
        let toggleDrawerSelector = #selector(BaseBrowsePackItemViewController.toggleCategoryViewController)
        let hudRecognizer = UITapGestureRecognizer(target: self, action: toggleDrawerSelector)

        categoriesVC.panelView.togglePackSelectedView.addGestureRecognizer(toggleRecognizer)
        categoriesVC.panelView.togglePackSelectedView.userInteractionEnabled = true


        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.hidden = true
        HUDMaskView?.userInteractionEnabled = true
        HUDMaskView?.addGestureRecognizer(hudRecognizer)

        view.addSubview(HUDMaskView!)
        view.addSubview(categoriesVC.view)
        addChildViewController(categoriesVC)

        panelToggleListener = categoriesVC.panelView.didToggle.on({ opening in
            guard let maskView = self.HUDMaskView else {
                return
            }

            if opening {
                maskView.alpha = 0.0
                maskView.hidden = false
            }

            UIView.animateWithDuration(0.3, animations: {
                maskView.alpha = opening ? 1.0 : 0.0
                }, completion: { done in
                    if !opening {
                        maskView.hidden = true
                    }
            })
        })
        
        layoutCategoryPanelView()
    }

    func layoutCategoryPanelView() {
        let height: CGFloat
        if categoriesVC?.panelView.style == .Detailed {
            height = CGRectGetHeight(view.frame) - SectionPickerViewHeight
        } else {
            height = CGRectGetHeight(view.frame)
        }
        if let panelView = categoriesVC?.view {
            panelView.frame = CGRectMake(CGRectGetMinX(view.frame),
                                         height,
                                         CGRectGetWidth(view.frame),
                                         SectionPickerViewOpenedHeight)
        }
    }

    func populatePanelMetaData(title: String?, itemCount: Int?, imageUrl: NSURL?) {
        guard let title = title, categoriesVC = categoriesVC else {
            return
        }
        
        categoriesVC.panelView.mediaItemTitleText = title

        if let itemCount = itemCount {
            categoriesVC.panelView.currentCategoryCount = String(itemCount)
        }

        if let imageURL = imageUrl {
            categoriesVC.panelView.mediaItemImageView.setImageWithAnimation(imageURL)
        }
        
    }

    func togglePack() {

    }
    
    func toggleCategoryViewController() {
        categoriesVC?.panelView.toggleDrawer()
    }

}
