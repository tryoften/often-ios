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
    var artistsBgImageView: UIImageView
    var signUpButton: UIButton!
    var buttonSpacer: UIView!
    var loginButton: UIButton!
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Oswald-Regular", size: 19)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var titleString = "October".uppercaseString
        var titleRange = NSMakeRange(0, count(titleString))
        var title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: titleLabel.font!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 3.2, range: titleRange)
        titleLabel.attributedText = title
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.74)
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "October lets you share lyrics & songs from any of your favorite artists via text, email, or existing social apps... all right from your keyboard."
        
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        artistsBgImageView = UIImageView()
        artistsBgImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistsBgImageView.contentMode = .ScaleAspectFit
        artistsBgImageView.image = UIImage(named: "ArtistsBackground")
        
        signUpButton = UIButton()
        signUpButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signUpButton.backgroundColor = UIColor.blackColor()
        signUpButton.setTitle("sign up".uppercaseString, forState: .Normal)
        signUpButton.titleLabel!.font = UIFont(name: "OpenSans", size: 15)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        buttonSpacer = UIView()
        buttonSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonSpacer.backgroundColor = UIColor.grayColor()
        
        loginButton = UIButton()
        loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginButton.backgroundColor = UIColor.blackColor()
        loginButton.setTitle("login".uppercaseString, forState: .Normal)
        loginButton.titleLabel!.font = UIFont(name: "OpenSans", size: 15)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(spacer)
        addSubview(artistsBgImageView)
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
            
            titleLabel.al_top == al_top + 55,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            
            spacer.al_top == titleLabel.al_bottom + 10,
            spacer.al_height == 1,
            spacer.al_width == 38,
            spacer.al_centerX == al_centerX,
            
            subtitleLabel.al_top == spacer.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_height == 70,
            
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
            
            facebookButton.al_height == 60,
            facebookButton.al_bottom == loginButton.al_top - 10,
            facebookButton.al_left == al_left + 10,
            facebookButton.al_right == al_right - 10,
            
            artistsBgImageView.al_width == al_width,
            artistsBgImageView.al_top == subtitleLabel.al_bottom + 10,
            artistsBgImageView.al_bottom == facebookButton.al_top + 16,
            artistsBgImageView.al_left == al_left
        ])
    }

}