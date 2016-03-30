//
//  PackScrollCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 3/22/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackBrowseHeaderCollectionViewController: UICollectionViewController {
    let scrollView: UIScrollView
    var currentPage: Int
    
    let itemWidth: CGFloat
    let width: CGFloat
    let padding: CGFloat
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        padding = 75.0
        itemWidth = UIScreen.mainScreen().bounds.width - (padding * 2)
        width = itemWidth + (padding / 2)
        currentPage = 0
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, width, width))
        scrollView.pagingEnabled = true
        scrollView.hidden = true
        scrollView.contentSize = CGSizeMake(4 * (width + padding), width) // 4 is n-1 from viewModel
        
        super.init(collectionViewLayout: layout)
        
        scrollView.delegate = self
        view.backgroundColor = UIColor.clearColor()
        
        view.clipsToBounds = false
        view.addSubview(scrollView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    required convenience init() {
        self.init(collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout(UIScreen.mainScreen().bounds.width - (75.0 * 2), padding: 75.0))
    }
    
    override func viewDidLoad() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        super.viewDidLoad()
        
        if let collectionView = self.collectionView {
            collectionView.alwaysBounceHorizontal = false
            collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.frame.size.width - screenWidth) / 2, 0, (self.view.frame.size.width - screenWidth) / 2)
            collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
            collectionView.panGestureRecognizer.enabled = false
            collectionView.backgroundColor = BrowseHeaderCollectionViewControllerBackground
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.registerClass(PackBrowseHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "browseCell")
        } else {
            print("Collection View is Nil")
        }
    }
    
    func getCurrentPage() -> Int {
        let width = scrollView.frame.size.width
        return Int(floor((scrollView.contentOffset.x + (0.5 * width)) / width))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didScrollToPage(pageIndex: Int) {
        // future purpose
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("browseCell", forIndexPath: indexPath) as? PackBrowseHeaderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if currentPage != getCurrentPage() {
            currentPage = getCurrentPage()
            didScrollToPage(currentPage)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var contentOffset: CGPoint = scrollView.contentOffset
        
        if scrollView == self.scrollView {
            contentOffset.x = contentOffset.x - collectionView!.contentInset.left
            collectionView!.contentOffset = contentOffset
        }
    }
}

class BrowseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    class func provideCollectionFlowLayout(itemWidth: CGFloat, padding: CGFloat) -> UICollectionViewFlowLayout {
        let viewLayout = BrowseCollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = padding / 2 /// The minimum spacing to use between items in the same row
        viewLayout.minimumLineSpacing = padding / 2 /// The minimum spacing to use between lines of items in the grid
        viewLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0.0, right: padding)
        viewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return viewLayout
    }
}

