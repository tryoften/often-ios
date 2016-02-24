//
//  CollectionViewAlphabeticalSidebar.swift
//  Often
//
//  Created by Kervins Valcourt on 2/3/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

let AlphabeticalSidebarIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]

class CollectionViewAlphabeticalSidebar: BDKCollectionIndexView {

    override init(frame: CGRect, indexTitles: [AnyObject]!) {
        super.init(frame: frame, indexTitles: indexTitles)

        touchStatusBackgroundColor = UIColor.clearColor()
        touchStatusViewAlpha = 0

        layer.borderWidth = 0.5
        layer.borderColor = UIColor(fromHexString: "#DDDDDD").CGColor
        backgroundColor = UIColor(hex: "#F8F8F8")
        font = UIFont(name: "OpenSans-Semibold", size: 6.5)
        alpha = 0.74
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
