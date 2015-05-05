//
//  CategoryCollectionViewCell.swift
//  Drizzy
//
//  Created by Luc Success on 4/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var borderColor: UIColor!
    var highlightColorBorder: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CategoryCollectionViewCellBackgroundColor
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = CategoryCollectionViewCellTitleFont
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.textColor = CategoryCollectionViewCellSubtitleTextColor
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.font = CategoryCollectionViewCellSubtitleFont
        subtitleLabel.textAlignment = .Center
        
        highlightColorBorder = UIView(frame: CGRectZero)
        highlightColorBorder.setTranslatesAutoresizingMaskIntoConstraints(false)

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(highlightColorBorder)
        
        setupLayout()
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setupLayout() {
        addConstraints([
            highlightColorBorder.al_width == al_width,
            highlightColorBorder.al_left == al_left,
            highlightColorBorder.al_top == al_top,
            highlightColorBorder.al_height == 4.5,

            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY - 5,
            titleLabel.al_width == al_width,
            
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top == titleLabel.al_bottom + 2.0,
            subtitleLabel.al_width == titleLabel.al_width
        ])
    }
}
