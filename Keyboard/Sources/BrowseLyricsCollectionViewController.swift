//
//  TredingAlbumLyricsCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 12/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let albumLyricCellReuseIdentifier = "albumLyricCell"

class BrowseLyricsCollectionViewController: MediaItemsCollectionBaseViewController, KeyboardBrowseNavigationDelegate {
    var navigationBar: KeyboardBrowseNavigationBar
    var navigationBarHideConstraint: NSLayoutConstraint?
    
    init() {
        navigationBar = KeyboardBrowseNavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(collectionViewLayout: BrowseLyricsCollectionViewController.provideCollectionViewLayout())
        
        navigationBar.browseDelegate = self
        view.addSubview(navigationBar)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: albumLyricCellReuseIdentifier)
        collectionView!.backgroundColor = LyricTableViewCellNormalBackgroundColor
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        navigationController?.hidesBarsOnSwipe = false
        containerViewController?.resetPosition()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 5.0

        #if KEYBOARD
            let topMargin = CGFloat(115.0)
        #else
            let topMargin = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame) + CGFloat(60.0)
        #endif

        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 30.0, 0.0)
        return layout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(albumLyricCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        cell.reset()
        cell.leftHeaderLabel.text = "The Hills"
        cell.rightHeaderLabel.text = "Single"
        cell.mainTextLabel.text = "Your man on the road he doin' promo\nYou said, \"Keep your business on the low-low\""
        cell.mainTextLabel.textAlignment = .Center
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        cell.showImageView = false
    
        return cell
    }
    
    // MARK: KeyboardBrowseNavigationDelegate
    func backButtonSelected() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func setupLayout() {
        #if KEYBOARD
            let topMargin = KeyboardSearchBarHeight
        #else
            let topMargin = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
        #endif

        navigationBarHideConstraint = navigationBar.al_top == view.al_top + topMargin
        
        view.addConstraints([
            navigationBarHideConstraint!,
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_height == 64
        ])
    }
    
    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = containerViewController else {
            return
        }
        
        var frame = tabBarFrame
        var searchBarFrame = navigationBar.frame
        let tabBarHeight = CGRectGetHeight(frame)
        
        searchBarFrame.origin.y =  fmax(fmin(KeyboardSearchBarHeight + y, KeyboardSearchBarHeight), 0)
        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight)
        
        navigationBarHideConstraint?.constant = searchBarFrame.origin.y
        
        UIView.animateWithDuration(animated ? 0.1 : 0) {
            self.view.layoutSubviews()
            containerViewController.tabBar.frame = frame
        }
    }
}
