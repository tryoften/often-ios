//
//  AddArtistModalCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let AddArtistModalReuseIdentifier = "addArtistCell"

class AddArtistModalCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: BrowseViewModel?
    var headerView: AddArtistModalHeaderView?
    var sectionHeaderView: BrowseSectionHeaderView?
    var currentArtist: Artist
    var currentLyric: Lyric
    var currentToggle: Bool
    var artistDelegate: AddArtistModalHeaderDelegate?
    
    init(collectionViewLayout layout: UICollectionViewLayout, artist: Artist, lyric: Lyric, toggle: Bool) {
        currentArtist = artist
        currentLyric = lyric
        currentToggle = toggle
        
        super.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.backgroundColor = UIColor.clearColor()
            collectionView.registerClass(AddArtistModalHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(BrowseSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: "addArtistCell")
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
        return 9
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addArtistCell", forIndexPath: indexPath) as! BrowseCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.trackNameLabel.text = "Lost"
        cell.lyricCountLabel.text = "23 Lyrics"
        cell.disclosureIndicator.image = UIImage(named: "arrow")
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! AddArtistModalHeaderView
            
            headerView = cell
            artistDelegate = headerView
            artistDelegate?.currentArtistDidLoad(currentArtist, lyric: currentLyric, toggle: currentToggle)
            
            return cell
            
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! BrowseSectionHeaderView
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0 as CGFloat
    }
    
    
}
