//
//  BrowsePackContainerViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 3/23/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//2

import UIKit

let horizontalCellReuseIdentifer = "HorizontalCellReuseIdentifier"

class BrowsePackCollectionViewController: MediaItemsViewController, ConnectivityObservable, CategoryPanelControllable {
    var headerView: BrowsePackHeaderView?
    var sectionHeaderView: BrowsePackSectionHeaderView?
    var categorySelectionPanel: BrowseCategoryPanelViewController?
    var packServiceListener: Listener?
    var isNetworkReachable: Bool = true
    var reachabilityView: DropDownMessageView
    var screenWidth: CGFloat
    var menuOpen: Bool = false
    let interactor = CategoryPanelInteractor()
    
    static var headerSize: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            return 270.0
        }
        return 230.0
    }
    
    init(viewModel: PacksViewModel) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        reachabilityView = DropDownMessageView()
        reachabilityView.text = "no internet connection".uppercaseString
        reachabilityView.frame = CGRectMake(0, -35, screenWidth, 35)
        
        super.init(collectionViewLayout: BrowsePackCollectionViewController.getLayout(),
                   collectionType: .Packs,
                   viewModel: viewModel)

        let brandLabel = UILabel(frame: CGRectMake(0, 0, 64, 20))
        brandLabel.textAlignment = .Center
        brandLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!,
                               letterSpacing: 1.0,
                               color: UIColor.oftBlackColor(),
                               text: "Often")

        navigationItem.titleView = brandLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: StyleKit.imageOfMainAppMenu(frame: CGRectMake(0, 0, 35, 35),
                                                    color: UIColor.oftBlack74Color(), scale: 0.5).imageWithRenderingMode(.AlwaysOriginal),
                                                    style: .Plain,
                                                    target: self,
                                                    action: #selector(BrowsePackCollectionViewController.categoryMenuButtonTapped))
        
        packServiceListener = PacksService.defaultInstance.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.collectionView?.reloadData()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrowsePackCollectionViewController.didSelectBrowseCategory(_:)), name: "didSelectBrowseCategory", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrowsePackCollectionViewController.didClickPackLink(_:)), name: "didClickPackLink", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrowsePackCollectionViewController.displayUserProfile(_:)), name: "displayUserProfile", object: nil)
        
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: horizontalCellReuseIdentifer)
        view.addSubview(reachabilityView)
        startMonitoring()
    }
    
    func didClickPackLink(notification: NSNotification) {
        if let id = notification.userInfo!["packid"] as? String {
            let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
            navigationController?.navigationBar.hidden = false
            navigationController?.pushViewController(packVC, animated: true)
        }
    }

    func displayUserProfile(notification: NSNotification) {
        guard let id = notification.userInfo?["userId"] as? String else {
            return
        }

        let packsService = PacksService(userId: id)
        let profileVC = UserProfileViewController(viewModel: packsService)
        navigationController?.pushViewController(profileVC, animated: true)
        tabBarController?.selectedIndex = 0
    }
    
    func didSelectBrowseCategory(notification: NSNotification) {
        if let section = notification.userInfo!["section"] as? Int {
            let scrollHeight: CGFloat = CGFloat((30 + 210 + 24) * section)
            let topOfHeader = CGPointMake(0, self.dynamicType.headerSize + scrollHeight)
            collectionView?.setContentOffset(topOfHeader, animated:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(BrowsePackHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(BrowsePackSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
        }
    }

    class func getLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 0)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, headerSize)
        flowLayout.itemSize = CGSizeMake(screenWidth, 210) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = false
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 6.0
        flowLayout.sectionInset = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        return flowLayout
    }

    deinit {
        packServiceListener = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.navigationBar.tintColor = WhiteColor
        navigationController?.navigationBar.barTintColor = MainBackgroundColor
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateReachabilityView()
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as? BrowsePackHeaderView else {
                return UICollectionViewCell()
            }
            
            if headerView == nil {
                headerView = cell
                addChildViewController(cell.browsePicker)
            }
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as? BrowsePackSectionHeaderView else {
                return UICollectionViewCell()
            }
            
            sectionHeaderView = cell
            if let sectionTitle = viewModel.mediaItemGroups[indexPath.section].title {
                sectionHeaderView?.leftLabelText = sectionTitle
            }
            
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.mediaItemGroups.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
        
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(horizontalCellReuseIdentifer, forIndexPath: indexPath)
        resetCell(cell)
        let horizontalVC = PacksHorizontalViewController()
        addChildViewController(horizontalVC)
        horizontalVC.group = viewModel.mediaItemGroupItemsForIndex(indexPath.section)
        cell.contentView.addSubview(horizontalVC.view)
        horizontalVC.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        horizontalVC.view.frame = cell.bounds
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(screenWidth, 210)
    }
    
    func resetCell(cell: UICollectionViewCell) {
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0 as CGFloat
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0 as CGFloat
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 30.0)
        
    }
    
    // MARK: CategoryPanelControllable
    func categoryMenuButtonTapped() {
        if menuOpen {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: StyleKit.imageOfMainAppMenu(frame: CGRectMake(0, 0, 35, 35),
                                                    color: UIColor.oftBlack74Color(), scale: 0.5).imageWithRenderingMode(.AlwaysOriginal),
                                                    style: .Plain,
                                                    target: self,
                                                    action: #selector(BrowsePackCollectionViewController.categoryMenuButtonTapped))
            menuOpen = false
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: StyleKit.imageOfClose(frame: CGRectMake(0, 0, 35, 35),
                                                    color: UIColor.oftBlack74Color(), scale: 0.4).imageWithRenderingMode(.AlwaysOriginal),
                                                    style: .Plain,
                                                    target: self,
                                                    action: #selector(BrowsePackCollectionViewController.categoryMenuButtonTapped))
            menuOpen = true
            if let viewModel = viewModel as? PacksViewModel {
                let panelViewController = BrowseCategoryPanelViewController(viewModel: viewModel)
                panelViewController.delegate = self
                presentViewControllerWithCustomTransitionAnimator(panelViewController, direction: .Right, duration: 0.25)
            }
        }
    }
    
    override func presentViewControllerWithCustomTransitionAnimator(presentingController: UIViewController, direction: FadeInTransitionDirection, duration: NSTimeInterval) {
        if let presentingController = presentingController as? BrowseCategoryPanelViewController {
            transitionAnimator = BrowseCategoryPanelAnimator(presenting: true, duration: duration)
            presentingController.transitioningDelegate = self
            presentingController.interactor = interactor
            presentingController.modalPresentationStyle = .Custom
            presentViewController(presentingController, animated: true, completion: nil)
        }
    }
    
    override func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BrowseCategoryPanelAnimator(presenting: false)
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    //MARK: ConnectivityObservable
    func updateReachabilityView() {
        if isNetworkReachable {
            UIView.animateWithDuration(0.3, animations: {
                self.reachabilityView.frame = CGRectMake(0, -35, self.screenWidth, 35)
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.reachabilityView.frame = CGRectMake(0, 0, self.screenWidth, 35)
            })
        }
    }
}


