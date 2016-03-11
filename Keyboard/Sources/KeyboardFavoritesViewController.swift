//
//  KeyboardFavoritesViewController.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesViewController: MediaItemsViewController {
    var categoriesVC: CategoryCollectionViewController? = nil
    var panelToggleListener: Listener?

    private var HUDMaskView: UIView?

    init(viewModel: MediaItemsViewModel) {
        let layout = KeyboardFavoritesViewController.provideCollectionViewFlowLayout()
        super.init(collectionViewLayout: layout, collectionType: .Favorites, viewModel: viewModel)

        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + -1, 0, 0, 22)


        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = CSStickyHeaderFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10.0, right: 26)
        layout.disableStickyHeaders = false
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0

        return layout
    }

    func onOrientationChanged() {
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAlphabeticalSidebar()
        setupCategoryCollectionViewController()
        layoutCategoryPanelView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        HUDMaskView?.frame = view.bounds

        guard let categoriesVC = categoriesVC where !categoriesVC.panelView.isOpened else {
            return
        }

        layoutCategoryPanelView()
    }

    override func showEmptyStateViewForState(state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let profileViewCenter = collectionView?.frame.midX, cells = collectionView?.visibleCells() else {
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
        let cellWidthPadding: CGFloat = 46
        return CGSizeMake(screenWidth - cellWidthPadding, 75)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        guard let mediaItemCell = cell as? MediaItemCollectionViewCell else {
            return cell
        }

        mediaItemCell.type = .NoMetadata
        mediaItemCell.favoriteRibbon.hidden = true

        return cell
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
}
