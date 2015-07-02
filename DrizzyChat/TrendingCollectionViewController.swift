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
    
    var lyrics: [Lyric]
    var artists: [Artist]
    
    init(viewModel: TrendingViewModel) {
        self.viewModel = viewModel
        
        lyrics = [Lyric]() // take out later
        artists = [Artist]() // take out later
        
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
            collectionView.registerClass(TrendingOneLineLyricCellCollectionViewCell.self, forCellWithReuseIdentifier: "OneLineCell")
        }
        
        // Consider putting in a different place
        if let artistList = viewModel.artistsList {
            artists = artistList
        }
        
        if let lyricList = viewModel.lyricsList {
            lyrics = lyricList
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
        // return viewModel.artistsList!.count (for later) when lyrics is returning data
        
        if toggle == true {
            return artists.count
        } else if toggle == false {
            return self.lyrics.count
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if toggle == true {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("artistCell", forIndexPath: indexPath) as! TrendingCollectionViewCell
            
            cell.backgroundColor = UIColor.whiteColor()
            
            cell.rankLabel.text = "\(indexPath.row + 1)"
            cell.nameLabel.text = artists[indexPath.row].name
            cell.subLabel.text = "\(artists[indexPath.row].tracksCount) Songs, \(artists[indexPath.row].lyricCount) Lyrics"

            if indexPath.row % 3 == 0 {
                cell.trendIndicator.image = UIImage(named: "up")
            } else if indexPath.row % 2 == 0 {
                cell.trendIndicator.image = UIImage(named: "down")
            } else {
                cell.trendIndicator.image = nil
            }
            
            return cell
        } else {
            
            let lineCount = lineCountForLyric(lyrics[indexPath.row].text)
            
            if lineCount == 2 {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("lyricCell", forIndexPath: indexPath) as! TrendingLyricViewCell
                
                cell.backgroundColor = UIColor.whiteColor()
                
                cell.rankLabel.text = "\(indexPath.row + 1)"
                
                var screenWidth = UIScreen.mainScreen().bounds.width
                
                let charCount = count(lyrics[indexPath.row].text)
                cell.lyricViewNumLines = lineCountForLyric(lyrics[indexPath.row].text)
                
                if screenWidth == 320 {
                    if charCount >= 81 {
                        var lyric = lyrics[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = lyrics[indexPath.row].text
                    }
                } else if screenWidth == 375 {
                    if charCount >= 104 {
                        var lyric = lyrics[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = lyrics[indexPath.row].text
                    }
                } else {
                    if charCount >= 118 {
                        var lyric = lyrics[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = lyrics[indexPath.row].text
                    }
                }
                
                cell.artistLabel.text = lyrics[indexPath.row].owner
                
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
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OneLineCell", forIndexPath: indexPath) as! TrendingOneLineLyricCellCollectionViewCell
                
                cell.backgroundColor = UIColor.whiteColor()
                
                cell.rankLabel.text = "\(indexPath.row + 1)"
                
                var screenWidth = UIScreen.mainScreen().bounds.width
                
                let charCount = count(lyrics[indexPath.row].text)
                cell.lyricViewNumLines = lineCountForLyric(lyrics[indexPath.row].text)
                
                if screenWidth == 320 {
                    if charCount >= 81 {
                        var lyric = lyrics[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = lyrics[indexPath.row].text
                    }
                } else if screenWidth == 375 {
                    if charCount >= 104 {
                        var lyric = lyrics[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = lyrics[indexPath.row].text
                    }
                } else {
                    if charCount >= 118 {
                        var lyric = lyrics[indexPath.row].text
                        let stringLength = count(lyric)
                        let substringIndex = stringLength - 3
                        var newLyric = lyric.substringToIndex(advance(lyric.startIndex, substringIndex))
                        cell.lyricView.text = "\(newLyric)..."
                    } else {
                        cell.lyricView.text = lyrics[indexPath.row].text
                    }
                }
                
                cell.artistLabel.text = lyrics[indexPath.row].owner
                
                if indexPath.row % 2 == 0 {
                    cell.trendIndicator.image = UIImage(named: "up")
                } else if indexPath.row % 3 == 0 {
                    cell.trendIndicator.image = UIImage(named: "down")
                } else {
                    cell.trendIndicator.image = nil
                }
                
                cell.setLayout()
                
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
        addArtistButtonDidTap(indexPath.row)
    }
    
    // MARK: Protocol + Delegation methods
    
    func trendingViewModelDidLoadTrackList(browseViewModel: TrendingViewModel, artists: [Artist]) {
        
    }
    
    func artistsDidUpdate(artists: [Artist]) {
        println("Artist Update Received")
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        } else {
            println("No reload")
        }
    }
    
    func lyricsDidUpdate(lyrics: [Lyric]) {
        println("Lyric Update Received")
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        } else {
            println("No reload")
        }
    }
    
    /**
        Lyric tab was selected in the header view
    
        Need to pull the correct data for the lyrics and then switch collection views
        with the correct cells and data and then reload the collection view
    
        The toggle boolean is true for Artists and false for Lyrics
    
    */
    func lyricDidTap() {
        toggle = false
        
        // Consider putting in a different place
        if let artistList = viewModel.artistsList {
            artists = artistList
        }
        
        if let lyricList = viewModel.lyricsList {
            lyrics = lyricList
        }
        
        if let collectionView = collectionView {
            // collectionView.reloadData()
            collectionView.reloadSections(NSIndexSet(index: 0))
        } else {
            println("No reload")
        }
        
        viewDidLoad()
    }
    
    
    func artistDidTap() {
        toggle = true
        
        // Consider putting in a different place
        if let artistList = viewModel.artistsList {
            artists = artistList
        }
        
        if let lyricList = viewModel.lyricsList {
            lyrics = lyricList
        }
        
        if let collectionView = collectionView {
            // collectionView.reloadData()
            collectionView.reloadSections(NSIndexSet(index: 0))
        } else {
            println("No reload")
        }
        
        viewDidLoad()
    }
    
    /**
    
    */
    func addArtistButtonDidTap(artistTappedIndex: Int) {
        // Present the Add Artist Modal
        
        var addArtistModal: AddArtistModalContainerViewController = AddArtistModalContainerViewController(nibName: nil, bundle: nil)
        addArtistModal.currentArtist = viewModel.trendingService.artists[artistTappedIndex]
        addArtistModal.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.presentViewController(addArtistModal, animated: true, completion: nil)
    }
    
    // MARK: Dynamic Cell
    
    /**
        iPhone 5: 320 screen width - 45 one line
        iPhone 6: 360 screen width - 53 one line
        iPhone 6+: 375 screen width - 64 one line
    */
    func lineCountForLyric(lyric: String) -> Int {
        var screenWidth = UIScreen.mainScreen().bounds.width
        
        if screenWidth == 320 {
            if count(lyric) <= 45 {
                return 1
            } else {
                return 2
            }
        } else if screenWidth == 375 {
            if count(lyric) <= 50 {
                return 1
            } else {
                return 2
            }
        } else {
            if count(lyric) <= 64 {
                return 1
            } else {
                return 2
            }
        }
    }
}

protocol TrendingHeaderDelegate {
    func featuredArtistsDidLoad(artists: [Artist])
}
