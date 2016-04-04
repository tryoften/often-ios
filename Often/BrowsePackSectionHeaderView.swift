//
//  BrowsePackSectionHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowsePackSectionHeaderView: UICollectionReusableView {
    var leftLabel: UILabel
    var rightLabel: UILabel
    var bottomBorderView: UIView
    var topBorderView: UIView
    
    override init(frame: CGRect) {
        leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        leftLabel.textColor = BlackColor
        leftLabel.text = "all packs".uppercaseString
        
        rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        rightLabel.textColor = BlackColor
        rightLabel.text = "(10)"
        
        bottomBorderView = UIView()
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.backgroundColor = LightGrey
        
        topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = LightGrey
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(bottomBorderView)
        addSubview(topBorderView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            leftLabel.al_left == al_left + 10,
            leftLabel.al_centerY == al_centerY,
            
            rightLabel.al_right == al_right - 10,
            rightLabel.al_centerY == al_centerY,
            
            bottomBorderView.al_left == al_left,
            bottomBorderView.al_right == al_right,
            bottomBorderView.al_bottom == al_bottom,
            bottomBorderView.al_height == 0.5,
            
            topBorderView.al_left == al_left,
            topBorderView.al_right == al_right,
            topBorderView.al_top == al_top,
            topBorderView.al_height == 0.5
        ])
    }
}
