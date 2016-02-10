//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesAndRecentsViewController: MediaItemsViewController {
    init(viewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType) {
        
        if collectionType == .Favorites {
            let layout = KeyboardFavoritesAndRecentsViewController.provideCollectionViewFlowLayout()
            super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)

            collectionView?.backgroundColor = UIColor.clearColor()
            collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + -1, 0, 0, 0)
            setupAlphabeticalSidebar()
        } else {
            let layout = KeyboardFavoritesAndRecentsViewController.provideCollectionViewFlowLayout()
            super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)

            collectionView?.backgroundColor = UIColor.clearColor()
            collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + -1, 0, 80, 0)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0)
        return layout
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
                        sectionView.rightText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: false, indexPath: indexPath)
                    }
                }
            }
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if screenHeight < screenWidth {
            return CGSizeMake(screenWidth - 20, 90)
        } else {
            return CGSizeMake(screenWidth - 20, 105)
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
