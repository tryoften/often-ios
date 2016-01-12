//
//  KeyboardMediaItemsAndFilterBarViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/6/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardMediaItemsAndFilterBarViewController: MediaItemsAndFilterBarViewController,
    FavoritesAndRecentsTabDelegate {
    var favoritesAndRecentsTabView: FavoritesAndRecentsTabView
    var searchResultsContainerView: UIView?
    var textProcessor: TextProcessingManager?

    init(viewModel: MediaItemsViewModel) {
        favoritesAndRecentsTabView = FavoritesAndRecentsTabView()
        favoritesAndRecentsTabView.translatesAutoresizingMaskIntoConstraints = false
        favoritesAndRecentsTabView.userInteractionEnabled = true

        super.init(collectionViewLayout: KeyboardMediaItemsAndFilterBarViewController.provideCollectionViewFlowLayout(), collectionType: .Favorites, viewModel: viewModel)
        
        favoritesAndRecentsTabView.delegate = self
        emptyStateView?.userInteractionEnabled = true
        
        view.backgroundColor = VeryLightGray
        view.addSubview(favoritesAndRecentsTabView)

        setupLayout()

        collectionView?.contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight + 2, 0, 0, 0)
        emptyStateView?.imageViewTopPadding = 0
        updateEmptyStateContent(viewModel.userState)
    }

    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 80.0, right: 10.0)
        return layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        view.addConstraints([
            favoritesAndRecentsTabView.al_top == view.al_top,
            favoritesAndRecentsTabView.al_left == view.al_left,
            favoritesAndRecentsTabView.al_right == view.al_right,
            favoritesAndRecentsTabView.al_height == KeyboardSearchBarHeight
        ])
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
    
    func userFavoritesTabSelected() {
        collectionType = .Favorites
        reloadData()
    }

    func userRecentsTabSelected() {
        collectionType = .Recents
        reloadData()
    }
}


