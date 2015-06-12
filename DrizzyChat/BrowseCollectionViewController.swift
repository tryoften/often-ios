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

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, BrowseViewModelDelegate, BrowseCollectionViewLayoutDelegate {

    var viewModel: BrowseViewModel
    var headerView: BrowseHeaderView?
    var sectionHeaderView: BrowseSectionHeaderView?
    var artistCollectionView: UICollectionView?
    
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
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 200)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 450)
        flowLayout.headerReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.itemSize = CGSizeMake(screenWidth, 70) /// height of the cell
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
        if collectionView == self.collectionView {
            if let trackvar = self.viewModel.tracksList {
                return trackvar.count
            }
        } else if collectionView == headerView?.artistBrowseCollectionView {
            return 5
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            /// if loading for track list - load this cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! BrowseCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            
            if let trackName = viewModel.trackNameAtIndex(indexPath.row) {
                cell.trackNameLabel.text = trackName
            } else {
                cell.trackNameLabel.text = "No Track Name"
            }
            
            if let lyricCount = viewModel.lyricCountAtIndex(indexPath.row) {
                cell.lyricCountLabel.text = "\(lyricCount) Lyrics"
            }
            
            cell.disclosureIndicator.image = UIImage(named: "arrow")
            cell.rankLabel.text = "\(indexPath.row + 1)"
            
            return cell
            
        } else if collectionView == headerView?.artistBrowseCollectionView {
            /// if loading for the header view - load this cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(BrowseHeaderViewCellIdentifier, forIndexPath: indexPath) as! BrowseHeaderCollectionViewCell
            
            cell.artistImage.image = UIImage(named: "frank")
            
            return cell
            
        } else {
            let cell = UICollectionViewCell()
            return cell
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! BrowseHeaderView
            
            headerView = cell
            headerView?.artistBrowseCollectionView?.dataSource = self
            headerView?.artistBrowseCollectionView?.reloadData()
            
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
        if collectionView == headerView?.artistBrowseCollectionView {
            return 20 as CGFloat
        } else {
             return 0.0 as CGFloat
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        
        if collectionView == headerView?.artistBrowseCollectionView {
            return CGSizeMake(40.0, 40.0)
        } else {
            return CGSizeMake(screenWidth, 39.5)
        }
    }
    
    func browseViewModelDidLoadTracks() {
        
    }
    
    /// to call if the user pages to another artist
    func headerDidSwipe() {
        /**
            param may be a UIGesture
            if left, page to that side
            vice-versa for right
        
        */
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
