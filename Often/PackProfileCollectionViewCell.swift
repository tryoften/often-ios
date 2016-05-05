//
//  PackProfileCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackProfileCollectionViewCell: BrowsePackCollectionViewCell {
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        primaryButton.backgroundColor = UIColor.oftWhiteThreeColor()
        primaryButton.setTitle("remove".uppercaseString, forState: .Normal)
        primaryButton.titleLabel?.font = UIFont(name: "Montserrat", size: 8)
        primaryButton.layer.cornerRadius = 0
        primaryButton.setTitleColor(BlackColor, forState: .Normal)
        primaryButton.layer.shadowRadius = 3
        primaryButton.layer.shadowOpacity = 0
        primaryButton.layer.shadowColor = ClearColor.CGColor
        primaryButton.layer.shadowOffset = CGSizeMake(0, -3)
        
        imageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        titleLabel.font = UIFont(name: "OpenSans", size: 14)
        subtitleLabel.text = ""
        subtitleLabel.font = UIFont(name: "OpenSans", size: 9)
        subtitleLabel.alpha = 0.54

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupLayout() {
        addConstraints([
            imageView.al_width == al_width,
            imageView.al_height == imageView.al_width,
            imageView.al_centerX == al_centerX,
            imageView.al_top == al_top,

            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,
            
            titleLabel.al_top == al_centerY + (bounds.size.height * 0.1),
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_left == al_left + 14,
            titleLabel.al_right == al_right - 14,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_left == al_left + 14,
            subtitleLabel.al_right == al_right - 14,

            primaryButton.al_bottom == al_bottom,
            primaryButton.al_height == 27,
            primaryButton.al_left == al_left,
            primaryButton.al_right == al_right,
            ])
    }

}