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
    
    override init(frame: CGRect) {
        iphoneImageView = UIImageView()
        iphoneImageView.contentMode = .ScaleAspectFill
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
        switch currentPage
        {
        case  0:
            addConstraints([
                titleLabel.al_top == al_top + 40,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 18,
                
                subtitleLabel.al_top == titleLabel.al_bottom,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 80,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + 30,
                iphoneImageView.al_left == al_left + 20,
                iphoneImageView.al_right == al_right - 20
                ])
        case  3:
            addConstraints([
                titleLabel.al_top == al_top + 40,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 25,
                
                subtitleLabel.al_top == titleLabel.al_bottom,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 80,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + 40,
                iphoneImageView.al_left == al_left + 30,
                iphoneImageView.al_right == al_right - 30
                ])

        default:
            addConstraints([
                titleLabel.al_top == al_top + 40,
                titleLabel.al_left == al_left + 40,
                titleLabel.al_right == al_right - 40,
                titleLabel.al_height == 25,
                
                subtitleLabel.al_top == titleLabel.al_bottom,
                subtitleLabel.al_left == al_left + 30,
                subtitleLabel.al_right == al_right - 30,
                subtitleLabel.al_height == 80,
                
                iphoneImageView.al_top == subtitleLabel.al_bottom + 13,
                iphoneImageView.al_left == al_left + 20,
                iphoneImageView.al_right == al_right - 20
                ])

            
        }
        

    }

    
}