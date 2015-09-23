//
//  UserFavoritesCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 9/4/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let userFavoritesReuseIdentifier = "favoritesCell"

class UserFavoritesCollectionViewController: UICollectionViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    init() {
        super.init(collectionViewLayout: UserFavoritesCollectionViewController.provideCollectionViewLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.emptyDataSetSource = self
            collectionView.emptyDataSetDelegate = self
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
        return flowLayout
    }
    
    // DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "favoritesemptystate")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string: NSString = "No favorites yet!"
        var attributedString = NSMutableAttributedString(string: string as String)
        let firstAttributes = [NSForegroundColorAttributeName: UIColor(fromHexString: "#202020"), NSBackgroundColorAttributeName: ClearColor]
        
        attributedString.addAttributes(firstAttributes, range: NSMakeRange(0, attrString.length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat", size: 15.0)!, range: NSMakeRange(0, attrString.length))
        
        return attributedString
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string: NSString = "Double tap any cards to save them to your favorites & easily share them again later."
        var attributedString = NSMutableAttributedString(string: string as String)
        let firstAttributes = [NSForegroundColorAttributeName: UIColor(fromHexString: "#202020"), NSBackgroundColorAttributeName: ClearColor]
        
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString(NSMakeRange(0, attrString.length)))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 12.0)!, range: NSMakeRange(0, attrString.length))
        
        return attributedString
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return view.frame.height / 3
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(userFavoritesReuseIdentifier, forIndexPath: indexPath) as! SearchResultsCollectionViewCell
    
        cell.sourceLogoView.image = UIImage(named: "complex")
        cell.headerLabel.text = "@ComplexMag"
        cell.mainTextLabel.text = "In the heat of the battle, @Drake dropped some new flames in his new track, Charged Up, via..."
        cell.leftSupplementLabel.text = "3.1K Retweets"
        cell.centerSupplementLabel.text = "4.5K Favorites"
        cell.rightSupplementLabel.text = "July 25, 2015"
        cell.rightCornerImageView.image = UIImage(named: "twitter")
        cell.contentImage = UIImage(named: "ovosound")
        
        return cell
    }
}
