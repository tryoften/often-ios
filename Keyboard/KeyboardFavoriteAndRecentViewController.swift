//
//  KeyboardFavoriteAndRecentViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/6/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardFavoriteAndRecentViewController: FavoritesAndRecentsBaseViewController {
    var favoriteAndRecentTabView: FavoriteAndRecentTabView
    var searchResultsContainerView: UIView?
    
    override init(collectionViewLayout layout: UICollectionViewLayout, viewModel: MediaLinksViewModel) {
        favoriteAndRecentTabView = FavoriteAndRecentTabView()
        favoriteAndRecentTabView.translatesAutoresizingMaskIntoConstraints = false
        favoriteAndRecentTabView.userInteractionEnabled = true
        
       super.init(collectionViewLayout: layout, viewModel: viewModel)
        
        favoriteAndRecentTabView.delegate = self
        emptyStateView.userInteractionEnabled = true
        
        view.backgroundColor = VeryLightGray
        view.addSubview(favoriteAndRecentTabView)

        setupLayout()
    }
    
    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 2 * KeyboardSearchBarHeight + 10, left: 10.0, bottom: 100.0, right: 10.0)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        view.addConstraints([
            favoriteAndRecentTabView.al_top == view.al_top,
            favoriteAndRecentTabView.al_left == view.al_left,
            favoriteAndRecentTabView.al_right == view.al_right,
            favoriteAndRecentTabView.al_height == KeyboardSearchBarHeight,
            
            contentFilterTabView.al_top == view.al_top + KeyboardSearchBarHeight + 1,
            contentFilterTabView.al_left == view.al_left,
            contentFilterTabView.al_right == view.al_right,
            contentFilterTabView.al_height == KeyboardSearchBarHeight,
            
            emptyStateView.al_top == contentFilterTabView.al_bottom,
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_bottom == view.al_bottom,
        
            ])
        
    }

    // MediaLinkCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
             return
        }
        
        UIPasteboard.generalPasteboard().string = result.getInsertableText()
    }


    
}


    
