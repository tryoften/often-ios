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
        
        var attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.oftWhiteColor()
        ]
        let browsePacksString = NSAttributedString(string: "browse packs".uppercaseString, attributes: attributes)
        
        backLabel = UILabel()
        backLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        backLabel.textColor = TrendingHeaderViewNameLabelTextColor
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backLabel.attributedText = browsePacksString
        
        attributes[NSFontAttributeName] = UIFont(name: "OpenSans-Semibold", size: 7.0)!
        let sampleString = NSAttributedString(string: "try sample".uppercaseString, attributes: attributes)
        
        sampleButton = UIButton()
        sampleButton.translatesAutoresizingMaskIntoConstraints = false
        sampleButton.setAttributedTitle(sampleString, forState: .Normal)
        sampleButton.backgroundColor = ClearColor
        sampleButton.layer.borderWidth = 1.5
        sampleButton.layer.borderColor = WhiteColor.CGColor
        sampleButton.layer.cornerRadius = 11.25
        
        priceButton = UIButton()
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.backgroundColor = TealColor
        priceButton.layer.cornerRadius = 15
        
        
        super.init(frame: frame)
        
        addSubview(backLabel)
        addSubview(sampleButton)
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
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_top  == titleLabel.al_bottom + 5,
            subtitleLabel.al_height == 30,
            
            priceButton.al_centerX == al_centerX,
            priceButton.al_top == subtitleLabel.al_bottom + 18,
            priceButton.al_width == 84,
            priceButton.al_height == 30,
            
            sampleButton.al_right == al_right - 16.5,
            sampleButton.al_height == 22.5,
            sampleButton.al_width == 78.5,
            sampleButton.al_top == al_top + 31,
            
            backLabel.al_centerY == sampleButton.al_centerY - 1,
            backLabel.al_left == al_left + 42.5
            
            ])
    }
}