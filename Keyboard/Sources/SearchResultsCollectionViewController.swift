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
class SearchResultsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SearchResultsCollectionViewCellDelegate {
    var backgroundImageView: UIImageView
    var cellsAnimated: [NSIndexPath: Bool]
    var textProcessor: TextProcessingManager?
    var response: SearchResponse? {
        didSet {
            cellsAnimated = [:]
            
            if let collectionView = collectionView {
                collectionView.reloadData()
                collectionView.scrollRectToVisible(CGRectZero, animated: true)
            }
            
            backgroundImageView.hidden = (response != nil && !response!.results.isEmpty)
        }
    }
    
    init(collectionViewLayout layout: UICollectionViewLayout, textProcessor: TextProcessingManager?) {
        backgroundImageView = UIImageView(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .Center
        backgroundImageView.contentScaleFactor = 2.5
        cellsAnimated = [:]
        
        self.textProcessor = textProcessor
        
        super.init(collectionViewLayout: layout)
        
        view.insertSubview(backgroundImageView, belowSubview: collectionView!)
        view.backgroundColor = VeryLightGray
        collectionView?.backgroundColor = UIColor.clearColor()
        
        // Register cell classes
        if let collectionView = collectionView {
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "serviceCell")
        }
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textProcessor: TextProcessingManager?) {
        self.init(collectionViewLayout: SearchResultsCollectionViewController.provideCollectionViewFlowLayout(), textProcessor: textProcessor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = CGRectGetWidth(view.frame) - 20
        if let result = response?.results[indexPath.row] {
            switch (result.type) {
            case .Track:
                return CGSizeMake(width, 105)
            default:
                break
            }
        }
        
        return CGSizeMake(width, 105)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell

        if let result = response?.results[indexPath.row] {
            
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
                case .Soundcloud:
                    cell.headerLabel.text = track.artistName
                    cell.leftSupplementLabel.text = track.formattedPlays()
                default:
                    break
                }
            default:
                break
            }
            
            cell.searchResult = result
            cell.delegate = self
            cell.overlayVisible = false
            cell.contentImageView.image = nil
            if  let image = result.image,
                let imageURL = NSURL(string: image) {
                cell.contentImageView.setImageWithURL(imageURL)
            }
            
            cell.sourceLogoView.image = result.iconImageForSource()
            
            if (cellsAnimated[indexPath] != true) {
                cell.alpha = 0.0
                
                let finalFrame = cell.frame
                
                cell.frame = CGRectMake(finalFrame.origin.x, finalFrame.origin.y + 1000.0, finalFrame.size.width, finalFrame.size.height)

                UIView.animateWithDuration(0.3, delay: 0.03 * Double(indexPath.row), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                    cell.alpha = 1.0
                    cell.frame = finalFrame
                }, completion: nil)
            }
            
            cellsAnimated[indexPath] = true
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? SearchResultsCollectionViewCell else {
            return
        }
        
        guard let cells = collectionView.visibleCells() as? [SearchResultsCollectionViewCell] else {
            return
        }
        
        for cell in cells {
            cell.overlayVisible = false
        }
        
        cell.overlayVisible = true
    }
    
    func setupLayout() {
        view.addConstraints([
            backgroundImageView.al_top == view.al_top,
            backgroundImageView.al_left == view.al_left,
            backgroundImageView.al_width == view.al_width,
            backgroundImageView.al_height == view.al_height - 30
        ])
    }
    
    // SearchResultsCollectionViewCellDelegate
    func searchResultsCollectionViewCellDidToggleFavoriteButton(cell: SearchResultsCollectionViewCell, selected: Bool) {
        guard let result = cell.searchResult else {
            return
        }
        
        let task = selected ? "addFavorite" : "removeFavorite"
        
        let favoriteQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        favoriteQueueRef.setValue([
            "task": task,
            "user": "anon",
            "result": result.toDictionary()
        ])
    }
    
    func searchResultsCollectionViewCellDidToggleCancelButton(cell: SearchResultsCollectionViewCell, selected: Bool) {
        cell.overlayVisible = false
    }
    
    func searchResultsCollectionViewCellDidToggleInsertButton(cell: SearchResultsCollectionViewCell, selected: Bool) {
        guard let result = cell.searchResult else {
            return
        }

        textProcessor?.defaultProxy.insertText(result.getInsertableText())
    }
}
