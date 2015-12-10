//
//  KeyboardMediaLinksAndFilterBarViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 11/6/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardMediaLinksAndFilterBarViewController: MediaLinksAndFilterBarViewController {
    var favoritesAndRecentsTabView: FavoritesAndRecentsTabView
    var searchResultsContainerView: UIView?
    var textProcessor: TextProcessingManager?
    var spacer: UIView
    
    init(collectionViewLayout layout: UICollectionViewLayout, viewModel: MediaLinksViewModel, textProcessor: TextProcessingManager?) {
        self.textProcessor = textProcessor
        
        favoritesAndRecentsTabView = FavoritesAndRecentsTabView()
        favoritesAndRecentsTabView.translatesAutoresizingMaskIntoConstraints = false
        favoritesAndRecentsTabView.userInteractionEnabled = true

        spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.backgroundColor = VeryLightGray

        super.init(collectionViewLayout: layout, viewModel: viewModel)
        
        favoritesAndRecentsTabView.delegate = self
        emptyStateView.userInteractionEnabled = true

        do {
            try viewModel.requestData()
        } catch UserProfileViewModelError.RequestDataFailed {
            print("Failed to request data")
        } catch let error {
            print("Failed to request data \(error)")
        }
        
        view.backgroundColor = VeryLightGray
        view.addSubview(favoritesAndRecentsTabView)
        view.addSubview(spacer)

        setupLayout()
        reloadCollectionView()

        collectionView?.contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight + 2, 0, 0, 0)
        emptyStateView.imageViewTopPadding = 0
        emptyStateView.updateEmptyStateContent(emptyStateView.userState)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
             collectionView.registerClass(UserProfileSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: UserProfileSectionViewReuseIdentifier)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        view.addConstraints([
            favoritesAndRecentsTabView.al_top == view.al_top,
            favoritesAndRecentsTabView.al_left == view.al_left,
            favoritesAndRecentsTabView.al_right == view.al_right,
            favoritesAndRecentsTabView.al_height == KeyboardSearchBarHeight,

            contentFilterTabView.al_top == view.al_top + KeyboardSearchBarHeight + 1,
            contentFilterTabView.al_left == view.al_left,
            contentFilterTabView.al_right == view.al_right,
            contentFilterTabView.al_height == KeyboardSearchBarHeight,

            spacer.al_top == favoritesAndRecentsTabView.al_bottom,
            spacer.al_left == view.al_left,
            spacer.al_right == view.al_right,
            spacer.al_bottom == contentFilterTabView.al_top,

            emptyStateView.al_top == favoritesAndRecentsTabView.al_bottom,
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_bottom == view.al_bottom
        ])
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            // Create Header
            if let sectionView: UserProfileSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                    withReuseIdentifier: UserProfileSectionViewReuseIdentifier, forIndexPath: indexPath) as? UserProfileSectionHeaderView {
                sectionView.trendingLabel.attributedText = sectionHeaderTitle()
                        return sectionView
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 36)
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



