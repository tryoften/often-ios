//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesAndRecentsViewController: MediaLinksAndFilterBarViewController {
    var textProcessor: TextProcessingManager?


    init(viewModel: MediaLinksViewModel, collectionType: MediaLinksCollectionType) {
        super.init(collectionViewLayout: KeyboardMediaLinksAndFilterBarViewController.provideCollectionViewFlowLayout(), collectionType: collectionType, viewModel: viewModel)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + 2, 0, 0, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MediaLinkCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
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
}
