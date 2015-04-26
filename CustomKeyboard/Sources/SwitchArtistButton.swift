//
//  SwitchArtistButton.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SwitchArtistButton: UIButton {
    
    var artistImageView: UIImageView

    override init(frame: CGRect) {
        artistImageView = UIImageView()
        artistImageView.contentMode = .ScaleAspectFill

        super.init(frame: frame)
        
        addSubview(artistImageView)
        backgroundColor = UIColor.blackColor()
        layer.cornerRadius = (SectionPickerViewSwitchArtistHeight) / 2
        clipsToBounds = true
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        artistImageView.frame = bounds
    }

}
