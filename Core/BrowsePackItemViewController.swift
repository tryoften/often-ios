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

    override func headerViewDidLoad() {
        let imageURL: NSURL? = pack?.largeImageURL
        let subtitle: String? = pack?.description
        
        setupHeaderView(imageURL, title: pack?.name, subtitle: subtitle)
    }

    override func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
        if let header = headerView as? PackPageHeaderView {
            var attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.7),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ]
            if let text = title {
                let attributedString = NSAttributedString(string: text.uppercaseString, attributes: attributes)
                header.titleLabel.attributedText = attributedString
            }
            
            if let price = pack?.price {
                attributes[NSFontAttributeName] = UIFont(name: "OpenSans-Semibold", size: 10.5)!
                attributes[NSKernAttributeName] = NSNumber(float: 1.0)
                let priceString = NSAttributedString(string: "$\(price)", attributes: attributes)
                header.priceButton.setAttributedTitle(priceString, forState: .Normal)
            }
            
            attributes[NSFontAttributeName] = UIFont(name: "OpenSans", size: 12)!
            attributes[NSKernAttributeName] = NSNumber(float: 0.6)
            
            if let string = subtitle {
                let subtitleString = NSAttributedString(string: string, attributes: attributes)
                header.subtitleLabel.attributedText = subtitleString
            }
            
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
