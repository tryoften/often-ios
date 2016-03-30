//
//  PackBrowseCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackBrowseCollectionViewCell: ArtistCollectionViewCell {
    var primaryButton: UIButton
    
    override init(frame: CGRect) {
        primaryButton = UIButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 8.0)
        primaryButton.layer.cornerRadius = 11.25
        primaryButton.backgroundColor = BlackColor
        primaryButton.setTitle("download".uppercaseString, forState: .Normal)
        primaryButton.setTitle("remove".uppercaseString, forState: .Selected)
        primaryButton.setTitleColor(WhiteColor, forState: .Normal)
        primaryButton.setTitleColor(BlackColor, forState: .Selected)
        
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "future")
        titleLabel.text = "Queen B"
        subtitleLabel.text = "58 Lyrics"
        
        var layer = CAShapeLayer()
        layer.path = ArtistCollectionViewCell.drawImageMask(frame: CGRectMake(0, 0, PackCellWidth, PackCellHeight/2)).CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.frame = CGRectMake(0, 0, PackCellWidth, PackCellHeight)
        placeholderImageView.layer.mask = layer
        
        layer = CAShapeLayer()
        layer.path = ArtistCollectionViewCell.drawImageMask(frame: CGRectMake(0, 0, PackCellWidth, PackCellHeight/2)).CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.frame = CGRectMake(0, 0, PackCellWidth, PackCellHeight)
        imageView.layer.mask = layer
        
        primaryButton.addTarget(self, action: #selector(PackBrowseCollectionViewCell.primaryButtonSelected), forControlEvents: .TouchUpInside)
        
        addSubview(primaryButton)
        
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
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX,
            
            primaryButton.al_centerX == al_centerX,
            primaryButton.al_height == 22.5,
            primaryButton.al_width == 78,
            primaryButton.al_top == subtitleLabel.al_bottom + (bounds.size.height * 0.07)
        ])
    }
}
