//
//  PackPageHeaderView.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackPageHeaderView : MediaItemPageHeaderView {
    
    var priceButton: UIButton
    var sampleButton: UIButton
    var backLabel: UILabel
    
    override init(frame: CGRect) {
        
        backLabel = UILabel()
        backLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        backLabel.textColor = TrendingHeaderViewNameLabelTextColor
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backLabel.text = "browse packs".uppercaseString
        
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 8.0)!,
            NSForegroundColorAttributeName: UIColor.oftWhiteColor()
        ]
        let attributedString = NSAttributedString(string: "try sample".uppercaseString, attributes: attributes)
        
        priceButton = UIButton()
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.setAttributedTitle(attributedString, forState: .Normal)
        priceButton.backgroundColor = ClearColor
        priceButton.layer.borderWidth = 1.5
        priceButton.layer.borderColor = WhiteColor.CGColor
        priceButton.layer.cornerRadius = 11.25
        
        sampleButton = UIButton()
        
        super.init(frame: frame)
        
        addSubview(priceButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        addConstraints([
            coverPhoto.al_top == al_top,
            coverPhoto.al_left == al_left,
            coverPhoto.al_width == al_width,
            coverPhoto.al_height == al_height,
            
            coverPhotoTintView.al_width == coverPhoto.al_width,
            coverPhotoTintView.al_height == coverPhoto.al_height,
            coverPhotoTintView.al_left == coverPhoto.al_left,
            coverPhotoTintView.al_top == coverPhoto.al_top,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_top >= al_top + 30,
            titleLabel.al_height == 22,
            titleLabel.al_width <= al_width - 30,
            
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top  == titleLabel.al_bottom + 5,
            
            priceButton.al_right == al_right - 18,
            priceButton.al_height == 22.5,
            priceButton.al_width == 78.5,
            priceButton.al_top == al_top + 15
            ])
    }
}