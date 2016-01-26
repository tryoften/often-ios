//
//  FeaturedArtistsCollectionViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 1/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

private let FeaturedArtistsCellReuseIdentifier = "Cell"

class FeaturedArtistsCollectionViewController: FullScreenCollectionViewController, MediaItemGroupViewModelDelegate {
    var viewModel: MediaItemGroupViewModel
    var group: MediaItemGroup? {
        didSet {
            collectionView?.reloadData()
        }
    }
    var currentPage: Int

    private var timer: NSTimer?

    init() {
        viewModel = MediaItemGroupViewModel(path: "featured/artists")
        currentPage = 0
        super.init(collectionViewLayout: FeaturedArtistsCollectionViewController.provideLayout())

        viewModel.delegate = self
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.registerClass(FeaturedArtistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedArtistsCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.pagingEnabled = true

        timer = NSTimer.scheduledTimerWithTimeInterval(3.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)

        do {
            try viewModel.fetchData()
        } catch _ {}

    }

    func scrollToNextPage() {
        guard let collectionView = collectionView, let items = viewModel.groups.first?.items else {
            return
        }


        if currentPage <= items.count - 1 {
            let nextItem = NSIndexPath(forItem: currentPage, inSection: 0)
            collectionView.scrollToItemAtIndexPath(nextItem, atScrollPosition: .Left, animated: true)
            currentPage++
        } else {
            currentPage = 0
        }

    }


    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height / 3.33 - 10)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FeaturedArtistsCellReuseIdentifier, forIndexPath: indexPath) as? FeaturedArtistCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let artist = viewModel.groups.first?.items[indexPath.row] as? ArtistMediaItem else {
            return cell
        }

        // Configure the cell
        if let name = artist.name {
            cell.titleLabel.text = name.uppercaseString
        }
        
        cell.featureLabel.text = "Featured Artist".uppercaseString
        if let image = artist.image, let imageURL = NSURL(string: image) {
            cell.imageView.setImageWithAnimation(imageURL)
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        timer?.invalidate()
        showNavigationBar(true)

        guard let artistMediaItem = viewModel.groups.first?.items[indexPath.row] as? ArtistMediaItem else {
            return
        }

        let browseVC = BrowseArtistCollectionViewController(artistId: artistMediaItem.id, viewModel: BrowseViewModel())
        navigationController?.pushViewController(browseVC, animated: true)
        containerViewController?.resetPosition()
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView?.reloadData()
    }
}