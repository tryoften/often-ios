//
//  CollectionViewAlphabeticalSidebar.swift
//  Often
//
//  Created by Kervins Valcourt on 2/3/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class CollectionViewAlphabeticalSidebar: BDKCollectionIndexView {

    override init(frame: CGRect, indexTitles: [AnyObject]!) {
        super.init(frame: frame, indexTitles: indexTitles)

        touchStatusBackgroundColor = UIColor(hex: "#D8D8D8")
        backgroundColor = UIColor(hex: "#F8F8F8")
        font = UIFont(name: "OpenSans-Semibold", size: 6.5)
        alpha = 0.74
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
