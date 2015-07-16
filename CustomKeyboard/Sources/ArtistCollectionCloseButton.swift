//
//  ArtistCollectionCloseButton.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistCollectionCloseButton: UIButton {
    var icon: UILabel
    
    override init(frame: CGRect) {
        icon = UILabel()
        icon.setTranslatesAutoresizingMaskIntoConstraints(false)
        super.init(frame: frame)
        
        setImage(UIImage(named: "close artists"), forState: .Normal)

        backgroundColor = BlackColor
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
}
