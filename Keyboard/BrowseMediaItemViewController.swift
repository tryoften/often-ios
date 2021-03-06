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
        collectionView?.registerClass(MediaItemsSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

    #if KEYBOARD
        navigationBar = KeyboardBrowseNavigationBar()
        navigationBar?.thumbnailImageButton.addTarget(self, action: #selector(BrowseMediaItemViewController.backButtonSelected), forControlEvents: .TouchUpInside)
        navigationBar?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar!)
    #else
        collectionView?.registerClass(MediaItemPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: MediaItemPageHeaderViewIdentifier)
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
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        showNavigationBar(false)
    #if KEYBOARD
        containerViewController?.resetPosition()
    #endif
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(false)

    #if KEYBOARD
        containerViewController?.resetPosition()
    #endif
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.setContentOffset(CGPointZero, animated: false)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .Black
            navigationBar.translucent = true
        }
    }

    class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let layout = CSStickyHeaderFlowLayout()

    #if KEYBOARD
        let topMargin = CGFloat(41.0)
    #else
        let topMargin = CGFloat(0.0)
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 118)
        layout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, UIScreen.mainScreen().bounds.size.height/4 * 3 - 4)
        layout.parallaxHeaderAlwaysOnTop = true
    #endif

        layout.disableStickyHeaders = false
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, cellHeight)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 0.0, 0.0)
        
        return layout
    }

    func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
    #if KEYBOARD
        navigationBar?.imageURL = imageURL
        navigationBar?.titleLabel.text = title
        navigationBar?.subtitleLabel.text = subtitle
    #else
        headerView?.imageURL = imageURL
        headerView?.titleLabel.text = title?.uppercaseString
        headerView?.subtitleLabel.text = subtitle?.uppercaseString
    #endif
    }

    func sectionHeaderTitleAtIndexPath(indexPath: NSIndexPath) -> String {
        return ""
    }

    func headerViewDidLoad() {
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        #if !(KEYBOARD)
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: MediaItemPageHeaderViewIdentifier, forIndexPath: indexPath) as? MediaItemPageHeaderView else {
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
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = sectionHeaderTitleAtIndexPath(indexPath).uppercaseString

                    return sectionView
            }
        }
        
        return UICollectionReusableView()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
    }

    // MARK: KeyboardBrowseNavigationDelegate
    func backButtonSelected() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: MediaItemGroupViewModelDelegate
    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
    }


#if KEYBOARD

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = containerViewController else {
            return
        }

        var frame = tabBarFrame
        guard var navBarFrame = navigationBar?.frame else {
            return
        }

        let tabBarHeight = CGRectGetHeight(frame)

        navBarFrame.origin.y =  fmax(fmin(KeyboardSearchBarHeight + y, KeyboardSearchBarHeight), 0)
        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight)

        navigationBarHideConstraint?.constant = navBarFrame.origin.y

        UIView.animateWithDuration(animated ? 0.1 : 0) {
            self.view.layoutSubviews()
            containerViewController.tabBar.frame = frame
        }
    }

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
#endif
}