//
//  PackBrowseCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackBrowseCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var coverView: UIView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var primaryButton: UIButton
    var shadowLayer: CAShapeLayer
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "bey")
        
        coverView = UIView()
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.backgroundColor = WhiteColor
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans", size: 15.0)
        titleLabel.textAlignment = .Center
        titleLabel.text = "Queen B"
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 9.0)
        subtitleLabel.textColor = LightBlackColor
        subtitleLabel.textAlignment = .Center
        subtitleLabel.text = "58 Lyrics"
        
        primaryButton = UIButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 8.0)
        primaryButton.layer.cornerRadius = 11.25
        primaryButton.backgroundColor = BlackColor
        primaryButton.setTitle("download".uppercaseString, forState: .Normal)
        primaryButton.setTitle("remove".uppercaseString, forState: .Selected)
        primaryButton.setTitleColor(WhiteColor, forState: .Normal)
        primaryButton.setTitleColor(BlackColor, forState: .Selected)
        
        shadowLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        primaryButton.addTarget(self, action: "primaryButtonSelected", forControlEvents: .TouchUpInside)
        
        layer.borderWidth = 0.5
        layer.borderColor = BlackColor.CGColor
        layer.cornerRadius = 3.0
        clipsToBounds = true
        
        addSubview(imageView)
        coverView.addSubview(titleLabel)
        coverView.addSubview(subtitleLabel)
        coverView.addSubview(primaryButton)
        addSubview(coverView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Ex. Download or Buy a pack
    func primaryButtonSelected() {
        if primaryButton.selected {
            primaryButton.backgroundColor = BlackColor
            primaryButton.selected = false
        } else {
            primaryButton.backgroundColor = WhiteColor
            primaryButton.selected = true
        }
    }
    
    func setupLayout() {
        addConstraints([
            imageView.al_left == al_left,
            imageView.al_right == al_right,
            imageView.al_top == al_top,
            imageView.al_bottom == al_centerY,
            
            coverView.al_left == al_left,
            coverView.al_right == al_right,
            coverView.al_bottom == al_bottom,
            coverView.al_top == al_centerY,
            
            titleLabel.al_centerX == coverView.al_centerX,
            titleLabel.al_top == coverView.al_top + 15,
            
            subtitleLabel.al_centerX == coverView.al_centerX,
            subtitleLabel.al_top == titleLabel.al_bottom,
            
            primaryButton.al_centerX == coverView.al_centerX,
            primaryButton.al_height == 22.5,
            primaryButton.al_width == 78,
            primaryButton.al_top == subtitleLabel.al_bottom + 10
        ])
    }
}
