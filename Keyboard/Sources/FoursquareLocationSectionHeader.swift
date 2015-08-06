//
//  FoursquareLocationSectionHeader.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class FoursquareLocationSectionHeader: UICollectionReusableView {
    let resultsLabel: UILabel
    var lineBreak: UIView
    var results: Int = 0
    
    override init(frame: CGRect) {
        resultsLabel = UILabel()
        resultsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        resultsLabel.font = BrowseSectionHeaderViewSongsLabelFont
        resultsLabel.text = "\(results) Results"
        
        lineBreak = UIView()
        lineBreak.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineBreak.backgroundColor = BrowseSectionHeaderViewLineBreakColor
        
        super.init(frame: frame)
        
        backgroundColor = BrowseSectionHeaderViewBackgroundColor
        
        addSubview(resultsLabel)
        addSubview(lineBreak)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            resultsLabel.al_top == al_top + 14,
            resultsLabel.al_left == al_left + 17,
            lineBreak.al_bottom == al_bottom,
            lineBreak.al_width == UIScreen.mainScreen().bounds.width,
            lineBreak.al_height == 1/2
        ])
    }
}
