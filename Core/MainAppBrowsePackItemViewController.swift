//
//  BrowsePackItemViewController.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Material
private let PackPageHeaderViewIdentifier = "packPageHeaderViewIdentifier"

class MainAppBrowsePackItemViewController: BaseBrowsePackItemViewController {

    override init(panelStyle: CategoryPanelStyle, viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {

        super.init(panelStyle: panelStyle, viewModel: viewModel, textProcessor: textProcessor)
        collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)

        packCollectionListener = viewModel.didChangeMediaItems.on { items in
            self.collectionView?.setContentOffset(CGPointZero, animated: true)
            self.collectionView?.reloadData()
            self.hideHud()
            self.headerViewDidLoad()
        }
        
        menuView.menu.views?.removeLast()
        menuView.menu.baseViewSize = CGSizeMake(50, 50)

        collectionView?.registerClass(MediaItemPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: MediaItemPageHeaderViewIdentifier)

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        headerViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        menuView.menu.itemViewSize = CGSizeMake(40, 40)
        MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: 20, right: 18)
        MaterialLayout.size(view, child: menuView, width: 50, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadPackData()
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
    
    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: true)
        
        return animator
    }
}
