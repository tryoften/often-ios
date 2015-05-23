//
//  ArtistPickerCollectionViewLayout.swift
//  Drizzy
//
//  Created by Luc Success on 5/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//


class ArtistPickerCollectionViewLayout: UICollectionViewFlowLayout {

    class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        var viewLayout = ArtistPickerCollectionViewLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 5.0
        viewLayout.minimumLineSpacing = 5.0
        viewLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 35.0, bottom: 5.0, right: 5.0)
        return viewLayout
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return ArtistPickerCollectionViewLayoutAttributes.self
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes: ArtistPickerCollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) as! ArtistPickerCollectionViewLayoutAttributes
        
        attributes.deleteButtonHidden = self.isDeletionModeOn()
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributesArrayInRect = super.layoutAttributesForElementsInRect(rect) as? [ArtistPickerCollectionViewLayoutAttributes]
        
        if attributesArrayInRect != nil {
            for attribs in attributesArrayInRect! {
                attribs.deleteButtonHidden = !self.isDeletionModeOn()
            }
        }
        
        return attributesArrayInRect
    }

    func isDeletionModeOn() -> Bool {
        if let collectionView = collectionView, delegate = collectionView.delegate {
            if delegate.conformsToProtocol(ArtistPickerCollectionViewLayoutDelegate) {
                var delegate = delegate as! ArtistPickerCollectionViewLayoutDelegate
                return delegate.isDeletionModeActiveForCollectionView(collectionView, layout: self)
            }
        }
        return true
    }
}

@objc protocol ArtistPickerCollectionViewLayoutDelegate {
    func isDeletionModeActiveForCollectionView(collectionView: UICollectionView, layout: UICollectionViewLayout) -> Bool
}
