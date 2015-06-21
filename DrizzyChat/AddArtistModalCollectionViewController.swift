//
//  AddArtistModalCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let AddArtistModalReuseIdentifier = "addArtistCell"

class AddArtistModalCollectionViewController: UICollectionViewController, CloseButtonDelegate {
    var viewModel: BrowseViewModel
    var headerView: AddArtistModalHeaderView?
    var sectionHeaderView: BrowseSectionHeaderView?
    
    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: AddArtistModalCollectionViewController.getLayout())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(AddArtistModalHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(BrowseSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    class func getLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 380)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false /// allow sticky header for dragging down the table view
        flowLayout.itemSize = CGSizeMake(screenWidth, 70) /// height of the cell
        return flowLayout
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! AddArtistModalHeaderView
            
            headerView = cell
            self.headerView?.coverPhoto.image = self.viewModel.images[0]!.blurredImageWithRadius(100, iterations: 4, tintColor: UIColor.blackColor())
            headerView?.delegate = self
            
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
    
    func closeTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
