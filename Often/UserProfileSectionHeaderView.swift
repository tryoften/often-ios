//
//  UserProfileSectionHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileSectionHeaderView: UICollectionReusableView {
    var trendingLabel: UILabel
    var bottomLineBreak: UIView
    var screenWidth: CGFloat
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        trendingLabel = UILabel()
        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
        trendingLabel.font = TrendingSectionHeaderViewTrendingLabelFont
        trendingLabel.text = "1 Service"
        
        bottomLineBreak = UIView()
        bottomLineBreak.translatesAutoresizingMaskIntoConstraints = false
        bottomLineBreak.backgroundColor = TrendingSectionHeaderViewBottomLineBreakBackgroundColor
        
        super.init(frame: frame)
        
        backgroundColor = TrendingSectionHeaderViewBackgroundColor
        
        addSubview(trendingLabel)
        addSubview(bottomLineBreak)
        
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            trendingLabel.al_bottom == al_bottom - 12,
            trendingLabel.al_left == al_left + 17,
            
            bottomLineBreak.al_bottom == al_bottom,
            bottomLineBreak.al_width == UIScreen.mainScreen().bounds.width,
            bottomLineBreak.al_height == 1/2
        ])
    }
}
