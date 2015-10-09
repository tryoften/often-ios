//
//  KeyboardWalkthroughView.swift
//  Often
//
//  Created by Kervins Valcourt on 9/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
class KeyboardWalkthroughView: UIView {
    var iphoneImageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var currentPage: Int
    let device = UIDevice.currentDevice()
    
    override init(frame: CGRect) {
        var contentMode = UIViewContentMode.ScaleAspectFit
        var WalkthroughTitleLabelFront = UIFont(name: "OpenSans-Semibold", size: 18)
        var WalkthroughSubTitleLabelFront = UIFont(name: "OpenSans", size: 14)
        
        
        iphoneImageView = UIImageView()
        iphoneImageView.contentMode = contentMode
        iphoneImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.textColor = WalkthroughTitleFontColor
        titleLabel.alpha = 0.90
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.alpha = 0.74
        subtitleLabel.textColor = WalkthroughSubTitleFontColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currentPage = 0
        
        super.init(frame: frame)
        backgroundColor = KeyboardWalkthroughViewBackgroundColor
        
        addSubview(iphoneImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let iphoneImageViewOneTopConstraintValue: CGFloat
        let iphoneImageViewTwoTopConstraintValue: CGFloat
        let iphoneImageViewThreeTopConstraintValue: CGFloat
        let subtitleHeight: CGFloat
        
        var titleLabelTopConstraintValue: CGFloat = 40
        var iphoneImageViewOneSideConstraintValue: CGFloat = 20
        var iphoneImageViewTwoSideConstraintValue: CGFloat = 30
        
        
            iphoneImageViewOneTopConstraintValue = 30.0
            iphoneImageViewTwoTopConstraintValue = 40.0
            iphoneImageViewThreeTopConstraintValue = 13.0
            subtitleHeight = 80.00
        
        
        switch currentPage
        {
        case  0:
            addConstraints([
                titleLabel.al_top == al_top + 80,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 18,
                
                subtitleLabel.al_top == titleLabel.al_bottom + 10,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 70,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + 70,
                iphoneImageView.al_left == al_left + 40,
                iphoneImageView.al_right == al_right - 40,
                iphoneImageView.al_bottom == al_bottom + 50
                ])
        case  3:
            addConstraints([
                titleLabel.al_top == al_top + 80,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 18,
                
                subtitleLabel.al_top == titleLabel.al_bottom + 10,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 90,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + 70,
                iphoneImageView.al_left == al_left + 40,
                iphoneImageView.al_right == al_right - 40,
                iphoneImageView.al_bottom == al_bottom + 130
                ])
            
        default:
            addConstraints([
                titleLabel.al_top == al_top + 80,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 18,
                
                subtitleLabel.al_top == titleLabel.al_bottom + 10,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 70,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + 70,
                iphoneImageView.al_left == al_left + 40,
                iphoneImageView.al_right == al_right - 40,
                iphoneImageView.al_bottom == al_bottom + 50
                ])
            
            
        }
        
        
    }
    
    
}