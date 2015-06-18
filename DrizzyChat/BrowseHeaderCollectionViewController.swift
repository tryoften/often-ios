//
//  BrowseHeaderCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let BrowseHeaderReuseIdentifier = "Cell"

class BrowseHeaderCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var artists = [
        UIImage(named: "frank"),
        UIImage(named: "frank"),
        UIImage(named: "frank"),
        UIImage(named: "frank"),
        UIImage(named: "frank")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clearColor()
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.registerClass(BrowseHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "browseCell")
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout())
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(250, 250)
    }
}
