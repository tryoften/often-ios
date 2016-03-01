//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesAndRecentsViewController: MediaItemsViewController {
    var categoriesVC: CategoryCollectionViewController? = nil
    var panelToggleListener: Listener?
    private var HUDMaskView: UIView?

    init(viewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType) {
        
        if collectionType == .Favorites {
            let layout = KeyboardFavoritesAndRecentsViewController.provideCollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10.0, right: 26)

            super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)

            collectionView?.backgroundColor = UIColor.clearColor()
            collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + -1, 0, 0, 22)
            setupAlphabeticalSidebar()
            setupCategoryCollectionViewController()
        } else {
            let layout = KeyboardFavoritesAndRecentsViewController.provideCollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0)
            super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)

            collectionView?.backgroundColor = UIColor.clearColor()
            collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + -1, 0, 80, 0)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutCategoryPanelView()
        HUDMaskView?.frame = view.bounds
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = CSStickyHeaderFlowLayout()
        layout.disableStickyHeaders = false
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0

        return layout
    }

    func setupCategoryCollectionViewController() {
        let categoriesVC = CategoryCollectionViewController()
        self.categoriesVC = categoriesVC

        HUDMaskView = UIView()
        HUDMaskView?.backgroundColor = UIColor.oftBlack74Color()
        HUDMaskView?.hidden = true

        view.addSubview(HUDMaskView!)
        view.addSubview(categoriesVC.view)
        addChildViewController(categoriesVC)



        panelToggleListener = categoriesVC.panelView.didToggle.on({ opening in
            guard let maskView = self.HUDMaskView else {
                return
            }

            if opening {
                maskView.alpha = 0.0
                maskView.hidden = false
            }

            UIView.animateWithDuration(0.3, animations: {
                maskView.alpha = opening ? 1.0 : 0.0
            }, completion: { done in
                if !opening {
                    maskView.hidden = true
                }
            })
        })

        layoutCategoryPanelView()
    }

    func layoutCategoryPanelView() {
        let superviewHeight: CGFloat = CGRectGetHeight(view.frame)
        if let panelView = categoriesVC?.view {
            panelView.frame = CGRectMake(CGRectGetMinX(view.frame),
                superviewHeight - SectionPickerViewHeight,
                CGRectGetWidth(view.frame),
                SectionPickerViewOpenedHeight)
        }
    }

    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let profileViewCenter = collectionView?.frame.midX, cells = collectionView?.visibleCells()
            where collectionType == .Favorites else {
                return
        }

        let point = CGPointMake(profileViewCenter, scrollView.contentOffset.y + KeyboardTabBarHeight + MediaItemsSectionHeaderHeight)
        for cell in cells {
            if cell.frame.contains(point) {
                if let indexPath = collectionView?.indexPathForCell(cell) {
                    if let sectionView = sectionHeaders[indexPath.section] {
                        sectionView.rightText = viewModel.rightSectionHeaderTitle(indexPath)
                    }
                }
            }
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        var cellWidthPadding: CGFloat = 20

        if collectionType == .Favorites && indexPath.section == 0 {
            return CGSizeMake(screenWidth - cellWidthPadding, 105)
        }

        if collectionType == .Favorites {
            cellWidthPadding = 46
            return CGSizeMake(screenWidth - cellWidthPadding, 75)
        }

        if screenHeight < screenWidth {
            return CGSizeMake(screenWidth - 20, 90)
        } else {
            return CGSizeMake(screenWidth - cellWidthPadding, 105)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        guard let mediaItemCell = cell as? MediaItemCollectionViewCell else {
            return cell
        }

        mediaItemCell.type = collectionType == .Recents ? .Metadata : .NoMetadata
        mediaItemCell.favoriteRibbon.hidden = collectionType == .Recents ? !mediaItemCell.itemFavorited : true

        return cell
    }

    override func showLoadingView() {

    }

    override func hideLoadingView() {
        
    }

}
