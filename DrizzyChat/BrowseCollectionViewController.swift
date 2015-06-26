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

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BrowseViewModelDelegate, BrowseCollectionViewLayoutDelegate, BrowseHeaderSwipeDelegate, BrowseHeaderCollectionViewDataSource, UpdateTracksFromHeaderDelegate {

    var viewModel: BrowseViewModel
    var headerView: BrowseHeaderView?
    var sectionHeaderView: BrowseSectionHeaderView?
    var artistCollectionView: UICollectionView?
    var modalTintView: UIView?
    var addArtistModal: UIView?
    var artistsSet: Bool = false
    
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
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(BrowseHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(BrowseSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        if artistsSet == true {
            return self.viewModel.currentArtist.tracksList.count
        } else {
            return 0
        }
    }
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! BrowseCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let track = viewModel.currentArtist.tracks[indexPath.row]

        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.trackNameLabel.text = track.name
        cell.lyricCountLabel.text = "\(track.lyricCount) lyrics"
        cell.disclosureIndicator.image = UIImage(named: "arrow")
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! BrowseHeaderView
            
            headerView = cell
            
            
            // Blur that I had blurredImageWithRadius(100, iterations: 4, tintColor: UIColor.blackColor())
            
            if let headerViewController = headerView?.browsePicker {
                headerViewController.delegate = self
                headerViewController.dataSource = self
                headerViewController.headerDelegate = headerView
                headerViewController.updateTracksDelegate = self
            }
            
            self.headerView?.coverPhoto.setImageWithURL(NSURL(string: viewModel.currentArtist.imageURLLarge))
            self.headerView?.browsePicker.collectionView?.reloadData()
            
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
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 39.5)
        
    }
    
    
    // MARK: BrowseHeaderSwipeDelegate
    
    /**
        Everytime the user finishes swiping on the header view, the tracks, header, and 
        artist name should be updated here.
    
        The call should be based on the content offset of whether or not the
        user moved into the next artist's view. 
    
    */
    func headerDidSwipe(currentPage: Int) {
        if let headerView = headerView {
            headerView.artistNameLabel.text = viewModel.currentArtist.name
        }
        
        viewModel.currentArtist = viewModel.artists[currentPage]
        collectionView?.reloadData()
    }
    
    
    // MARK: BrowseViewModelDelegate
    
    func browseViewModelDidLoadTrackList(browseViewModel: BrowseViewModel, tracks: [Track]) {
        collectionView?.reloadData()
    }

    
    // MARK: BrowseHeaderCollectionViewDataSource
    
    func numberOfItemsInBrowsePicker(browsePicker: BrowseHeaderCollectionViewController) -> Int {
        return viewModel.artists.count
    }
    
    func artistForIndexPath(browsePicker: BrowseHeaderCollectionViewController, index: Int) -> Artist? {
        return viewModel.artists[index]
    }
    
    //MARK: UpdateTracksFromHeaderDelegate
    
    func updateTracksForArtist(artist: Artist) {
        viewModel.currentArtist = artist
        println(artist.tracks)
        artistsSet = true
        collectionView?.reloadData()
    }
}

class BrowseCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        var attributes: BrowseCollectionViewLayoutAttributes = super.copyWithZone(zone) as! BrowseCollectionViewLayoutAttributes
        return attributes
    }
}
