//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardRecentsViewController: MediaItemsViewController {
    //TODO(kervs): Must remove after we can filter recents
    var panelViewBar: CategoriesPanelView

    init(viewModel: MediaItemsViewModel) {
        panelViewBar = CategoriesPanelView()
        panelViewBar.translatesAutoresizingMaskIntoConstraints = false

        let layout = KeyboardRecentsViewController.provideCollectionViewFlowLayout()
        super.init(collectionViewLayout: layout, collectionType: .Recents, viewModel: viewModel)

        panelViewBar.currentCategoryText = "all".uppercaseString
        panelViewBar.mediaItemTitleText = collectionType.rawValue.uppercaseString
        
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.contentInset = UIEdgeInsetsMake(-1, 0, SectionPickerViewHeight, 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "RecentlyUsedCellIdentifier")
        view.addSubview(panelViewBar)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = CSStickyHeaderFlowLayout()
        layout.disableStickyHeaders = false
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0

        return layout
    }

    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return viewModel.mediaItemGroupItemsForIndex(section).count
    }

    func setupLayout() {
        view.addConstraints([
            panelViewBar.al_bottom == view.al_bottom,
            panelViewBar.al_left == view.al_left,
            panelViewBar.al_right == view.al_right,
            panelViewBar.al_height == SectionPickerViewHeight
            ])
    }

    override func showEmptyStateViewForState(state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
        super.showEmptyStateViewForState(state, animated: animated, completion: completion)
        if let emptyStateView = emptyStateView {
            view.insertSubview(panelViewBar, aboveSubview: emptyStateView)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let cellWidthPadding: CGFloat = 20

        if indexPath.section == 0 {
            return CGSizeMake(screenWidth - cellWidthPadding, 115)
        }

        if screenHeight < screenWidth {
            return CGSizeMake(screenWidth - 20, 90)
        } else {
            return CGSizeMake(screenWidth - cellWidthPadding, 105)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell

        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecentlyUsedCellIdentifier", forIndexPath: indexPath)
            let lyricsHorizontalVC = provideRecentlyAddedLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC.group = viewModel.generateMediaItemGroups()[indexPath.section]
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            lyricsHorizontalVC.view.frame = cell.bounds
        } else {
            cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            guard let mediaItemCell = cell as? MediaItemCollectionViewCell else {
                return cell
            }

            mediaItemCell.type = .Metadata
            mediaItemCell.favoriteRibbon.hidden = !mediaItemCell.itemFavorited
        }

        return cell
    }

    override func showLoadingView() {

    }

    override func hideLoadingView() {
        
    }

    func togglePack() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: true)

        return animator
    }

}
