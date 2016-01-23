//
//  TrendingArtistsHorizontalCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let TrendingArtistsCellReuseIdentifier = "Cell"

class TrendingArtistsHorizontalCollectionViewController: FullScreenCollectionViewController {
    var viewModel: BrowseViewModel
    var group: MediaItemGroup? {
        didSet {
            collectionView?.reloadData()
        }
    }

    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: TrendingArtistsHorizontalCollectionViewController.provideLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.registerClass(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: TrendingArtistsCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.showsHorizontalScrollIndicator = false
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
        cell.songCount = artist.lyrics_count ?? 0
        if let image = artist.image, let imageURL = NSURL(string: image) {
            cell.imageView.setImageWithAnimation(imageURL)
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showNavigationBar(true)

        guard let artistMediaItem = group?.items[indexPath.row] as? ArtistMediaItem else {
            return
        }

        let browseVC = BrowseArtistCollectionViewController(artistId: artistMediaItem.id, viewModel: viewModel)
        navigationController?.pushViewController(browseVC, animated: true)
        containerViewController?.resetPosition()
    }
}
