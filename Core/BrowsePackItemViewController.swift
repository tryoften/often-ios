//
//  BrowsePackItemViewController.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

private let PackPageHeaderViewIdentifier = "packPageHeaderViewIdentifier"

class BrowsePackItemViewController: BrowseMediaItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate {

    var pack: PackMediaItem? {
        didSet {
            cellsAnimated = [:]
            delay(0.5) {
                self.collectionView?.reloadData()
            }
            headerViewDidLoad()
            populatePanelMetaData(pack?.name, itemCount: pack?.items.count, imageUrl: pack?.smallImageURL)
        }
    }
    
    var packId: String
    
    init(packId: String, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        self.packId = packId
        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor
        
        #if KEYBOARD
            collectionView?.contentInset = UIEdgeInsetsMake(0, 0, SectionPickerViewHeight, 0)

            if let navigationBar = navigationBar {
                navigationBar.removeFromSuperview()

            }
        #else
            hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
            collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)
        #endif

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        #if KEYBOARD
            let topMargin = CGFloat(0)
            let layout = UICollectionViewFlowLayout()
        #else
            let topMargin = CGFloat(10.0)
            let layout = CSStickyHeaderFlowLayout()
            layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 90)
            layout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 250)
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = false
        #endif
        
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, cellHeight)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 30.0, 0.0)
        
        return layout
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        pack = nil
        collectionView?.reloadData()

        viewModel.getPackWithOftenId(packId) { model in
            self.pack = model
            
            #if !(KEYBOARD)
                self.hideHud()
            #endif
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryCollectionViewController()
        layoutCategoryPanelView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        HUDMaskView?.frame = view.bounds

        guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
            return
        }

        layoutCategoryPanelView()
    }


    override func headerViewDidLoad() {
        let imageURL: NSURL? = pack?.image_url
        let subtitle: String? = pack?.description
        
        setupHeaderView(imageURL, title: pack?.name, subtitle: subtitle)
    }

    override func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
        #if KEYBOARD
            navigationBar?.imageURL = imageURL
            navigationBar?.titleLabel.text = title
            navigationBar?.subtitleLabel.text = subtitle
        #else
            headerView?.imageURL = imageURL
            headerView?.titleLabel.text = title?.uppercaseString
            headerView?.subtitleLabel.text = subtitle
        #endif
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        #if !(KEYBOARD)
            if kind == CSStickyHeaderParallaxHeader {
                guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PackPageHeaderViewIdentifier, forIndexPath: indexPath) as? PackPageHeaderView else {
                    return UICollectionReusableView()
                }
                
                if headerView == nil {
                    headerView = cell
                    headerViewDidLoad()
                }
                
                return headerView!
            }
        #endif
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                sectionView.leftText = "inspiration".uppercaseString
                if let count = pack?.items_count {
                    sectionView.rightText = "\(count) quotes".uppercaseString
                }
                return sectionView
            }
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let itemsCount = pack?.items.count {
            return itemsCount
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 75)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MediaItemCollectionViewCell
        cell = parseMediaItemData(pack?.items, indexPath: indexPath, collectionView: collectionView) as MediaItemCollectionViewCell
        cell.style = .Cell
        cell.type = .NoMetadata

        animateCell(cell, indexPath: indexPath)

        return cell
    }


    override func togglePack() {
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksViewModel())
        packsVC.delegate = self
        packsVC.transitioningDelegate = self
        packsVC.modalPresentationStyle = .Custom
        presentViewController(packsVC, animated: true, completion: nil)
    }

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        self.pack = nil
        packId = pack.id

        collectionView?.reloadData()

        viewModel.getPackWithOftenId(packId) { model in
            self.pack = model

            #if !(KEYBOARD)
                self.hideHud()
            #endif
        }
    }

}
