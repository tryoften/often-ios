//
//  KeyboardFavoritesAndRecentsViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardFavoritesAndRecentsViewController: MediaItemsViewController {
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
        collectionView?.contentInset = UIEdgeInsetsMake(KeyboardSearchBarHeight + -1, 0, 80, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showShareOftenHeaderIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emptyStateView?.hidden = true
    }
    
    class func provideCollectionViewLayout(var headerHeight: CGFloat = 150) -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let layout = CSStickyHeaderFlowLayout()
        var topMargin: CGFloat = 0.0

    #if KEYBOARD
        topMargin = 10.0
    #endif

        let count = SessionManagerFlags.defaultManagerFlags.userMessageCount
        if count % 10 != 0 {
            headerHeight = 0.0
        }

        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, headerHeight)
        layout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, headerHeight)
        layout.parallaxHeaderAlwaysOnTop = false
        layout.disableStickyHeaders = true
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: topMargin, left: 10.0, bottom: 10.0, right: 10.0)

        return layout
    }

    func showShareOftenHeaderIfNeeded() {
        if collectionType == .Favorites {
            let count = SessionManagerFlags.defaultManagerFlags.userMessageCount
            if count % 10 == 0 && headerView?.hidden == true {
                headerView?.hidden = false
                collectionView?.setCollectionViewLayout(self.dynamicType.provideCollectionViewLayout(), animated: true)
                collectionView?.contentOffset = CGPointMake(0, -(KeyboardSearchBarHeight + 2))
            } else {
                headerView?.hidden = true
            }
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        guard let mediaItemCell = cell as? MediaItemCollectionViewCell else {
            return cell
        }

        mediaItemCell.type = collectionType == .Recents ? .Metadata : .NoMetadata
        return cell
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
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }

    override func timeoutLoader() {
        loaderView?.hidden = true
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
