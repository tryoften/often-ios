//
//  KeyboardMediaItemsAndFilterBarViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/6/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardMediaItemsAndFilterBarViewController: MediaItemsViewController,
    FavoritesAndRecentsTabDelegate {
    var favoritesAndRecentsTabView: FavoritesAndRecentsTabView
    var searchResultsContainerView: UIView?

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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10.0, bottom: 80.0, right: 10.0)
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

    func userFavoritesTabSelected() {
        collectionType = .Favorites
        reloadData(false)
    }

    func userRecentsTabSelected() {
        collectionType = .Recents
        reloadData(false)
    }
}