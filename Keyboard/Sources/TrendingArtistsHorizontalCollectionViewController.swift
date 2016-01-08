//
//  TrendingArtistsHorizontalCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let TrendingArtistsCellReuseIdentifier = "Cell"

class TrendingArtistsHorizontalCollectionViewController: UICollectionViewController {
    var group: MediaItemGroup? {
        didSet {
            collectionView?.reloadData()
        }
    }

    init() {
        super.init(collectionViewLayout: TrendingArtistsHorizontalCollectionViewController.provideLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.registerClass(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: TrendingArtistsCellReuseIdentifier)
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
        layout.itemSize = CGSizeMake(ArtistCollectionViewCellWidth, 210)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return layout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let group = group {
            return group.items.count
        }
        return 5
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrendingArtistsCellReuseIdentifier, forIndexPath: indexPath) as? ArtistCollectionViewCell else {
            return UICollectionViewCell()
        }


        guard let artist = group?.items[indexPath.row] as? ArtistMediaItem else {
            return cell
        }
    
        // Configure the cell
        cell.titleLabel.text = artist.name
        cell.songCount = artist.lyricsCount ?? 0
        if let image = artist.image, let imageURL = NSURL(string: image) {
            cell.imageView.setImageWithURL(imageURL)
        } else {
            cell.imageView.image = UIImage(named: "postmalone")
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        navigationController?.navigationBar.hidden = true
        navigationController?.pushViewController(BrowseArtistCollectionViewController(), animated: true)
        containerViewController?.resetPosition()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
