//
//  UserFavoritesCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 9/4/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let userFavoritesReuseIdentifier = "favoritesCell"

class UserFavoritesCollectionViewController: UICollectionViewController, EmptySetDelegate {
    var emptyStateViewLayoutConstraint: NSLayoutConstraint?
    var emptyStateView: EmptySetView
    var userDefaults: NSUserDefaults
    var userFavorites:[SearchResult?] {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        
        emptyStateView = EmptySetView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.updateEmptyStateContent(.NoFavorites)
        
        if !userDefaults.boolForKey("twitter") {
            emptyStateView.updateEmptyStateContent(.NoTwitter)
        }
        
        if !userDefaults.boolForKey("keyboardInstall") {
            emptyStateView.updateEmptyStateContent(.NoKeyboard)
        }
        
        userFavorites = []
        
        super.init(collectionViewLayout: UserFavoritesCollectionViewController.provideCollectionViewLayout())
        
        view.addSubview(emptyStateView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.scrollEnabled = false
            collectionView.backgroundColor = WhiteColor
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: userFavoritesReuseIdentifier)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(screenWidth, 118)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        return flowLayout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numItems = userFavorites.count
        
        if numItems == 0 {
            updateEmptySetVisible(true)
            return 0
        } else {
            updateEmptySetVisible(false)
            return numItems
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(userFavoritesReuseIdentifier, forIndexPath: indexPath) as! SearchResultsCollectionViewCell

        
        if indexPath.row >= userFavorites.count {
            return cell
        }
        
        guard let result = userFavorites[indexPath.row] else {
            return cell
        }
        
        cell.reset()
        
        switch(result.type) {
        case .Article:
            let article = (result as! ArticleSearchResult)
            cell.mainTextLabel.text = article.title
            cell.leftSupplementLabel.text = article.author
            cell.headerLabel.text = article.sourceName
            cell.rightSupplementLabel.text = article.date?.timeAgoSinceNow()
            cell.centerSupplementLabel.text = nil
        case .Track:
            let track = (result as! TrackSearchResult)
            cell.mainTextLabel.text = track.name
            cell.rightSupplementLabel.text = track.formattedCreatedDate
            
            switch(result.source) {
            case .Spotify:
                cell.headerLabel.text = "Spotify"
                cell.mainTextLabel.text = "\(track.name)"
                cell.leftSupplementLabel.text = track.artistName
                cell.rightSupplementLabel.text = track.albumName
            case .Soundcloud:
                cell.headerLabel.text = track.artistName
                cell.leftSupplementLabel.text = track.formattedPlays()
            default:
                break
            }
        case .Video:
            let video = (result as! VideoSearchResult)
            cell.mainTextLabel.text = video.title
            cell.headerLabel.text = video.owner
            
            if let viewCount = video.viewCount {
                cell.leftSupplementLabel.text = "\(Double(viewCount).suffixNumber) views"
            }
            
            if let likeCount = video.likeCount {
                cell.centerSupplementLabel.text = "\(Double(likeCount).suffixNumber) likes"
            }
            
            cell.rightSupplementLabel.text = video.date?.timeAgoSinceNow()
            
        default:
            break
        }
        
        cell.searchResult = result
        cell.overlayVisible = false
        cell.contentImageView.image = nil
        if  let image = result.image,
            let imageURL = NSURL(string: image) {
                print("Loading image: \(imageURL)")
                cell.contentImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                    cell.contentImageView.image = image
                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
        
        cell.sourceLogoView.image = result.iconImageForSource()
        
        return cell
    }
    
    // MARK: EmptyStateDelegate
    func updateEmptySetVisible(visible: Bool) {
        if visible {
            view.addSubview(emptyStateView)
            emptyStateViewLayoutConstraint?.constant = 400
        } else {
            emptyStateView.removeFromSuperview()
            emptyStateViewLayoutConstraint?.constant = 0
        }
    }
    
    func setupLayout() {
        emptyStateViewLayoutConstraint = emptyStateView.al_height == 400
        
        view.addConstraints([
            emptyStateViewLayoutConstraint!,
            emptyStateView.al_left == view.al_left,
            emptyStateView.al_right == view.al_right,
            emptyStateView.al_top == view.al_top
        ])
    }
}
