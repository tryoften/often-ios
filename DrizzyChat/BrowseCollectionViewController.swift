//
//  BrowseCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/31/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    Put collection view in header that contains an artist ID 
    When swiped it will update the tracks for that artist

    Collection views use the same data source and delegate
*/

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BrowseViewModelDelegate, BrowseCollectionViewLayoutDelegate, BrowseHeaderSwipeDelegate {

    var viewModel: BrowseViewModel
    var headerView: BrowseHeaderView?
    var sectionHeaderView: BrowseSectionHeaderView?
    var artistCollectionView: UICollectionView?
    var modalTintView: UIView?
    var addArtistModal: UIView?
    
    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: BrowseCollectionViewController.getLayout())
        self.viewModel.delegate = self
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestData(completion: nil)
        
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(BrowseSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            
            /// Need to register another class for the collection view that is the Artist Art
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /// Dispose of any resources that can be recreated.
    }

    
    class func getLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 450)
        flowLayout.itemSize = CGSizeMake(screenWidth, 70) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = true        
        flowLayout.disableStickyHeaders = false /// allow sticky header for dragging down the table view
        return flowLayout
    }
    

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let trackvar = self.viewModel.tracksList {
            return trackvar.count
        }
        return 10
    }
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! BrowseCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()

        cell.trackNameLabel.text = viewModel.tracks[viewModel.currentArtist]
        
        if let lyricCount = viewModel.lyricCountAtIndex(indexPath.row) {
            // cell.lyricCountLabel.text = "\(lyricCount) Lyrics"
            cell.lyricCountLabel.text = "23 Lyrics"
        }
        
        cell.disclosureIndicator.image = UIImage(named: "arrow")
        cell.rankLabel.text = "\(indexPath.row + 1)"
        
        return cell
            
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! BrowseHeaderView
            
            headerView = cell
            
            headerView?.browsePicker.delegate = self
            self.headerView?.coverPhoto.image = self.viewModel.images[self.viewModel.currentArtist]!.blurredImageWithRadius(100, iterations: 4, tintColor: UIColor.blackColor())
            headerView?.browsePicker.collectionView?.reloadData()

            if let contentSize = headerView?.browsePicker.collectionView!.contentSize {
                println("Content size: \(contentSize)")
                headerView?.browsePicker.scrollView.contentSize = CGSizeMake(250 * 5, 250)
            }
            
            return cell
            
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! BrowseSectionHeaderView
            
            /// add action to segue into the view for tha specific track with all of its lyrics displayed
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0 as CGFloat
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        
        return CGSizeMake(screenWidth, 39.5)
        
    }
    
    
    func browseViewModelDidLoadTracks() {
        
    }
    
    
    /**
        Everytime the user finishes swiping on the header view, the tracks, header, and 
        artist name should be updated here.
    
        The call should be based on the content offset of whether or not the
        user moved into the next artist's view. 
    
    */
    func headerDidSwipe() {
        if viewModel.currentArtist < 4 {
            viewModel.currentArtist++
        }
        headerView?.artistNameLabel.text = viewModel.artistNames[viewModel.currentArtist]
        collectionView?.reloadData()
    }
    
    
    func browseViewModelDidLoadTrackList(browseViewModel: BrowseViewModel, tracks: [Track]) {
        collectionView?.reloadData()
    }
}

class BrowseCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        var attributes: BrowseCollectionViewLayoutAttributes = super.copyWithZone(zone) as! BrowseCollectionViewLayoutAttributes
        return attributes
    }
}
