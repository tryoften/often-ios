//
//  PacksHorizontalViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 6/15/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PacksHorizontalViewController: MediaItemsCollectionBaseViewController {
    var group: [MediaItem]? {
        didSet {
            collectionView?.reloadData()
        }
    }

    init() {
        super.init(collectionViewLayout: PacksHorizontalViewController.provideLayout())
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(135, 205)
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
        if let items = group {
            return items.count
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(135, 205)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        
            guard let result = group?[indexPath.row], pack = result as? PackMediaItem, let id = pack.pack_id else {
                return
            }
            
            let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
            navigationController?.navigationBar.hidden = false
            navigationController?.pushViewController(packVC, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        cell = parsePackItemData(group, indexPath: indexPath, collectionView: collectionView) as BrowseMediaItemCollectionViewCell
        return cell
    }
}