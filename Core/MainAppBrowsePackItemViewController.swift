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
            self?.collectionView?.setContentOffset(CGPoint.zero, animated: true)
            self?.collectionView?.reloadData()
            self?.packViewModel.checkCurrentPackContents()
            self?.headerViewDidLoad()
        }
        
        collectionView?.register(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)
        collectionView?.register(MediaItemPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: MediaItemPageHeaderViewIdentifier)
        
        hudTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector("showHud"), userInfo: nil, repeats: false)
        
        view.addSubview(filterButton)
        setupFilterViews()
        setLayout()
    }
    
    deinit {
        packCollectionListener = nil
    }
    
    func setupFilterViews() {
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(value: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9)!,
            NSForegroundColorAttributeName: BlackColor!
        ]
        let filterString = AttributedString(string: "filter by".uppercased(), attributes: attributes)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = WhiteColor
        filterButton.layer.cornerRadius = 15
        filterButton.layer.shadowRadius = 2
        filterButton.layer.shadowOpacity = 0.2
        filterButton.layer.shadowColor = MediumLightGrey?.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.setAttributedTitle(filterString, for: UIControlState())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupImageManager() {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()
        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageManager()
        showHud()
        loadPackData()
        
        filterButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.filterButtonDidTap(_:)), for: .touchUpInside)
    }
    
    func setLayout() {
        view.addConstraints([
            filterButton.al_centerX == view.al_centerX,
            filterButton.al_height == 30,
            filterButton.al_width == 94,
            filterButton.al_bottom == view.al_bottom - 23.5
            ])
    }
    
    func filterButtonDidTap(_ sender: UIButton) {
        toggleCategoryViewController()
    }
    
    override func headerViewDidLoad() {
        let imageURL: URL? = packViewModel.pack?.largeImageURL
        let subtitle: String? = packViewModel.pack?.description
        
        setupHeaderView(imageURL, title: packViewModel.pack?.name, subtitle: subtitle)
    }
    
    override func setupHeaderView(_ imageURL: URL?, title: String?, subtitle: String?) {
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

        header.primaryButton.title = pack.callToActionText()
        header.primaryButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.primaryButtonTapped(_:)), for: .touchUpInside)
        header.primaryButton.packState = PacksService.defaultInstance.checkPack(pack) ? .added : .notAdded
        header.imageURL = imageURL
        header.tabContainerView.delegate = self

        let topRightButton = ShareBarButton()
        topRightButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.topRightButtonTapped(_:)), for: .touchUpInside)

        let positionedButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        positionedButtonView.bounds = positionedButtonView.bounds.offsetBy(dx: -10, dy: 0)
        positionedButtonView.addSubview(topRightButton)

        let topRightBarButton = UIBarButtonItem(customView: positionedButtonView)
        navigationItem.rightBarButtonItem = topRightBarButton

        updateFilterBar(true)
    }
    
    func primaryButtonTapped(_ sender: UIButton) {
        guard let button = sender as? BrowsePackDownloadButton else {
            return
        }

        showHud()
        hudTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: "hideHud", userInfo: nil, repeats: false)

        if let pack = packViewModel.pack {
            if PacksService.defaultInstance.checkPack(pack) {
                PacksService.defaultInstance.removePack(pack)
                button.packState = .notAdded
            } else {
                PacksService.defaultInstance.addPack(pack)
                button.packState = .added

                if packViewModel.showPushNotificationAlertForPack() {
                    hudTimer?.invalidate()
                    hideHud()

                    let AlertVC = PushNotificationAlertViewController()
                    AlertVC.transitioningDelegate = self
                    AlertVC.modalPresentationStyle = .custom
                    present(AlertVC, animated: true, completion: nil)
                }
            }
        }
    }

    func topRightButtonTapped(_ sender: UIButton) {
        guard let pack = packViewModel.pack, name = pack.name, link = pack.shareLink else  {
            return
        }

        let shareObjects = ["Yo check out this \(name) keyboard I found on Often! \(link)"]
        
        let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        present(activityVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PackPageHeaderViewIdentifier, for: indexPath) as? PackPageHeaderView else {
                return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
            }
            
            headerViewDidLoad()
            
            return headerView!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
    
    func leftTabSelected() {
        collectionView?.setContentOffset(CGPoint.zero, animated: true)
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Gif) {
            packViewModel.typeFilter = .Gif
        }
    }
    
    func rightTabSelected() {
        collectionView?.setContentOffset(CGPoint.zero, animated: true)
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Quote) {
            packViewModel.typeFilter = .Quote
        }
    }
    
    func updateFilterBar(_ withAnimation: Bool) {
        guard let headerView = headerView as? PackPageHeaderView else {
            return
        }
        
        if !packViewModel.doesCurrentPackContainTypeForCategory(.Quote) {
            headerView.tabContainerView.disableButtonFor(.Quote, withAnimation: withAnimation)
        }
        
        if !packViewModel.doesCurrentPackContainTypeForCategory(.Gif) {
            headerView.tabContainerView.disableButtonFor(.Gif, withAnimation: withAnimation)
            
        }
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Gif) && packViewModel.doesCurrentPackContainTypeForCategory(.Quote) {
            headerView.tabContainerView.resetTabButtons()
        }
    }
    
    override func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)
        
        updateFilterBar(false)
    }
}
