//
//  ArtistBrowseCollectionViewFlowLayout.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/2/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistBrowseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    func provideCollectionFlowLayout() -> UICollectionViewFlowLayout {
        var viewLayout = ArtistBrowseCollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 40.0 /// The minimum spacing to use between items in the same row
        viewLayout.minimumLineSpacing = 40.0 /// The minimum spacing to use between lines of items in the grid
        viewLayout.itemSize = CGSize(width: 40.0, height: 40.0)
        //viewLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0) /// The margins used to lay out content in a section
        
        return viewLayout
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return BrowseCollectionViewLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeZero
    }
    
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes: BrowseCollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) as! BrowseCollectionViewLayoutAttributes
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributesArrayInRect = super.layoutAttributesForElementsInRect(rect) as? [BrowseCollectionViewLayoutAttributes]
        
        if attributesArrayInRect != nil {
            for attribs in attributesArrayInRect! {
                
            }
        }
        
        return attributesArrayInRect
    }
}
