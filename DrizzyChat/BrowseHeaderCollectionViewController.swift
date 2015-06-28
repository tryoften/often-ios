//
//  BrowseHeaderCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let BrowseHeaderReuseIdentifier = "Cell"

class BrowseHeaderCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    let scrollView: UIScrollView
    var viewModel: BrowseViewModel?
    var delegate: BrowseHeaderSwipeDelegate?
    var headerDelegate: HeaderUpdateDelegate?
    var viewControllerDelegate: BrowseHeaderCollectionViewControllerDelegate?
    var updateTracksDelegate: UpdateTracksFromHeaderDelegate?
    var dataSource: BrowseHeaderCollectionViewDataSource?
    
    let itemWidth: CGFloat
    let width: CGFloat
    let padding: CGFloat
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        padding = BrowseHeaderCollectionViewPadding
        itemWidth = UIScreen.mainScreen().bounds.width - (padding * 2)
        width = itemWidth + (padding / 2)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, width, width))
        scrollView.pagingEnabled = true
        scrollView.hidden = true

        super.init(collectionViewLayout: layout)

        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    required convenience init(coder aDecoder: NSCoder) {        
        self.init()
    }
    
    required convenience init() {
        self.init(collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout(UIScreen.mainScreen().bounds.width - (BrowseHeaderCollectionViewPadding * 2), padding: BrowseHeaderCollectionViewPadding))
    }
    
    override func viewDidLoad() {
        var screenWidth = UIScreen.mainScreen().bounds.width
        
        super.viewDidLoad()
        
        if let collectionView = self.collectionView {
            collectionView.alwaysBounceHorizontal = false
            collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.frame.size.width - screenWidth) / 2, 0, (self.view.frame.size.width - screenWidth) / 2)
            collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
            collectionView.panGestureRecognizer.enabled = false
            
            collectionView.backgroundColor = UIColor.clearColor()
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.registerClass(BrowseHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "browseCell")
        } else {
            println("Collection View is Nil")
        }
    }
    
    func getCurrentPage() -> Int {
        var width = scrollView.frame.size.width
        return Int(floor((scrollView.contentOffset.x + (0.5 * width)) / width))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didScrollToPage(pageIndex: Int) {
        delegate?.headerDidSwipe(pageIndex)
        
        if let artist = dataSource?.artistForIndexPath(self, index: pageIndex) {
            headerDelegate?.headerDidChange(artist)
            updateTracksDelegate?.updateTracksForArtist(artist)
        }
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            let numberOfItems = dataSource.numberOfItemsInBrowsePicker(self)
            scrollView.contentSize = CGSizeMake(width * CGFloat(numberOfItems), width)
            return numberOfItems
        }
        return 0
    }

    /**
        Use The delegate to get the right information for the cell
    
        - Artist Name
        - ID
        - Image Large
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("browseCell", forIndexPath: indexPath) as! BrowseHeaderCollectionViewCell
        
        if let artist = dataSource?.artistForIndexPath(self, index: indexPath.row) {
            cell.artistImage.setImageWithURL(NSURL(string: artist.imageURLLarge))
        }
        
        return cell
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("Current page: \(getCurrentPage())")
        didScrollToPage(getCurrentPage())
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            var contentOffset: CGPoint = scrollView.contentOffset
            contentOffset.x = contentOffset.x - collectionView!.contentInset.left
            collectionView!.contentOffset = contentOffset
        }
    }
}

protocol BrowseHeaderCollectionViewDataSource {
    func numberOfItemsInBrowsePicker(browsePicker: BrowseHeaderCollectionViewController) -> Int
    func artistForIndexPath(browsePicker: BrowseHeaderCollectionViewController, index: Int) -> Artist?
}

protocol BrowseHeaderCollectionViewControllerDelegate {
    func headerDidLoadArtists()
}

protocol BrowseHeaderSwipeDelegate {
    func headerDidSwipe(currentPage: Int)
}

protocol UpdateTracksFromHeaderDelegate {
    func updateTracksForArtist(artist: Artist)
}

protocol HeaderUpdateDelegate {
    func headerDidChange(artist: Artist)
}
