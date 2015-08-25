//
//  SearchResultsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

/**
    SearchResultsCollectionViewController

    Collection view that can display any type of service provider cell because they are all 
    the same size.
    
    Types of providers:

    Song Cell
    Video Cell
    Article Cell
    Tweet Cell

*/
class SearchResultsCollectionViewController: UICollectionViewController {
    var resultsLabel: UILabel
    var response: SearchResponse? {
        didSet {
            collectionView?.reloadData()
            collectionView?.scrollRectToVisible(CGRectZero, animated: true)
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        resultsLabel = UILabel()
        
        super.init(collectionViewLayout: layout)
        
        collectionView?.backgroundColor = VeryLightGray
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(collectionViewLayout: SearchResultsCollectionViewController.provideCollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        if let collectionView = collectionView {
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 40.0, right: 10.0)
        return layout
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let response = response {
            return response.results.count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
        
        if let result = response?.results[indexPath.row] {
            
            switch(result.type) {
            case .Article:
                var article = (result as! ArticleSearchResult)
                cell.mainTextLabel.text = article.title
                cell.leftSupplementLabel.text = article.author
                cell.headerLabel.text = article.sourceName
                cell.rightSupplementLabel.text = article.date?.timeAgoSinceNow()
            case .Track:
                var track = (result as! TrackSearchResult)
                cell.mainTextLabel.text = track.name
                
                if let imageURL = NSURL(string: track.image) {
                    var request = NSURLRequest(URL: imageURL)
                    cell.contentImageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (req, res, image) in
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.contentImage = image
                        }
                    }, failure: { (req, res, err) in
                        
                    })
                }
                
                cell.rightSupplementLabel.text = track.formattedCreatedDate
                
                switch(result.source) {
                case .Spotify:
                    cell.headerLabel.text = "Spotify"
                    cell.mainTextLabel.text = "\(track.name)"
                    cell.leftSupplementLabel.text = track.artistName
                case .Soundcloud:
                    cell.headerLabel.text = "Soundcloud"
                    cell.leftSupplementLabel.text = track.formattedPlays()
                default:
                    break
                }
                
            default:
                break
            }
            
            cell.sourceLogoView.image = result.iconImageForSource()

        }
        
        return cell
    }
}
