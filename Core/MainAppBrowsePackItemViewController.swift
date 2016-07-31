//
//  BrowsePackItemViewController.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Nuke
import NukeAnimatedImagePlugin

private let PackPageHeaderViewIdentifier = "packPageHeaderViewIdentifier"

class MainAppBrowsePackItemViewController: BaseBrowsePackItemViewController, FilterTabDelegate {
    var filterButton: UIButton
    
    override init(viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {
        filterButton = UIButton()
        
        super.init(viewModel: viewModel, textProcessor: textProcessor)
        
        packCollectionListener = viewModel.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.collectionView?.setContentOffset(CGPointZero, animated: true)
            self?.collectionView?.reloadData()
            self?.packViewModel.checkCurrentPackContents()
            self?.headerViewDidLoad()
        }
        
        collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)
        collectionView?.registerClass(MediaItemPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: MediaItemPageHeaderViewIdentifier)
        
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showHud"), userInfo: nil, repeats: false)
        
        view.addSubview(filterButton)
        setupFilterViews()
        setLayout()
    }
    
    deinit {
        packCollectionListener = nil
    }
    
    func setupFilterViews() {
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9)!,
            NSForegroundColorAttributeName: BlackColor
        ]
        let filterString = NSAttributedString(string: "filter by".uppercaseString, attributes: attributes)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = WhiteColor
        filterButton.layer.cornerRadius = 15
        filterButton.layer.shadowRadius = 2
        filterButton.layer.shadowOpacity = 0.2
        filterButton.layer.shadowColor = MediumLightGrey.CGColor
        filterButton.layer.shadowOffset = CGSizeMake(0, 2)
        filterButton.setAttributedTitle(filterString, forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        headerViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHud()
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
    
    func filterButtonDidTap(sender: UIButton) {
        toggleCategoryViewController()
    }
    
    override func headerViewDidLoad() {
        let imageURL: NSURL? = packViewModel.pack?.largeImageURL
        let subtitle: String? = packViewModel.pack?.description

        setupHeaderView(imageURL, title: packViewModel.pack?.name, subtitle: subtitle)
    }
    
    override func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
        guard let header = headerView as? PackPageHeaderView, let pack = packViewModel.pack else {
            return
        }
        self.hideHud()

        if let text = title {
            header.title = text
        }

        if let string = subtitle {
            header.subtitle = string
        }

        if let backgroundColor = pack.backgroundColor {
            header.packBackgroundColor.backgroundColor = backgroundColor
        }
        
        header.tabContainerView.mediaTypes = Array(pack.availableMediaType.keys)

        header.primaryButton.title = pack.callToActionText()
        header.primaryButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.primaryButtonTapped(_:)), forControlEvents: .TouchUpInside)
        header.primaryButton.packState = PacksService.defaultInstance.checkPack(pack) ? .Added : .NotAdded
        header.imageURL = imageURL
        header.tabContainerView.delegate = self

        let topRightButton = ShareBarButton()
        topRightButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.topRightButtonTapped(_:)), forControlEvents: .TouchUpInside)

        let positionedButtonView = UIView(frame: CGRectMake(0, 0, 100, 30))
        positionedButtonView.bounds = CGRectOffset(positionedButtonView.bounds, -10, 0)
        positionedButtonView.addSubview(topRightButton)

        let topRightBarButton = UIBarButtonItem(customView: positionedButtonView)
        navigationItem.rightBarButtonItem = topRightBarButton
    }
    
    func primaryButtonTapped(sender: UIButton) {
        guard let button = sender as? BrowsePackDownloadButton else {
            return
        }

        showHud()
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideHud", userInfo: nil, repeats: false)

        if let pack = packViewModel.pack {
            if PacksService.defaultInstance.checkPack(pack) {
                PacksService.defaultInstance.removePack(pack)
                button.packState = .NotAdded
            } else {
                PacksService.defaultInstance.addPack(pack)
                button.packState = .Added

                if packViewModel.showPushNotificationAlertForPack() {
                    hudTimer?.invalidate()
                    hideHud()

                    let AlertVC = PushNotificationAlertViewController()
                    AlertVC.transitioningDelegate = self
                    AlertVC.modalPresentationStyle = .Custom
                    presentViewController(AlertVC, animated: true, completion: nil)
                }
            }
        }
    }

    func topRightButtonTapped(sender: UIButton) {
        guard let pack = packViewModel.pack, name = pack.name, link = pack.shareLink else {
            return
        }

        let shareObjects = ["Yo check out this \(name) keyboard I found on Often! \(link)"]
        
        let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PackPageHeaderViewIdentifier, forIndexPath: indexPath) as? PackPageHeaderView else {
                return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
            }
            
            headerViewDidLoad()
            
            return headerView!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }

    func gifTabSelected() {
        collectionView?.setContentOffset(CGPointZero, animated: true)
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Gif) {
            packViewModel.typeFilter = .Gif
        }

    }
    
    func quotesTabSelected() {
        collectionView?.setContentOffset(CGPointZero, animated: true)
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Quote) {
            packViewModel.typeFilter = .Quote
        }

    }
    
    func imagesTabSelected() {
        // TODO: filter by image
        return
    }
}
