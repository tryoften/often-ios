//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesAndRecentsViewController: MediaItemsViewController {
    var textProcessor: TextProcessingManager?
    var headerView: ShareOftenMessageHeaderView?

    init(viewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType) {
        
        if collectionType == .Favorites {
            let layout = KeyboardFavoritesAndRecentsViewController.provideCollectionViewLayout()
            super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)

            collectionView?.backgroundColor = UIColor.clearColor()
            collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + 2, 0, 0, 0)
            collectionView?.registerClass(ShareOftenMessageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "messageHeader")
        } else {
            let layout = KeyboardMediaItemsAndFilterBarViewController.provideCollectionViewFlowLayout()
            super.init(collectionViewLayout: layout, collectionType: collectionType, viewModel: viewModel)
        }
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + 2, 0, 80, 0)
        
        // take this out when we actually count how many times a user has shared a message
        SessionManagerFlags.defaultManagerFlags.userMessageCount = 0;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(collectionType == .Favorites) {
            if(SessionManagerFlags.defaultManagerFlags.userMessageCount % 10 == 0 && headerView?.hidden == true) {
                headerView?.hidden = false
                collectionView?.setCollectionViewLayout(self.dynamicType.provideCollectionViewLayout(), animated: true)
                collectionView?.contentOffset = CGPointMake(0, -(KeyboardSearchBarHeight + 2))
            }
            // take this out when we actually count how many times a user has shared a message
            SessionManagerFlags.defaultManagerFlags.userMessageCount++
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emptyStateView?.hidden = true
    }
    
    class func provideCollectionViewLayout(headerHeight: CGFloat = 150) -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let layout = CSStickyHeaderFlowLayout()
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, headerHeight)
        layout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, headerHeight)
        layout.parallaxHeaderAlwaysOnTop = false
        layout.disableStickyHeaders = true
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 10.0)
        return layout
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

        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "messageHeader", forIndexPath: indexPath) as? ShareOftenMessageHeaderView else {
                    return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
                headerView?.closeButton.addTarget(self, action: "closeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                headerView?.primaryButton.addTarget(self, action: "shareButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                    sectionView.leftText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: true, indexPath: indexPath)
                    sectionView.rightText = viewModel.sectionHeaderTitleForCollectionType(collectionType, isLeft: false, indexPath: indexPath)
                    sectionHeaders[indexPath.section] = sectionView
                    return sectionView
            }
        }

        return UICollectionReusableView()
    }

    override func timeoutLoader() {
        loaderView.hidden = true
        if collectionType == .Favorites {
            updateEmptyStateContent(.NoFavorites)
        } else if collectionType == .Recents {
            updateEmptyStateContent(.NoRecents)
        } else {
            updateEmptyStateContent(.NonEmpty)
        }

    }
    
    func closeButtonTapped(sender: UIButton!) {
        headerView?.hidden = true
        collectionView?.setCollectionViewLayout(self.dynamicType.provideCollectionViewLayout(0), animated: true)
    }
    
    func shareButtonTapped(sender: UIButton!) {
        self.textProcessor?.defaultProxy.insertText(ShareMessage)
    }

}
