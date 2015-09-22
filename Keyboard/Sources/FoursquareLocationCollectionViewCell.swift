//
//  FoursquareLocationCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class FoursquareLocationCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var titleLabel: UILabel
    var addressLabel: UILabel
    var ratingLabel: UILabel
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 2.0
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont(name: "OpenSans", size: 14.0)
        addressLabel.textColor = SubtitleGreyColor
        
        ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.layer.cornerRadius = 3.0
        ratingLabel.textColor = WhiteColor
        
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(ratingLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRatingBackgroundColor(score: Double) {
        if score < 5.0 {
            ratingLabel.backgroundColor = UIColor.redColor()
        } else if score >= 5.0 && score < 7.0 {
            ratingLabel.backgroundColor = UIColor.yellowColor()
        } else if score >= 7.0 && score < 9.0 {
            ratingLabel.backgroundColor = UIColor.greenColor() // light green
        } else {
            ratingLabel.backgroundColor = UIColor.greenColor() // dark green
        }
    }
    
    func setupLayout() {
        addConstraints([
            imageView.al_left == al_left + 15,
            imageView.al_top == al_top + 15,
            imageView.al_width == 30,
            imageView.al_height == 30,
            
            titleLabel.al_left == imageView.al_right + 5,
            titleLabel.al_top == al_top + 15,
            
            addressLabel.al_top == titleLabel.al_bottom,
            addressLabel.al_left == imageView.al_right + 5,
            
            ratingLabel.al_height == 40,
            ratingLabel.al_height == 30,
            ratingLabel.al_left == addressLabel.al_right + 5,
            ratingLabel.al_top == al_top + 15
        ])
    }
}
