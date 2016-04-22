//
//  KeyboardFavoritesViewController.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesViewController: MediaItemsViewController {
    //TODO(kervs): Must remove after we can filter favorites
    var panelViewBar: CategoriesPanelView

    init(viewModel: MediaItemsViewModel) {
        panelViewBar = CategoriesPanelView()
        panelViewBar.translatesAutoresizingMaskIntoConstraints = false

        let layout = KeyboardFavoritesViewController.provideCollectionViewFlowLayout()
        super.init(collectionViewLayout: layout, collectionType: .Favorites, viewModel: viewModel)
        let toggleRecognizer = UITapGestureRecognizer(target: self, action: #selector(KeyboardFavoritesViewController.togglePack))

        panelViewBar.currentCategoryText = "all".uppercaseString
        panelViewBar.mediaItemTitleText = collectionType.rawValue.uppercaseString

        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.contentInset = UIEdgeInsetsMake(-1, 0, SectionPickerViewHeight, 0)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)

        view.addSubview(panelViewBar)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = CSStickyHeaderFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.disableStickyHeaders = false
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        return layout
    }

    func setupLayout() {
        view.addConstraints([
            panelViewBar.al_bottom == view.al_bottom,
            panelViewBar.al_left == view.al_left,
            panelViewBar.al_right == view.al_right,
            panelViewBar.al_height == SectionPickerViewHeight
            ])
    }

    func onOrientationChanged() {
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
    
    func togglePack() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let sectionView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)

        sectionView.backgroundColor = WhiteColor

        return sectionView
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let cellWidthPadding: CGFloat = 0
        return CGSizeMake(screenWidth - cellWidthPadding, 75)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        guard let mediaItemCell = cell as? MediaItemCollectionViewCell else {
            return cell
        }

        mediaItemCell.type = .NoMetadata
        mediaItemCell.style = .Cell
        mediaItemCell.favoriteRibbon.hidden = true

        return cell
    }

    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: true, resizePresentingViewController: false, lowerPresentingViewController: false)

        return animator
    }
}
