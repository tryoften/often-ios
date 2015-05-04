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
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let buttonSize = self.frame.size
        let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
        let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
        var largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
        return (CGRectContainsPoint(largerFrame, point)) ? self : nil
    }

}
