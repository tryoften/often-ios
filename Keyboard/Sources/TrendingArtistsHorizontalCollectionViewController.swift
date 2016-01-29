//
//  TrendingArtistsHorizontalCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

private let TrendingArtistsCellReuseIdentifier = "TrendingArtistsCell"

class TrendingArtistsHorizontalCollectionViewController: FullScreenCollectionViewController {
    var parentVC: MediaItemGroupsViewController?
    var textProcessor: TextProcessingManager?
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
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let group = group {
            return group.items.count
        }
        return 5
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let group = group, let artist = group.items[indexPath.row] as? ArtistMediaItem else {
            return
        }

        let artistsVC = BrowseArtistCollectionViewController(artistId: artist.id, viewModel: viewModel)
        self.navigationController?.pushViewController(artistsVC, animated: true)
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
}
