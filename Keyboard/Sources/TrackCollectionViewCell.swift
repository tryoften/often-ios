//
//  TrackCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 12/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    private var placeholderImageView: UIImageView
    var imageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var disclosureIndicator: UIImageView
    var imageURL: NSURL? {
        willSet(newValue) {
            if let url = newValue where imageURL != newValue {
                imageView.setImageWithAnimation(url)
            }
        }
    }

    override init(frame: CGRect) {
        placeholderImageView = UIImageView()
        placeholderImageView.backgroundColor = MediumGrey
        placeholderImageView.image = UIImage(named: "placeholder")
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.layer.cornerRadius = 2.0
        placeholderImageView.clipsToBounds = true

        imageView = UIImageView()
        imageView.backgroundColor = MediumGrey
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 2.0
        imageView.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans", size: 12.0)
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 10.5)
        subtitleLabel.textColor = BlackColor
        subtitleLabel.alpha = 0.54
        
        disclosureIndicator = UIImageView()
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator.contentMode = .ScaleAspectFit
        disclosureIndicator.image = UIImage(named: "next")
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.14
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowRadius = 1
        
        contentView.layer.cornerRadius = 2.0
        contentView.clipsToBounds = true

        addSubview(placeholderImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(disclosureIndicator)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,

            imageView.al_left == al_left + 12,
            imageView.al_centerY == al_centerY,
            imageView.al_top == al_top + 12,
            imageView.al_bottom == al_bottom - 12,
            imageView.al_width == imageView.al_height,

            titleLabel.al_left == imageView.al_right + 12,
            titleLabel.al_bottom == imageView.al_centerY,

            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_top == imageView.al_centerY,

            disclosureIndicator.al_centerY == al_centerY,
            disclosureIndicator.al_right == al_right - 15,
            disclosureIndicator.al_height == 16.5,
            disclosureIndicator.al_width == 16.5
        ])
    }
}
