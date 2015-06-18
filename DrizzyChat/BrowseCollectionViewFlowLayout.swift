//
//  BrowseCollectionViewFlowLayout.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/31/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BrowseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    class func provideCollectionFlowLayout() -> UICollectionViewFlowLayout {
        var viewLayout = BrowseCollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 15.0 /// The minimum spacing to use between items in the same row
        viewLayout.minimumLineSpacing = 15.0 /// The minimum spacing to use between lines of items in the grid
        viewLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 60.0, bottom: 10.0, right: 5.0)
        return viewLayout
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return BrowseCollectionViewLayoutAttributes.self
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
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

@objc protocol BrowseCollectionViewLayoutDelegate {
    /// methods to do later
    
    /// Did Swipe left or right (???)
}