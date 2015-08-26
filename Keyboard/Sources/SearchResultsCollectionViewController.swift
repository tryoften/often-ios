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
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 100)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
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
            default:
                break
            }

        }
        
        return cell
    }
}
