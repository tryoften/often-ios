//
//  TrackCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/31/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let TrackCollectionReuseIdentifier = "TrackCollectionViewCell"

class TrackCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var viewModel: BrowseViewModel?
    var tracks: [Track]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionView?.showsHorizontalScrollIndicator = false
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionReuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let tracks = tracks {
            return tracks.count
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrackCollectionReuseIdentifier, forIndexPath: indexPath) as! BrowseCollectionViewCell
        
        var track = tracks![indexPath.row]
        
        cell.trackNameLabel.text = track.name
        cell.lyricCountLabel.text = "Lyric Count: 0"
        cell.rankLabel.text = "\(indexPath.row + 1)"
        //have to set the image view for the disclosure indicator
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //for later to segue into new view
    }
    
    // MARK: UICollectionViewFlowLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), BrowseCollectionViewCellHeight) //cell should be [width of screen x 63]
    }


}
