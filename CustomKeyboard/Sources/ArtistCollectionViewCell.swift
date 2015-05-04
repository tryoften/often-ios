//
//  ArtistCollectionViewCell.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.blackColor()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        
        titleLabel = UILabel()
        titleLabel.font = ArtistCollectionViewCellTitleFont
        titleLabel.textColor = ArtistCollectionViewCellTitleTextColor
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.font = ArtistCollectionViewCellSubtitleFont
        subtitleLabel.textColor = ArtistCollectionViewCellSubtitleTextColor
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.textAlignment = .Center

        super.init(frame: frame)
        
        backgroundColor = ArtistCollectionViewCellBackgroundColor
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        addCircularMaskToView(imageView, ArtistCollectionViewCellWidth - ArtistCollectionViewCellImageViewLeftMargin * 2)
        layer.cornerRadius = 5.0
        
        setupLayout()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            imageView.al_width == al_width - ArtistCollectionViewCellImageViewLeftMargin * 2,
            imageView.al_height == imageView.al_width,
            imageView.al_centerX == al_centerX,
            imageView.al_centerY == al_centerY - 30,
            
            titleLabel.al_top == imageView.al_bottom + 5,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_width == al_width - 15,
            titleLabel.al_height == 25,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_width == titleLabel.al_width,
            subtitleLabel.al_height == 15
        ]
        
        addConstraints(constraints)
    }
}
