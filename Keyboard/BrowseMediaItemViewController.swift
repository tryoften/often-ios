//
//  BrowseMediaItemViewController.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

let MediaItemPageHeaderViewIdentifier = "MediaItemPageHeaderView"

class BrowseMediaItemViewController: MediaItemsCollectionBaseViewController,
    MediaItemGroupViewModelDelegate,
    CellAnimatable {
    class var cellHeight: CGFloat {
        return 105.0
    }

    var navigationBarHideConstraint: NSLayoutConstraint?
    var headerView: MediaItemPageHeaderView?
    var viewModel: BrowseViewModel
    var hudTimer: Timer?
#if KEYBOARD
    var navigationBar: KeyboardBrowseNavigationBar?
#endif

    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: BrowseMediaItemViewController.provideCollectionViewLayout())
        viewModel.delegate = self
        setupLayout()

        collectionView?.backgroundColor = VeryLightGray
        collectionView?.dataSource = self
        collectionView?.register(MediaItemsSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

    #if KEYBOARD
        navigationBar = KeyboardBrowseNavigationBar()
        navigationBar?.thumbnailImageButton.addTarget(self, action: #selector(BrowseMediaItemViewController.backButtonSelected), for: .touchUpInside)
        navigationBar?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar!)
    #else
        collectionView?.register(MediaItemPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: MediaItemPageHeaderViewIdentifier)
    #endif

        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        showNavigationBar(false)
    #if KEYBOARD
        containerViewController?.resetPosition()
    #endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        showNavigationBar(false)

    #if KEYBOARD
        containerViewController?.resetPosition()
    #endif
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.setContentOffset(CGPoint.zero, animated: false)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .black
            navigationBar.isTranslucent = true
        }
    }

    class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let screenWidth = UIScreen.main().bounds.size.width
        let layout = CSStickyHeaderFlowLayout()

    #if KEYBOARD
        let topMargin = CGFloat(41.0)
    #else
        let topMargin = CGFloat(0.0)
        layout.parallaxHeaderMinimumReferenceSize = CGSize(width: screenWidth, height: 110)
        layout.parallaxHeaderReferenceSize = CGSize(width: screenWidth, height: 295)
        layout.parallaxHeaderAlwaysOnTop = true
    #endif

        layout.disableStickyHeaders = false
        layout.itemSize = CGSize(width: UIScreen.main().bounds.width - 20, height: cellHeight)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 0.0, 0.0)
        
        return layout
    }

    func setupHeaderView(_ imageURL: URL?, title: String?, subtitle: String?) {
    #if KEYBOARD
        navigationBar?.imageURL = imageURL
        navigationBar?.titleLabel.text = title
        navigationBar?.subtitleLabel.text = subtitle
    #else
        headerView?.imageURL = imageURL
        headerView?.titleLabel.text = title?.uppercased()
        headerView?.subtitleLabel.text = subtitle?.uppercased()
    #endif
    }

    func sectionHeaderTitleAtIndexPath(_ indexPath: IndexPath) -> String {
        return ""
    }

    func headerViewDidLoad() {
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        #if !(KEYBOARD)
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                withReuseIdentifier: MediaItemPageHeaderViewIdentifier, for: indexPath) as? MediaItemPageHeaderView else {
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
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, for: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = sectionHeaderTitleAtIndexPath(indexPath).uppercased()

                    return sectionView
            }
        }
        
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main().bounds.width, height: 36)
    }

    // MARK: KeyboardBrowseNavigationDelegate
    func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: MediaItemGroupViewModelDelegate
    func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
    }


#if KEYBOARD
//
//    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
//        guard let containerViewController = containerViewController else {
//            return
//        }
//
//        var frame = tabBarFrame
//        guard var navBarFrame = navigationBar?.frame else {
//            return
//        }
//
//        let tabBarHeight = frame.height
//
//        navBarFrame.origin.y =  fmax(fmin(KeyboardSearchBarHeight + y, KeyboardSearchBarHeight), 0)
//        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight)
//
//        navigationBarHideConstraint?.constant = navBarFrame.origin.y
//
//        UIView.animate(withDuration: animated ? 0.1 : 0) {
//            self.view.layoutSubviews()
//            containerViewController.tabBar.frame = frame
//        }
//    }

    func setupLayout() {
        let topMargin = KeyboardSearchBarHeight
        guard let navigationBar = navigationBar else {
            return
        }

        navigationBarHideConstraint = navigationBar.al_top == view.al_top + topMargin

        view.addConstraints([
            navigationBarHideConstraint!,
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_height == 64
        ])
    }
#else
    func setupLayout() {

    }
    
    func showHud() {
        hudTimer?.invalidate()
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        hudTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: "hideHud", userInfo: nil, repeats: false)
    }

    func hideHud() {
        PKHUD.sharedHUD.hide(animated: true)
        hudTimer?.invalidate()
    }
#endif
}
