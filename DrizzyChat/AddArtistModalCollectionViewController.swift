//
//  AddArtistModalCollectionViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let AddArtistModalReuseIdentifier = "addArtistCell"

class AddArtistModalCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    AddArtistModalHeaderViewDelegate {
    var viewModel: BrowseViewModel?
    var headerView: AddArtistModalHeaderView?
    var sectionHeaderView: BrowseSectionHeaderView?

    var currentArtist: Artist? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.backgroundColor = AddArtistModalCollectionBackgroundColor
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
        if let artist = currentArtist {
            return artist.tracks.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addArtistCell", forIndexPath: indexPath) as! BrowseCollectionViewCell
        
        if let artist = currentArtist {
            let track = artist.tracks[indexPath.row]
            
            cell.rankLabel.text = "\(indexPath.row + 1)"
            cell.trackNameLabel.text = track.name
            cell.lyricCountLabel.text = "\(track.lyricCount) Lyrics"
        }
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! AddArtistModalHeaderView
            
            headerView = cell
            
            if let headerView = headerView {
                headerView.delegate = self
            } else {
                println("Add Artist modal header delegate not set")
            }
            
            if let artist = currentArtist {
                var userHasKeyboard = SessionManager.defaultManager.keyboardService?.keyboardWithId(artist.keyboardId) != nil
                var imageURL = NSURL(string: artist.imageURLLarge)!
                
                if let headerView = headerView {
                    headerView.coverPhoto.setImageWithAnimation(imageURL, blurRadius: 80, completion: nil)
                    headerView.artistImage.setImageWithAnimation(imageURL, blurRadius: 0, completion: nil)
                    headerView.artistNameLabel.text = artist.displayName
                    headerView.addArtistButton.selected = userHasKeyboard
                } else {
                    println("Modal artist header not set")
                }
            }
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

    func addArtistModalHeaderViewDidTapAddArtistButton(addArtistModalHeaderView: AddArtistModalHeaderView, selected: Bool) {
        if let keyboardService = SessionManager.defaultManager.keyboardService,
            let artist = currentArtist {
                if selected {
                    keyboardService.addKeyboardWithId(artist.keyboardId, completion: { (keyboard, success) in
                        
                    })
                } else {
                    keyboardService.deleteKeyboardWithId(artist.keyboardId, completion: { err in
                        
                    })
                }
        }
    }
}
