//
//  AddArtistModalCollectionViewFlowLayout.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class AddArtistModalCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    
    class func provideCollectionFlowLayout() -> UICollectionViewFlowLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 450)
        flowLayout.itemSize = CGSizeMake(screenWidth, 70) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false /// allow sticky header for dragging down the table view
        return flowLayout
    }
}
