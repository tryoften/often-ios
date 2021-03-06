//
//  BrowsePackItemViewController.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

private let PackPageHeaderViewIdentifier = "packPageHeaderViewIdentifier"

class BrowsePackItemViewController: BrowseMediaItemViewController {

    var pack: PackMediaItem? {
        didSet {
            cellsAnimated = [:]
            delay(0.5) {
                self.collectionView?.reloadData()
            }
            headerViewDidLoad()
        #if KEYBOARD
            populatePanelMetaData(pack?.name, itemCount: pack?.items.count, imageUrl: pack?.smallImageURL)
        #endif
        }
    }
    
    var packId: String
    var filterButton: UIButton
    
    init(packId: String, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        self.packId = packId
        
        var attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9)!,
            NSForegroundColorAttributeName: BlackColor
        ]
        let filterString = NSAttributedString(string: "filter by".uppercaseString, attributes: attributes)
        
        filterButton = UIButton()
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = WhiteColor
        filterButton.layer.cornerRadius = 15
        filterButton.layer.shadowRadius = 2
        filterButton.layer.shadowOpacity = 0.2
        filterButton.layer.shadowColor = MediumLightGrey.CGColor
        filterButton.layer.shadowOffset = CGSizeMake(0, 2)
        filterButton.setAttributedTitle(filterString, forState: .Normal)
        
        
        super.init(viewModel: viewModel)
        self.textProcessor = textProcessor
       
        
        #if KEYBOARD
            collectionView?.contentInset = UIEdgeInsetsMake(0, 0, SectionPickerViewHeight, 0)

            if let navigationBar = navigationBar {
                navigationBar.removeFromSuperview()

            }
        #else
            guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
                return
            }
            view.insertSubview(filterButton, belowSubview: categoriesVC.view)
            setLayout()
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
            layout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 270)
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
        
        loadPackData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryCollectionViewController()
        layoutCategoryPanelView()
        
        filterButton.addTarget(self, action: #selector(BrowseMediaItemViewController.dismissCategoryViewController), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        HUDMaskView?.frame = view.bounds
        
        guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
            return
        }
        #if KEYBOARD
            categoriesVC.panelView.style = .Detailed
        #else
            categoriesVC.panelView.style = .Simple
        #endif
        
        layoutCategoryPanelView()
    }
    
    override func layoutCategoryPanelView() {
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

    override func headerViewDidLoad() {
        let imageURL: NSURL? = pack?.largeImageURL
        let subtitle: String? = pack?.description
        
        setupHeaderView(imageURL, title: pack?.name, subtitle: subtitle)
    }

    override func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
        if let header = headerView as? PackPageHeaderView, let pack = pack {
            if let text = title {
                header.title = text
            }

            if let string = subtitle {
                header.subtitle = string
            }

            header.sampleButton.hidden = !pack.premium
            header.primaryButton.title = pack.callToActionText()
            header.imageURL = imageURL
        }
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
                
//                guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
//                    return UICollectionReusableView()
//                }
                
//                if let category = categoriesVC.panelView.currentCategoryText, count = categoriesVC.panelView.currentCategoryCount {
                    sectionView.leftText = "inspiration".uppercaseString
                    sectionView.rightText = "count".uppercaseString
//                }
                
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
    
    func setLayout() {
        
        view.addConstraints([
            filterButton.al_centerX == view.al_centerX,
            filterButton.al_height == 30,
            filterButton.al_width == 94,
            filterButton.al_bottom == view.al_bottom - 23.5
        ])
    }


    func loadPackData()  {
        self.pack = nil

        collectionView?.reloadData()

        viewModel.getPackWithOftenId(packId) { model in
            self.pack = model

            #if !(KEYBOARD)
                self.hideHud()
            #endif
        }
    }
}
