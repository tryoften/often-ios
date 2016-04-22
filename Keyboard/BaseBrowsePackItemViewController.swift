//
//  BaseBrowsePackViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

let gifCellReuseIdentifier = "gifCellIdentifier"

class BaseBrowsePackItemViewController: BrowseMediaItemViewController, UICollectionViewDelegateFlowLayout {
    var packCollectionListener: Listener? = nil
    var categoriesVC: CategoryCollectionViewController? = nil
    var panelToggleListener: Listener?
    var HUDMaskView: UIView?
    var menuButton: AnimatedMenuButton?

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
    var panelStyle: CategoryPanelStyle
    
    init(packId: String, panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        self.packId = packId
        self.panelStyle = panelStyle
        
        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor
        
        collectionView?.registerClass(GifHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func groupAtIndex(index: Int) -> MediaItemGroup? {
        
        if index > viewModel.mediaItemGroups.count {
            return nil
        }
        
        return viewModel.groupAtIndex(index)
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
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.mediaItemGroups.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = groupAtIndex(section) else {
            return 0
        }
        
        switch group.type {
        case .Gif:
            return 1
        case .Quote:
            return group.items.count
        default:
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
        
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let group = groupAtIndex(indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch group.type {
        case .Gif:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(gifCellReuseIdentifier, forIndexPath: indexPath) as? GifHorizontalCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.group = group
            cell.textProcessor = textProcessor
            return cell
        case .Quote:
            let cell = parseMediaItemData(groupAtIndex(indexPath.section)?.items, indexPath: indexPath, collectionView: collectionView)
            cell.style = .Cell
            cell.type = .NoMetadata
            animateCell(cell, indexPath: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    

    
    func loadPackData()  {
        pack = nil
        collectionView?.reloadData()
        viewModel.fetchData()
    }
    
    
    func setupCategoryCollectionViewController() {
        let categoriesVC = CategoryCollectionViewController(viewModel: viewModel, categories: pack!.categories)
        self.categoriesVC = categoriesVC
        self.categoriesVC?.panelView.style = panelStyle
        
        setupHudView()
        
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
    
    func setupHudView() {
        
        if HUDMaskView != nil {
            return
        }
        
        let toggleDrawerSelector = #selector(BaseBrowsePackItemViewController.toggleCategoryViewController)
        let hudRecognizer = UITapGestureRecognizer(target: self, action: toggleDrawerSelector)
        
        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.hidden = true
        HUDMaskView?.userInteractionEnabled = true
        HUDMaskView?.addGestureRecognizer(hudRecognizer)
        
        view.addSubview(HUDMaskView!)
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
        
    }
    
    func togglePack() {
        
    }
    
    func toggleCategoryViewController() {
        categoriesVC?.panelView.toggleDrawer()
    }
    
    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        if let viewModel = viewModel as? PackItemViewModel, pack = viewModel.pack {
            self.pack = pack
        }
        
        if self.categoriesVC == nil {
            self.setupCategoryCollectionViewController()
        } else {
            if let pack = self.pack {
                self.categoriesVC?.handleCategories(pack.categories)
            }
        }
        self.layoutCategoryPanelView()
        self.populatePanelMetaData(self.pack?.name, itemCount: self.viewModel.getItemCount(), imageUrl: self.pack?.smallImageURL)
        
        if let menuButton = menuButton, imageURL = self.pack?.smallImageURL {
            menuButton.startButton.contentImageView.nk_setImageWith(imageURL)
        }
    }
}
