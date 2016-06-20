//
//  PreheatingDemoViewController.swift
//  Nuke
//
//  Copyright (c) 2016 Alexander Grebenyuk (github.com/kean). All rights reserved.
//

import UIKit
import Nuke
import Preheat

private let cellReuseID = "reuseID"

class PreheatingDemoViewController: UICollectionViewController, PreheatControllerDelegate {
    var photos: [NSURL]!
    var preheatController: PreheatController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photos = demoPhotosURLs
        self.preheatController = PreheatControllerForCollectionView(collectionView: self.collectionView!)
        self.preheatController.delegate = self
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseID)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateItemSize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.preheatController.enabled = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.preheatController.enabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateItemSize()
    }
    
    func updateItemSize() {
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        let itemsPerRow = 4
        let side = (Double(self.view.bounds.size.width) - Double(itemsPerRow - 1) * 2.0) / Double(itemsPerRow)
        layout.itemSize = CGSize(width: side, height: side)
    }
    
    // MARK: UICollectionView
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseID, forIndexPath: indexPath)
        cell.backgroundColor = UIColor(white: 235.0 / 255.0, alpha: 1.0)
        
        let imageView = self.imageViewForCell(cell)
        let imageURL = self.photos[indexPath.row]
        imageView.image = nil
        imageView.nk_setImageWith(self.imageRequestWithURL(imageURL))
        
        return cell
    }
    
    func imageRequestWithURL(URL: NSURL) -> ImageRequest {
        func imageTargetSize() -> CGSize {
            let size = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let scale = UIScreen.mainScreen().scale
            return CGSize(width: size.width * scale, height: size.height * scale)
        }
        
        return ImageRequest(URL: URL, targetSize: imageTargetSize(), contentMode: .AspectFill)
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.imageViewForCell(cell).nk_cancelLoading()
    }
    
    func imageViewForCell(cell: UICollectionViewCell) -> UIImageView {
        var imageView = cell.viewWithTag(15) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.bounds)
            imageView!.autoresizingMask =  [.FlexibleWidth, .FlexibleHeight]
            imageView!.tag = 15
            imageView!.contentMode = .ScaleAspectFill
            imageView!.clipsToBounds = true
            cell.addSubview(imageView!)
        }
        return imageView!
    }
    
    // MARK: PreheatControllerDelegate

    func preheatControllerDidUpdate(controller: PreheatController, addedIndexPaths: [NSIndexPath], removedIndexPaths: [NSIndexPath]) {
        func requestForIndexPaths(indexPaths: [NSIndexPath]) -> [ImageRequest] {
            return indexPaths.map { return self.imageRequestWithURL(self.photos[$0.row]) }
        }
        Nuke.startPreheatingImages(requestForIndexPaths(addedIndexPaths))
        Nuke.stopPreheatingImages(requestForIndexPaths(removedIndexPaths))
        self.logAddedIndexPaths(addedIndexPaths, removedIndexPaths: removedIndexPaths)
    }
    
    func logAddedIndexPaths(addedIndexPath: [NSIndexPath], removedIndexPaths: [NSIndexPath]) {
        func stringForIndexPaths(indexPaths: [NSIndexPath]) -> String {
            guard indexPaths.count > 0 else {
                return "[]"
            }
            let items = indexPaths.map{ return "\($0.item)" }.joinWithSeparator(" ")
            return "[\(items)]"
        }
        print("did change preheat rect with added indexes \(stringForIndexPaths(addedIndexPath)), removed indexes \(stringForIndexPaths(removedIndexPaths))")
    }
}
