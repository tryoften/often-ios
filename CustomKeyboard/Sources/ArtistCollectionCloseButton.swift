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

        icon.text = "\u{f10d}"
        icon.textAlignment = .Center
        icon.font = UIFont(name: "font_icons8", size: 20)
        icon.textColor = UIColor.whiteColor()
        addSubview(icon)
        backgroundColor = ArtistCollectionViewCloseButtonBackgroundColor
        
        setupLayout()
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setupLayout() {
        addConstraints([
            icon.al_centerX == al_centerX,
            icon.al_top == al_top + 100,
            icon.al_width == 20,
            icon.al_height == icon.al_width
        ])
    }
}
