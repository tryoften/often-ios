//
//  SignUpAddArtistsTableViewHeaderView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/14/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpAddArtistsTableViewHeaderView: UIView {
    var recommendedLabel : UILabel
    var spacer : UIView
    
    override init(frame: CGRect) {
        recommendedLabel = UILabel()
        spacer = UIView()
        
        let titleString = "recommended".uppercaseString
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        
        recommendedLabel.attributedText = title
        recommendedLabel.font = SelectArtistWalkthroughViewControllerRecommendedLabelFont
        
        spacer.backgroundColor = SelectArtistWalkthroughViewControllerSpacerColor
        
        super.init(frame: frame)
        
        backgroundColor = SelectArtistWalkthroughViewControllerHeaderViewColor
        addSubview(recommendedLabel)
        addSubview(spacer)
        
        setupLayout()
    }

    func setupLayout() {
        addConstraints([
            recommendedLabel.al_top == al_top + 8,
            recommendedLabel.al_left == al_left + 20,
            recommendedLabel.al_bottom == al_bottom + 8,
            recommendedLabel.al_right == al_right - 20,
            recommendedLabel.al_height == 34,
            
            spacer.al_right == al_right,
            spacer.al_left == al_left,
            spacer.al_height == 0.6,
            spacer.al_bottom == al_bottom
            
            ])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}