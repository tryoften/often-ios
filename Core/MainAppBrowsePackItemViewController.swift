//
//  BrowsePackItemViewController.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
private let PackPageHeaderViewIdentifier = "packPageHeaderViewIdentifier"

class MainAppBrowsePackItemViewController: BaseBrowsePackItemViewController {
    var filterButton: UIButton
    
    override init(packId: String, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        let attributes: [String: AnyObject] = [
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


        super.init(packId: packId, viewModel: viewModel, textProcessor: textProcessor)
        collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.collectionView?.reloadData()
        }

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let topMargin = CGFloat(10.0)
        let layout = CSStickyHeaderFlowLayout()
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 90)
        layout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 270)
        layout.parallaxHeaderAlwaysOnTop = true
        layout.disableStickyHeaders = false
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, cellHeight)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 30.0, 0.0)

        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         loadPackData(.Simple)

        filterButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.filterButtonDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    func setLayout() {
        view.addConstraints([
            filterButton.al_centerX == view.al_centerX,
            filterButton.al_height == 30,
            filterButton.al_width == 94,
            filterButton.al_bottom == view.al_bottom - 23.5
            ])
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
    
    func filterButtonDidTap(sender: UIButton) {
        categoriesVC?.panelView.toggleDrawer()
    }

    override func setupCategoryCollectionViewController(panelStyle: CategoryPanelStyle) {
        super.setupCategoryCollectionViewController(panelStyle)

        guard let categoriesVC = categoriesVC else {
            return
        }

        view.insertSubview(filterButton, belowSubview: categoriesVC.view)
        setLayout()

    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
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
        
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                
                guard let categoryName = categoriesVC?.currentCategory else {
                    return sectionView
                }

                sectionView.leftText = "\(categoryName.name)".uppercaseString
                sectionView.rightText = "\(viewModel.filteredMediaItems.count)".uppercaseString

                return sectionView
            }
        }
        
        return UICollectionReusableView()
    }
}
