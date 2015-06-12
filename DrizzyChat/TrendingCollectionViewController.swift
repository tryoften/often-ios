//
//  TrendingCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

/**
    TrendingCollectionViewController:
    
    Will display either a list of Trending artists or tracks
    Should have both loaded before allowing the user to tab between

*/

class TrendingCollectionViewController: UICollectionViewController, TrendingViewModelDelegate, UIScrollViewDelegate {
    var viewModel: TrendingViewModel
    var headerView: TrendingHeaderView?
    var sectionHeaderView: TrendingSectionHeaderView?
    
    init(viewModel: TrendingViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: TrendingCollectionViewController.getLayout())
        self.viewModel.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.backgroundColor = UIColor.blackColor()
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            collectionView.registerClass(TrendingHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(TrendingSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    class func getLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 200)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 280)
        flowLayout.headerReferenceSize = CGSizeMake(screenWidth, 200)
        flowLayout.itemSize = CGSizeMake(screenWidth, 65) /// height of the cell
        flowLayout.disableStickyHeaders = false /// allow sticky header for dragging down the table view
        return flowLayout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// return viewModel.artistsList!.count (for later)
        
        return 15
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TrendingCollectionViewCell
    
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.nameLabel.text = "Rome Fortune"
        cell.subLabel.text = "31 SONGS, 67 LYRICS"
        cell.disclosureIndicator.image = UIImage(named: "arrow")
        
        if indexPath.row % 2 == 0 {
            cell.trendIndicator.image = UIImage(named: "down")
        } else if indexPath.row % 3 == 0 {
            cell.trendIndicator.image = UIImage(named: "up")
        } else {
            cell.trendIndicator.image = nil
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! TrendingHeaderView
            
            headerView = cell
            
            return cell
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! TrendingSectionHeaderView
            
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
        
        return CGSizeMake(screenWidth, 70.5)
    }

    
    func trendingViewModelDidLoadTrackList(browseViewModel: TrendingViewModel, artists: [Artist]) {
        
    }
}
