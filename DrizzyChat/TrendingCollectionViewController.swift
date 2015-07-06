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

class TrendingCollectionViewController: UICollectionViewController, TrendingViewModelDelegate, UIScrollViewDelegate, LyricTabDelegate, ArtistTabDelegate {
    var viewModel: TrendingViewModel
    var headerView: TrendingHeaderView?
    var sectionHeaderView: TrendingSectionHeaderView?
    var trendingHeaderDelegate: TrendingHeaderDelegate?
    var toggle: Bool = true
    var labelHeight: CGFloat = 65
    let device = UIDevice.currentDevice()
    
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
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            collectionView.registerClass(TrendingHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(TrendingSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "artistCell")
            collectionView.registerClass(TrendingLyricViewCell.self, forCellWithReuseIdentifier: "lyricCell")
            collectionView.registerClass(TrendingOneLineLyricViewCell.self, forCellWithReuseIdentifier: "oneLineCell")
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
    
    
    // MARK: CollectionView
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if toggle == true {
            return viewModel.artistsList.count
        } else if toggle == false {
            return viewModel.lyricsList.count
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if toggle == true {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("artistCell", forIndexPath: indexPath) as! TrendingCollectionViewCell
            
            cell.backgroundColor = UIColor.whiteColor()
            
            cell.rankLabel.text = "\(indexPath.row + 1)"
            cell.nameLabel.text = viewModel.artistsList[indexPath.row].name
            cell.subLabel.text = "\(viewModel.artistsList[indexPath.row].tracksCount) Songs, \(viewModel.artistsList[indexPath.row].lyricCount) Lyrics"

            if indexPath.row % 3 == 0 {
                cell.trendIndicator.image = UIImage(named: "up")
            } else if indexPath.row % 2 == 0 {
                cell.trendIndicator.image = UIImage(named: "down")
            } else {
                cell.trendIndicator.image = nil
            }
            
            return cell
        } else {
            
            let lineCount = lineCountForLyric(viewModel.lyricsList[indexPath.row].text)
            
            if lineCount == 2 {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("lyricCell", forIndexPath: indexPath) as! TrendingLyricViewCell
                
                cell.backgroundColor = UIColor.whiteColor()
                
                cell.rankLabel.text = "\(indexPath.row + 1)"
                
                var screenWidth = UIScreen.mainScreen().bounds.width
                
                let charCount = count(viewModel.lyricsList[indexPath.row].text)
                cell.lyricViewNumLines = lineCountForLyric(viewModel.lyricsList[indexPath.row].text)
                
                cell.lyricView.text = addElipses(indexPath.row)
                
                cell.artistLabel.text = viewModel.lyricsList[indexPath.row].owner
                
                if indexPath.row % 2 == 0 {
                    cell.trendIndicator.image = UIImage(named: "up")
                } else if indexPath.row % 3 == 0 {
                    cell.trendIndicator.image = UIImage(named: "down")
                } else {
                    cell.trendIndicator.image = nil
                }
                
                cell.setLayout()
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("oneLineCell", forIndexPath: indexPath) as! TrendingOneLineLyricViewCell
                
                cell.backgroundColor = UIColor.whiteColor()
                
                cell.rankLabel.text = "\(indexPath.row + 1)"
                
                var screenWidth = UIScreen.mainScreen().bounds.width
                
                let charCount = count(viewModel.lyricsList[indexPath.row].text)
                cell.lyricViewNumLines = lineCountForLyric(viewModel.lyricsList[indexPath.row].text)
                
                if screenWidth == 320 {
                    if charCount >= 81 {
                        var lyric = viewModel.lyricsList[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = viewModel.lyricsList[indexPath.row].text
                    }
                } else if screenWidth == 375 {
                    if charCount >= 104 {
                        var lyric = viewModel.lyricsList[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = viewModel.lyricsList[indexPath.row].text
                    }
                } else {
                    if charCount >= 118 {
                        var lyric = viewModel.lyricsList[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = viewModel.lyricsList[indexPath.row].text
                    }
                }
                
                cell.artistLabel.text = viewModel.lyricsList[indexPath.row].owner
                
                if indexPath.row % 2 == 0 {
                    cell.trendIndicator.image = UIImage(named: "up")
                } else if indexPath.row % 3 == 0 {
                    cell.trendIndicator.image = UIImage(named: "down")
                } else {
                    cell.trendIndicator.image = nil
                }
                
                cell.setupOneLineLayout()
                
                return cell
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! TrendingHeaderView
            
            headerView = cell
            headerView?.lyricDelegate = self
            headerView?.artistDelegate = self
            trendingHeaderDelegate = headerView
            trendingHeaderDelegate?.featuredArtistsDidLoad(viewModel.trendingService.featuredArtists)
            
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
        
        return CGSizeMake(screenWidth, 65)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        trendingCellDidTap(indexPath.row)
    }
    
    
    // MARK: TrendingViewModelDelegate
    
    func trendingViewModelDidLoadTrackList(browseViewModel: TrendingViewModel, artists: [Artist]) {
        
    }
    
    func artistsDidUpdate(artists: [Artist]) {
        println("Artist Update Received")
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        } else {
            println("No reload")
        }
        
        Flurry.logEvent("Trending_Artist_Update")
    }
    
    func lyricsDidUpdate(lyrics: [Lyric]) {
        println("Lyric Update Received")
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        } else {
            println("No reload")
        }
        
        Flurry.logEvent("Trending_Lyric_Update")
    }
    
    
    /**
        Tab selected in the header view
    
        Need to pull the correct data for the content and then switch collection views
        with the correct cells and data and then reload the collection view
    
        Artists: true | Lyrics: false
    
    */
    func lyricDidTap() {
        toggle = false
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        } else {
            println("No reload")
        }
        
        viewDidLoad()
        
        Flurry.logEvent("Toggle_Lyric")
    }
    
    
    func artistDidTap() {
        toggle = true
        
        if let collectionView = collectionView {
            collectionView.reloadSections(NSIndexSet(index: 0))
        } else {
            println("No reload")
        }
        
        viewDidLoad()
        
        Flurry.logEvent("Toggle_Artist")
    }
    
    
    /**
        If a cell is tapped in the trending view then pull up the modal for that artist
    
        :param: artistTappedIndex Pass in the artist to display in the modal
    
    */
    func trendingCellDidTap(artistTappedIndex: Int) {
        // Log the tap into Flurry
        let tappedArtist = viewModel.trendingService.artists[artistTappedIndex]
        let data = ["\(tappedArtist.id)" : tappedArtist, "toggle" : toggle]
        Flurry.logEvent("Trending_Tap", withParameters: data)
        
        // Present the modal for the Artist that the user selected
        var addArtistModal = AddArtistModalContainerViewController(artist: viewModel.trendingService.artists[artistTappedIndex], lyric: viewModel.trendingService.lyrics[artistTappedIndex], toggle: toggle)
        addArtistModal.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.presentViewController(addArtistModal, animated: true, completion: nil)
        
    }
    
    
    // MARK: Dynamic Cell
    
    /**
        iPhone 5: 320 screen width - 40 one line
        iPhone 6: 360 screen width - 48 one line
        iPhone 6+: 375 screen width - 55 one line
    */
    func lineCountForLyric(lyric: String) -> Int {
        if device.modelName == "iPhone 6 Plus" {
            if count(lyric) <= 55 {
                return 1
            } else {
                return 2
            }
        } else if device.modelName.hasPrefix("iPhone 5") {
            if count(lyric) <= 40 {
                return 1
            } else {
                return 2
            }
        } else {
            if count(lyric) <= 48 {
                return 1
            } else {
                return 2
            }
        }
    }
    
    /**
        Takes in a lyric and if longer than two lines, it returns the same string truncated with 
        elipses at the end of the string
    
        :param: lyric A String that contains the lyric text to potentially be truncated
    
        :Returns: The properly truncated or not truncated String
    */
    func addElipses(index: Int) -> String {
        var lyric = viewModel.lyricsList[index].text
        let charCount = count(lyric)
        let substringIndex = charCount - 3
        
        if device.modelName.hasPrefix("iPhone 5") {
            if charCount >= 81 {
                var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                return newLyric
            } else {
                return lyric
            }
        } else if device.modelName == "iPhone 6" {
            if charCount >= 104 {
                var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                return newLyric
            } else {
                return lyric
            }
        } else {
            if charCount >= 118 {
                var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                return newLyric
            } else {
                return lyric
            }
        }
    }
}

protocol TrendingHeaderDelegate {
    func featuredArtistsDidLoad(artists: [Artist])
}
