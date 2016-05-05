//
//  BrowsePackCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowsePackCollectionViewCell: BrowseMediaItemCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.image = UIImage(named: "placeholder")
        setImageViewLayers(CGRectMake(0, 0, frame.size.width, frame.size.height/2))

        setupLayout()
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

            addedBadgeView.al_width == 36,
            addedBadgeView.al_height == addedBadgeView.al_width,
            addedBadgeView.al_right == al_right - 12,
            addedBadgeView.al_top == al_top + 96,

            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,
            
            titleLabel.al_top == al_centerY + (bounds.size.height * 0.1),
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX,
        ])
    }
}
