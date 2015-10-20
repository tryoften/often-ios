//
//  UserFavoritesCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 9/4/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let userFavoritesReuseIdentifier = "favoritesCell"

class UserFavoritesCollectionViewController: UICollectionViewController, EmptySetDelegate {
    var emptyStateViewLayoutConstraint: NSLayoutConstraint?
    var emptyStateView: EmptySetView
    
    init() {
        emptyStateView = EmptySetView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.updateEmptyStateContent(.NoKeyboard)
        
        super.init(collectionViewLayout: UserFavoritesCollectionViewController.provideCollectionViewLayout())
        
        view.addSubview(emptyStateView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.scrollEnabled = false
            collectionView.backgroundColor = WhiteColor
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: userFavoritesReuseIdentifier)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(screenWidth, 118)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        return flowLayout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numItems = 7
        
        if numItems == 0 {
            updateEmptySetVisible(true)
            return 0
        } else {
            updateEmptySetVisible(false)
            return numItems
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(userFavoritesReuseIdentifier, forIndexPath: indexPath) as! SearchResultsCollectionViewCell
    
        cell.sourceLogoView.image = UIImage(named: "complex")
        cell.headerLabel.text = "@ComplexMag"
        cell.mainTextLabel.text = "In the heat of the battle, @Drake dropped some new flames in his new track, Charged Up, via..."
        cell.leftSupplementLabel.text = "3.1K Retweets"
        cell.centerSupplementLabel.text = "4.5K Favorites"
        cell.rightSupplementLabel.text = "July 25, 2015"
        cell.rightCornerImageView.image = UIImage(named: "twitter")
        cell.contentImage = UIImage(named: "ovosound")
        
        return cell
    }
    
    // MARK: EmptyStateDelegate
    func updateEmptySetVisible(visible: Bool) {
        if visible {
            view.addSubview(emptyStateView)
            emptyStateViewLayoutConstraint?.constant = 400
        } else {
            emptyStateView.removeFromSuperview()
            emptyStateViewLayoutConstraint?.constant = 0
        }
    }
    
    func setupLayout() {
        emptyStateViewLayoutConstraint = emptyStateView.al_height == 400
        
        view.addConstraints([
            emptyStateViewLayoutConstraint!,
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_top == view.al_top
        ])
    }
}
