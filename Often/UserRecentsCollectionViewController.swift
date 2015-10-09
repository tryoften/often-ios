//
//  UserRecentsCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 9/4/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let userRecentsReuseIdentifier = "userRecentsCell"

class UserRecentsCollectionViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: UserRecentsCollectionViewController.provideCollectionViewLayout())
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
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "searchCell")
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
        return UIImage(named: "recentsemptystate")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string: String = "No recents yet!"
        let attributedString = NSMutableAttributedString(string: string)
        let attributes = [
            NSForegroundColorAttributeName: UIColor(fromHexString: "#202020"),
            NSBackgroundColorAttributeName: ClearColor,
            NSFontAttributeName: UIFont(name: "Montserrat", size: 15.0)!
        ]
        
        attributedString.addAttributes(attributes, range: NSMakeRange(0, string.characters.count))
        
        return attributedString
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string: String = "Start using Often to easily access your most recently searched or used content."
        var attributedString = NSMutableAttributedString(string: string)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor(fromHexString: "#202020"),
            NSBackgroundColorAttributeName: ClearColor,
            NSFontAttributeName: UIFont(name: "OpenSans", size: 12.0)!
        ]
        
        attributedString.addAttributes(attributes, range: NSMakeRange(0, string.characters.count))
        
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
    
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
