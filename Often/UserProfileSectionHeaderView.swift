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
    override init(frame: CGRect) {
        trendingLabel = UILabel()
        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
        trendingLabel.font = TrendingSectionHeaderViewTrendingLabelFont
        trendingLabel.textColor = UIColor(fromHexString: "#121314")
        trendingLabel.alpha = 0.54
        trendingLabel.text = "1 Service".uppercaseString
        
        
        super.init(frame: frame)
        
        backgroundColor = VeryLightGray
        
        addSubview(trendingLabel)
        
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            trendingLabel.al_top == al_top + 6,
            trendingLabel.al_bottom == al_bottom - 4,
            trendingLabel.al_left == al_left + 17,
        
        ])
    }
}
