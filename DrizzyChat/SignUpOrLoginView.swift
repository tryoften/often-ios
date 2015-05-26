//
//  SignUpOrLoginView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpOrLoginView: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var spacer: UIView!
    var facebookButton: FacebookButton
    var signUpButton: UIButton!
    var buttonSpacer: UIView!
    var loginButton: UIButton!
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = BaseFont
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "vsnclkxdmkl"
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = BaseFont
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "vsnclkxdmkl"
        
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        signUpButton = UIButton()
        signUpButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signUpButton.backgroundColor = UIColor.blackColor()
        signUpButton.setTitle("SIGN UP", forState: .Normal)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        buttonSpacer = UIView()
        buttonSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonSpacer.backgroundColor = UIColor.grayColor()
        
        loginButton = UIButton()
        loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginButton.backgroundColor = UIColor.blackColor()
        loginButton.setTitle("LOGIN IN", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(spacer)
        addSubview(facebookButton)
        addSubview(signUpButton)
        addSubview(buttonSpacer)
        addSubview(loginButton)
        
        setupLayout()

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            
            titleLabel.al_top == al_top + 60,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            
            spacer.al_top == titleLabel.al_bottom + 4,
            spacer.al_height == 1,
            spacer.al_width == 60,
            spacer.al_centerX == al_centerX,
            
            subtitleLabel.al_top == spacer.al_bottom + 10,
            subtitleLabel.al_left == al_left,
            subtitleLabel.al_right == al_right,
            subtitleLabel.al_height == 80,
            
            signUpButton.al_height == 50,
            signUpButton.al_left == al_left,
            signUpButton.al_right == buttonSpacer.al_left,
            signUpButton.al_bottom == al_bottom,
            
            buttonSpacer.al_height == 50,
            buttonSpacer.al_width == 1,
            buttonSpacer.al_centerX == al_centerX,
            buttonSpacer.al_bottom == al_bottom,
            
            loginButton.al_height == 50,
            loginButton.al_right == al_right,
            loginButton.al_left == buttonSpacer.al_right,
            loginButton.al_bottom == al_bottom,
            
            facebookButton.al_bottom == loginButton.al_top - 10,
            facebookButton.al_left == al_left + 10,
            facebookButton.al_right == al_right - 10
            
            ])
    }
    
}