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
    var scrollView: UIScrollView
    var delegate: BrowseHeaderSwipeDelegate?
    
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
        scrollView = UIScrollView(frame: CGRectMake(40, 65, 250, 250))
        scrollView.pagingEnabled = true
        scrollView.hidden = true
        
        super.init(collectionViewLayout: layout)
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        setLayout()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout())
    }
    
    override func viewDidLoad() {
        var screenWidth = UIScreen.mainScreen().bounds.width
        
        super.viewDidLoad()
        
        /**
            (self.view.frame.size.width - screenWidth)/2
            (self.view.frame.size.width - screenWidth)/2
        */
        
        if let collectionView = self.collectionView {
            collectionView.alwaysBounceHorizontal = false
            
            collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.frame.size.width - screenWidth)/2, 0, (self.view.frame.size.width - screenWidth)/2)
            collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
            collectionView.panGestureRecognizer.enabled = false
            
            collectionView.backgroundColor = UIColor.clearColor()
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.registerClass(BrowseHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "browseCell")
        } else {
            println("Collection view nil")
        }
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
        view.addConstraints([
            scrollView.al_top == view.al_top + 45,
            scrollView.al_left == view.al_left + 65
        ])
    }
}

protocol BrowseHeaderSwipeDelegate {
    func headerDidSwipe()
}

protocol BrowseHeaderCoverPhotoDelegate {
    func updateCoverPhoto()
}
