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
    
    override init(packId: String, panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
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


        super.init(packId: packId, panelStyle: panelStyle, viewModel: viewModel, textProcessor: textProcessor)
        collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.collectionView?.setContentOffset(CGPointZero, animated: true)
            self.collectionView?.reloadData()
            self.hideHud()
        }

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        headerViewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadPackData()
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
        if let header = headerView as? PackPageHeaderView, let pack = pack {
            if let text = title {
                header.title = text
            }

            if let string = subtitle {
                header.subtitle = string
            }

            header.sampleButton.hidden = !pack.premium
            header.primaryButton.title = pack.callToActionText()
            header.primaryButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.primaryButtonTapped(_:)), forControlEvents: .TouchUpInside)
            header.primaryButton.packState = PacksService.defaultInstance.checkPack(pack) ? .Added : .NotAdded
            header.imageURL = imageURL
        }
    }
    
    func primaryButtonTapped(sender: UIButton) {
        guard let button = sender as? BrowsePackDownloadButton else {
            return
        }
        
        if let pack = pack {
            if PacksService.defaultInstance.checkPack(pack) {
                PacksService.defaultInstance.removePack(pack)
                button.packState = .NotAdded
            } else {
                PacksService.defaultInstance.addPack(pack)
                button.packState = .Added
            }
        }
    }
    
    func filterButtonDidTap(sender: UIButton) {
        categoriesVC?.panelView.toggleDrawer()
    }

    override func setupCategoryCollectionViewController() {
        super.setupCategoryCollectionViewController()

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
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsetsMake(10, 0, 0, 0)
        } else if section == viewModel.mediaItemGroups.count - 1 {
            return UIEdgeInsetsMake(0, 0, 60, 0)
        } else {
            return UIEdgeInsetsZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        guard let group = groupAtIndex(indexPath.section) else {
            return CGSizeZero
        }
        
        switch group.type {
        case .Gif:
            let itemsCount = group.items.count
            var height: CGFloat
            
            if itemsCount == 0 {
                height = 0
            } else if itemsCount < 3 {
                height = 103
            } else {
                height = 216
            }
            
            return CGSizeMake(UIScreen.mainScreen().bounds.width, height)
        case .Quote:
            return CGSizeMake(UIScreen.mainScreen().bounds.width, 75)
        default:
            return CGSizeZero
        }
    }
    
    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: true, resizePresentingViewController: false, lowerPresentingViewController: false)
        
        return animator
    }
}
