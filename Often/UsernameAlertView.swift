//
//  UsernameAlertView.swift
//  Often
//
//  Created by Katelyn Findlay on 7/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UsernameAlertView: AlertView {
    var textField: UITextField
    
    override init(frame: CGRect) {
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        actionButton.setTitle("save".uppercaseString, forState: .Normal)
        actionButton.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)
        
        titleLabel.text = "Choose a username fam"
        
        subtitleLabel.text = "Share your favorite content with anyone"
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
        
        addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        addConstraints([
            characterImageView.al_height == 120,
            characterImageView.al_width == 120,
            characterImageView.al_centerX == al_centerX,
            characterImageView.al_bottom == titleLabel.al_top - 5,
            
            titleLabel.al_centerY == al_centerY + 20,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 27,
            subtitleLabel.al_right == al_right - 27,
            subtitleLabel.al_height == 40,
            
            textField.al_top == subtitleLabel.al_bottom + 10,
            textField.al_height == 30,
            textField.al_left == al_left + 20,
            textField.al_right == al_right - 20,
            
            actionButton.al_centerX == al_centerX,
            actionButton.al_left == al_left + actionButtonLeftRightMargin,
            actionButton.al_right == al_right - actionButtonLeftRightMargin,
            actionButton.al_height == 40,
            actionButton.al_top == textField.al_bottom + 18
        ])
    }
}