//
//  TrendingSectionHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    Same as the Browse Section header but should have a black view above the artist/songs label
    that can tab between the two
    Probably need to remove the animations from the button presses

*/

class TrendingSectionHeaderView: UICollectionReusableView {
    var trendingLabel: UILabel
    var bottomLineBreak: UIView
    var screenWidth: CGFloat
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        trendingLabel = UILabel()
        trendingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        trendingLabel.font = TrendingSectionHeaderViewTrendingLabelFont
        trendingLabel.text = "TRENDING"
        
        bottomLineBreak = UIView()
        bottomLineBreak.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomLineBreak.backgroundColor = TrendingSectionHeaderViewBottomLineBreakBackgroundColor
        
        super.init(frame: frame)
        
        backgroundColor = TrendingSectionHeaderViewBackgroundColor
        
        addSubview(trendingLabel)
        addSubview(bottomLineBreak)
        
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
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
