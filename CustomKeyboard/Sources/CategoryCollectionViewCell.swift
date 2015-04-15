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
        backgroundColor = UIColor(fromHexString: "#1c1c1c")
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = UIFont(name: "Lato-Regular", size: 15)
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.textColor = UIColor(fromHexString: "#aeb5b8")
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.font = UIFont(name: "Lato-Regular", size: 12)
        subtitleLabel.textAlignment = .Center
        
        highlightColorBorder = UIView(frame: CGRectZero)
        highlightColorBorder.setTranslatesAutoresizingMaskIntoConstraints(false)
        highlightColorBorder.backgroundColor = UIColor(fromHexString: "#e85769")

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
            highlightColorBorder.al_height == 5,

            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY - 10,
            titleLabel.al_width == al_width,
            
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top == titleLabel.al_bottom + 5,
            subtitleLabel.al_width == titleLabel.al_width
        ])
    }
}
