//
//  MessageWithButtonHeaderReusableView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class MessageWithButtonHeaderView: UICollectionReusableView {
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var primaryButton: UIButton
    var closeButton: UIButton
    var bottomBorderView: UIView
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12.0)
        subtitleLabel.textColor = UIColor(fromHexString: "#202020")
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.alpha = 0.54
        
        primaryButton = UIButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        primaryButton.setTitleColor(WhiteColor, forState: .Normal)
        primaryButton.layer.cornerRadius = 18.0
        primaryButton.clipsToBounds = true
        primaryButton.backgroundColor = TealColor
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(StyleKit.imageOfButtonclose(scale: 0.75), forState: .Normal)
        closeButton.alpha = 0.54
        
        bottomBorderView = UIView()
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.backgroundColor = DarkGrey
        
        super.init(frame: frame)
                
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(primaryButton)
        addSubview(closeButton)
        addSubview(bottomBorderView)
        
        clipsToBounds = true;
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == al_top + 20,
            
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top == titleLabel.al_bottom + 4,
            
            primaryButton.al_centerX == al_centerX,
            primaryButton.al_top == subtitleLabel.al_bottom + 10,
            primaryButton.al_width == 140,
            primaryButton.al_height == 35,
            
            closeButton.al_height == 35,
            closeButton.al_width == 35,
            closeButton.al_top == al_top + 10,
            closeButton.al_right == al_right - 10,
            
            bottomBorderView.al_left == al_left,
            bottomBorderView.al_right == al_right,
            bottomBorderView.al_bottom == al_bottom,
            bottomBorderView.al_height == 0.6
        ])
    }
}
