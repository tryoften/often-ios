//
//  KeyboardWalkthroughView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 7/1/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class KeyboardWalkthroughView: UIView {
    var iphoneImageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var currentPage: Int
    let device = UIDevice.currentDevice()
    
    override init(frame: CGRect) {
        var contentMode = UIViewContentMode.ScaleAspectFill
        
        if  device.modelName.hasPrefix("iPhone 5") {
            contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        iphoneImageView = UIImageView()
        iphoneImageView.contentMode = contentMode
        iphoneImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 18)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "lastly, install october"
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "OpenSans", size: 14)
        subtitleLabel.alpha = 0.54
        subtitleLabel.textColor = UIColor(fromHexString: "#121314")
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
       
        currentPage = 0
        
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
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
        
        var titleLabelTopConstraintValue: CGFloat = 40
       
        var iphoneImageViewOneSideConstraintValue: CGFloat = 20
        var iphoneImageViewTwoSideConstraintValue: CGFloat = 30
        
        if device.modelName == "iPhone 6 Plus" {
            iphoneImageViewOneTopConstraintValue = 140.0
            iphoneImageViewTwoTopConstraintValue = 80.0
            iphoneImageViewThreeTopConstraintValue = 60.0
            
        } else if device.modelName.hasPrefix("iPhone 5") { // iPhone 5 & 5s
            iphoneImageViewOneTopConstraintValue = 0.0
            iphoneImageViewTwoTopConstraintValue = 0.0
            iphoneImageViewThreeTopConstraintValue = 0.0
            
            titleLabelTopConstraintValue = 10
            
            iphoneImageViewOneSideConstraintValue = 10
            iphoneImageViewTwoSideConstraintValue = 15
        } else {
            iphoneImageViewOneTopConstraintValue = 30.0
            iphoneImageViewTwoTopConstraintValue = 40.0
            iphoneImageViewThreeTopConstraintValue = 13.0
        }
        
        switch currentPage
        {
        case  0:
            addConstraints([
                titleLabel.al_top == al_top + titleLabelTopConstraintValue,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 18,
                
                subtitleLabel.al_top == titleLabel.al_bottom,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 80,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + iphoneImageViewOneTopConstraintValue,
                iphoneImageView.al_left == al_left + iphoneImageViewOneSideConstraintValue,
                iphoneImageView.al_right == al_right - iphoneImageViewOneSideConstraintValue
                ])
        case  3:
            addConstraints([
                titleLabel.al_top == al_top + titleLabelTopConstraintValue,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 25,
                
                subtitleLabel.al_top == titleLabel.al_bottom,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 80,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + iphoneImageViewTwoTopConstraintValue,
                iphoneImageView.al_left == al_left + iphoneImageViewTwoSideConstraintValue,
                iphoneImageView.al_right == al_right - iphoneImageViewTwoSideConstraintValue
                ])

        default:
            addConstraints([
                titleLabel.al_top == al_top + titleLabelTopConstraintValue,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 25,
                
                subtitleLabel.al_top == titleLabel.al_bottom,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 80,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + iphoneImageViewThreeTopConstraintValue,
                iphoneImageView.al_left == al_left + iphoneImageViewOneSideConstraintValue,
                iphoneImageView.al_right == al_right - iphoneImageViewOneSideConstraintValue
                ])

            
        }
        

    }

    
}