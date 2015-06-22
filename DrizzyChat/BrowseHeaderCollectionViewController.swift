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
    var delegate: BrowseHeaderSwipeDelegate?
    
    let itemWidth: CGFloat
    let padding: CGFloat
    
    var artists = [
        UIImage(named: "frank"),
        UIImage(named: "snoop"),
        UIImage(named: "nicki-minaj"),
        UIImage(named: "drake"),
        UIImage(named: "eminem")
    ]
    
    var artistNames = [
        "Frank Ocean",
        "Snoop Dogg",
        "Nicki Minaj",
        "Drake",
        "Eminem"
    ]
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        padding = BrowseHeaderCollectionViewPadding
        itemWidth = UIScreen.mainScreen().bounds.width - (padding * 2)
        
        let width: CGFloat = itemWidth + (padding / 2)
        scrollView = UIScrollView(frame: CGRectMake(0, 0, width, width))
        scrollView.pagingEnabled = true
        scrollView.hidden = true
        scrollView.contentSize = CGSizeMake(width * CGFloat(artists.count), width)

        super.init(collectionViewLayout: layout)

        scrollView.delegate = self
        view.addSubview(scrollView)
        
        setLayout()
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
            println("Collection view nil")
        }
    }
    
    func getCurrentPage() -> Int {
        var width = scrollView.frame.size.width
        return Int(floor((scrollView.contentOffset.x + (0.5 * width)) / width))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("browseCell", forIndexPath: indexPath) as! BrowseHeaderCollectionViewCell
        
        cell.artistImage.image = artists[indexPath.row]
        
        
        return cell
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("Current page: \(getCurrentPage())")
        delegate?.headerDidSwipe()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            var contentOffset: CGPoint = scrollView.contentOffset
            contentOffset.x = contentOffset.x - collectionView!.contentInset.left
            collectionView!.contentOffset = contentOffset
        }
    }
    
    func setLayout() {
    }
}

protocol BrowseHeaderSwipeDelegate {
    func headerDidSwipe()
}

protocol BrowseHeaderCoverPhotoDelegate {
    func updateCoverPhoto()
}
