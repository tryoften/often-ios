//
//  TrendingLyricsHorizontalCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let TrendingLyricsCellReuseIdentifier = "Cell"

class TrendingLyricsHorizontalCollectionViewController: MediaItemsAndFilterBarViewController {
    init() {
        super.init(collectionViewLayout: TrendingLyricsHorizontalCollectionViewController.provideLayout(), collectionType: .Trending, viewModel: MediaItemsViewModel())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: TrendingLyricsCellReuseIdentifier
        )
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.showsHorizontalScrollIndicator = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 85, 105)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return layout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrendingLyricsCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.reset()
        cell.leftHeaderLabel.text = "Post Malone"
        cell.rightHeaderLabel.text = "White Iverson"
        cell.mainTextLabel.text = "Saucin', saucin', on you,\nI'm swaggin', swaggin', swaggin' oh ohh"
        cell.mainTextLabel.textAlignment = .Center
        cell.sourceLogoView.image = UIImage(named: "genius")
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        cell.showImageView = false
        cell.mediaLink = MediaItem(data: ["id": "id"])
    
        return cell
    }
}
