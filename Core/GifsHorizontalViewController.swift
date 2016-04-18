//
//  GifsHorizontalViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 4/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

private let GifCellReuseIdentifier = "GifCell"


class GifsHorizontalViewController: MediaItemsCollectionBaseViewController {
    var group: MediaItemGroup? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: GifsHorizontalViewController.provideLayout())
        #if KEYBOARD
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)
        #endif
        collectionView?.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCellReuseIdentifier)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsHorizontalScrollIndicator = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(171.5, 100)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 9, right: 10.0)
        return layout
    }
    
    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let group = group {
            return group.items.count
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(171.5, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GifCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.reset()
        
        guard let gif = group?.items[indexPath.row] as? GifMediaItem else {
            return cell
        }
        
        if let imageURL = gif.mediumImageURL {
            cell.gifURL = imageURL
        }
        
        cell.mediaLink = gif
        cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(gif)
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell {
            cell.overlayVisible = !cell.overlayVisible
        }
    }
}