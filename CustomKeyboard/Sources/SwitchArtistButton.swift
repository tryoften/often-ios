//
//  SwitchArtistButton.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SwitchArtistButton: UIButton {
    
    var backgroundImage: UIImageView

    override init(frame: CGRect) {
        backgroundImage = UIImageView()
        super.init(frame: frame)
        
        addSubview(backgroundImage)
        backgroundColor = UIColor.blackColor()
        layer.cornerRadius = (SectionPickerViewSwitchArtistHeight) / 2
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        backgroundImage.frame = bounds
    }

}
