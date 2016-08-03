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
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        textField.returnKeyType = .Done
        textField.placeholder = "Username"
        textField.borderStyle = .RoundedRect
        textField.textAlignment = .Center
        textField.becomeFirstResponder()
        
        super.init(frame: frame)
        
        actionButton.setTitle("save".uppercaseString, forState: .Normal)
        actionButton.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)
        
        titleLabel.text = "Choose a username"
        
        subtitleLabel.text = "This lets you share your 🔥 pack with anyone"
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
                
        addSubview(textField)
    }
    
    func setTextFieldText(username: String) {
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 11.0)!,
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        let attributedString = NSAttributedString(string: username, attributes: attributes)
        textField.attributedText = attributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        addConstraints([
            
            characterImageView.al_height == 120,
            characterImageView.al_width == 120,
            characterImageView.al_centerX == al_centerX,
            characterImageView.al_top == al_top + 25,
            
            titleLabel.al_top == characterImageView.al_bottom + 12,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + subtitleLabelLeftRightMargin,
            subtitleLabel.al_right == al_right - subtitleLabelLeftRightMargin,
            subtitleLabel.al_height == 40,
            
            textField.al_top == subtitleLabel.al_bottom + 18,
            textField.al_left == al_left + 20,
            textField.al_right == al_right - 20,
            textField.al_centerX == al_centerX,
            
            actionButton.al_centerX == al_centerX,
            actionButton.al_left == al_left + actionButtonLeftRightMargin,
            actionButton.al_right == al_right - actionButtonLeftRightMargin,
            actionButton.al_height == 40,
            actionButton.al_top == textField.al_bottom + 18
        ])
    }
}