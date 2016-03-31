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
        }
    }
    
    var packId: String
    
    init(packId: String, viewModel: BrowseViewModel) {
        self.packId = packId
        super.init(viewModel: viewModel)
        
        #if KEYBOARD
            collectionView?.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        #else
            hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
        #endif
        
        collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        #if KEYBOARD
            let topMargin = CGFloat(115.0)
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
        
        pack = nil
        collectionView?.reloadData()
        
        viewModel.getPackWithOftenId(packId) { model in
            self.pack = model
            
            #if !(KEYBOARD)
                self.hideHud()
            #endif
        }
        
    }
    
    override func headerViewDidLoad() {
        let imageURL: NSURL? = pack?.image_url
        let subtitle: String? = pack?.description
        
        setupHeaderView(imageURL, title: pack?.name, subtitle: subtitle)
    }
    
    override func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
        if let header = headerView as? PackPageHeaderView {
            var attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.5),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ]
            if let text = title {
                let attributedString = NSAttributedString(string: text.uppercaseString, attributes: attributes)
                header.titleLabel.attributedText = attributedString
            }
            
            if let price = pack?.price {
                attributes[NSFontAttributeName] = UIFont(name: "OpenSans-Semibold", size: 10.5)!
                let priceString = NSAttributedString(string: "$0.99".uppercaseString, attributes: attributes)
                header.priceButton.titleLabel?.attributedText = priceString
            }
            
            attributes[NSFontAttributeName] = UIFont(name: "OpenSans-Semibold", size: 12)!
            
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
    
}
