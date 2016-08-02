//
//  PackProfileCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackProfileCollectionViewCell: BrowseMediaItemCollectionViewCell {
    var primaryButton: UIButton
    var disclosureIndicator: UIImageView
    weak var delegate: PackCellDeletable?

    override init(frame: CGRect) {
        primaryButton = UIButton()
        
        disclosureIndicator = UIImageView()
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator.image = StyleKit.imageOfDisclosureIndicatorCanvas(color: UIColor.lightGrayColor())
        disclosureIndicator.contentMode = .ScaleAspectFit
        
        super.init(frame: frame)
        
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.hidden = true
        primaryButton.setImage(StyleKit.imageOfDeleteCanvas(color: UIColor(red: 232.0/255.0, green: 87.0/255.0, blue: 105.0/255.0, alpha: 1.0)), forState: .Normal)
        
        imageView.layer.cornerRadius = 2.0
        
        addSubview(primaryButton)
        addSubview(disclosureIndicator)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func deleteCellTapped() {
        delegate?.didDeletePackCell()
    }
    
    override func setupLayout() {
        addConstraints([
            imageView.al_width == 50,
            imageView.al_height == 50,
            imageView.al_centerY == al_centerY,
            imageView.al_left == al_left + 12,
            
            addedBadgeView.al_width == 36,
            addedBadgeView.al_height == addedBadgeView.al_width,
            addedBadgeView.al_right == al_right - 12,
            addedBadgeView.al_top == al_top + 96,
            
            shareButton.al_width == 40,
            shareButton.al_height == shareButton.al_width,
            shareButton.al_top == al_top,
            shareButton.al_right == al_right,
            
            newPackBadge.al_centerY == al_centerY,
            newPackBadge.al_right == al_right - 16,
            newPackBadge.al_width == 44,
            newPackBadge.al_height == 21,
            
            updatedContentBadge.al_centerY == al_centerY,
            updatedContentBadge.al_right == al_right - 16,
            updatedContentBadge.al_width == 66,
            updatedContentBadge.al_height == 21,
            
            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,
            
            titleLabel.al_bottom == al_centerY,
            titleLabel.al_left == imageView.al_right + contentEdgeInsets.left,
            titleLabel.al_right == al_right - contentEdgeInsets.right,
            
            highlightColorBorder.al_width == al_width,
            highlightColorBorder.al_left == al_left,
            highlightColorBorder.al_bottom == al_bottom,
            highlightColorBorder.al_height == 4.5,
            
            subtitleLabel.al_top == al_centerY,
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_width == titleLabel.al_width,
            
            disclosureIndicator.al_right == al_right - contentEdgeInsets.right,
            disclosureIndicator.al_width == 18,
            disclosureIndicator.al_height == 32,
            disclosureIndicator.al_centerY == al_centerY,
            
            primaryButton.al_centerY == disclosureIndicator.al_centerY,
            primaryButton.al_centerX == disclosureIndicator.al_centerX - 10,
            primaryButton.al_width == 25,
            primaryButton.al_height == primaryButton.al_width
        ])
    }
}

protocol PackCellDeletable: class {
    func didDeletePackCell()
}