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
    var circleLayer: CAShapeLayer
    var circleView: UIView

    override init(frame: CGRect) {
        artistImageView = UIImageView()
        artistImageView.contentMode = .ScaleAspectFill
        
        circleView = UIView()
        
        circleLayer = CAShapeLayer()
        var width = SectionPickerViewSwitchArtistHeight + 4
        var circularPath = UIBezierPath(roundedRect: CGRectMake(1.0, 1.0, width, width), cornerRadius: CGFloat(width / 2))
        circleLayer.path = circularPath.CGPath
        circleLayer.lineWidth = 1.0
        circleLayer.strokeColor = UIColor(fromHexString: "#f19720").CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor

        super.init(frame: frame)
        
        addSubview(artistImageView)
        addSubview(circleView)
    
        circleView.layer.addSublayer(circleLayer)
        artistImageView.layer.cornerRadius = (SectionPickerViewSwitchArtistHeight) / 2
        artistImageView.clipsToBounds = true
        backgroundColor = UIColor.clearColor()
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        artistImageView.frame = bounds
        circleView.frame = CGRectInset(artistImageView.frame, -3, -3)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let buttonSize = self.frame.size
        let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
        let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
        var largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
        return (CGRectContainsPoint(largerFrame, point)) ? self : nil
    }

}
