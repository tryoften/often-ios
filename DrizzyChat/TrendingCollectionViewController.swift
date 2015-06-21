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

class TrendingCollectionViewController: UICollectionViewController, TrendingViewModelDelegate, UIScrollViewDelegate, lyricTabDelegate, artistTabDelegate {
    var viewModel: TrendingViewModel
    var headerView: TrendingHeaderView?
    var sectionHeaderView: TrendingSectionHeaderView?
    var toggle: Bool = true
    
    // Testing arrays
    
    var lyrics = [
        "Admitted the shit spitted, just burn like six furnaces.",
        "They say signs of the end is near; I wonder…can I walk a righteous path holding a beer?",
        "I don’t know what’s better: getting laid or getting paid. I just know when I’m getting one, the other’s getting away.",
        "If I wasn’t in the rap game, I’d probably have a key knee-deep in the crack game. Because the streets is a short stop: Either you’re slinging crack rock or you got a wicked jump shot.",
        "If I don’t got two balls and a middle finger to throw up, I’m takin off both shoes and stickin each middle toe up.",
        "They got money for wars, but can’t feed the poor.",
        "Some seek fame cause they need validation, Some say hating is confused admiration.",
        "Guess who back in the motherfuckin house with a fat dick for your motherfuckin mouth.",
        "I sell ice in the winter, I sell fire in hell. I am a hustler baby, I'll sell water to a well."
    ]
    
    var artists = [
        "Earl Sweatshirt",
        "Common",
        "Kanye West",
        "The Notorious B.I.G.",
        "Eminem",
        "2Pac",
        "Nas",
        "Snoop Dogg",
        "JAY Z"
    ]
    
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
            collectionView.registerClass(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "artistCell")
            collectionView.registerClass(TrendingLyricViewCell.self, forCellWithReuseIdentifier: "lyricCell")
        }
    }
    
    
    class func getLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 100)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 300)
        flowLayout.disableStickyHeaders = true /// allow sticky header for dragging down the table view
        flowLayout.parallaxHeaderAlwaysOnTop = true
        return flowLayout
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: UICollectionViewDelegate methods
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return viewModel.artistsList!.count (for later)
        
        return 9
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if toggle == true {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("artistCell", forIndexPath: indexPath) as! TrendingCollectionViewCell
            
            cell.backgroundColor = UIColor.whiteColor()
            
            cell.rankLabel.text = "\(indexPath.row + 1)"
            cell.nameLabel.text = artists[indexPath.row]
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
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("lyricCell", forIndexPath: indexPath) as! TrendingLyricViewCell
            
            cell.backgroundColor = UIColor.whiteColor()
            
            cell.rankLabel?.text = "\(indexPath.row + 1)"
            cell.lyricView?.text = lyrics[indexPath.row]
            cell.artistLabel?.text = artists[indexPath.row]
            
            if indexPath.row % 2 == 0 {
                cell.trendIndicator.image = UIImage(named: "up")
            } else if indexPath.row % 3 == 0 {
                cell.trendIndicator.image = UIImage(named: "down")
            } else {
                cell.trendIndicator.image = nil
            }


            return cell
        }

    }
    
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! TrendingHeaderView
            
            headerView = cell
            headerView?.lyricDelegate = self
            headerView?.artistDelegate = self
            
            return cell
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! TrendingSectionHeaderView
            
            // add action to segue into the view for tha specific track with all of its lyrics displayed
            
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
        
        return CGSizeMake(screenWidth, 40.5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var screenWidth = UIScreen.mainScreen().bounds.width
        
        if toggle == true {
            return CGSizeMake(screenWidth, 65)
        } else {
            if linesForCharacterCount(lyrics[indexPath.row]) == 1 {
                return CGSizeMake(screenWidth, 45)
            } else if linesForCharacterCount(lyrics[indexPath.row]) == 2 {
                return CGSizeMake(screenWidth, 65)
            } else {
                return CGSizeMake(screenWidth, 65)
            }
        }
    }

    
    // MARK: Protocol + Delegation methods
    
    func trendingViewModelDidLoadTrackList(browseViewModel: TrendingViewModel, artists: [Artist]) {
        
    }
    
    /**
        Lyric tab was selected in the header view
    
        Need to pull the correct data for the lyrics and then switch collection views
        with the correct cells and data and then reload the collection view
    
        The toggle boolean is true for Artists and false for Lyrics
    
    */
    func lyricDidTap() {
        toggle = false
        collectionView?.reloadData()
    }
    
    
    func artistDidTap() {
        toggle = true
        collectionView?.reloadData()
    }
    
    // MARK: Dynamic Cell
    
    /**
        Pass in a lyric and this method will return how many lines it will take up in the 
        collection view cell. We can use this to choose the correct size for the cell.
    
        :param: lyric string of lyric to be counted
    
        :returns: Integer of line count for the string parameter
    */
    func linesForCharacterCount(lyric: String) -> Int {
        var charCount = count(lyric)
        
        if charCount <= 57 {
            return 1
        } else if charCount <= 100 {
            return 2
        } else {
            return 3 /// needs to be elipsed
        }
    }
}
