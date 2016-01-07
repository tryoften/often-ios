//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesAndRecentsViewController: MediaItemsAndFilterBarViewController {
    var textProcessor: TextProcessingManager?


    init(viewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType) {
        let layout = KeyboardMediaItemsAndFilterBarViewController.provideCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 80.0, right: 10.0)
        super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + 2, 0, 0, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MediaItemCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }

        if selected {
            self.textProcessor?.defaultProxy.insertText(result.getInsertableText())
        } else {
            for var i = 0, len = result.getInsertableText().utf16.count; i < len; i++ {
                textProcessor?.defaultProxy.deleteBackward()
            }
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType)
                    sectionView.topSeperator.hidden = true
                    return sectionView
            }
        }

        return UICollectionReusableView()
    }
}
