//
//  SignUpOrLoginView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class ButtonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        var animationClass: CSAnimation.Type = CSAnimation.classForAnimationType("fadeInUp") as! CSAnimation.Type
        animationClass.performAnimationOnView(self, duration: 0.6, delay: 0.0)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SignUpOrLoginView: UIView {
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var buttonView: ButtonView
    var facebookButton: FacebookButton
    var artistsBgImageView: UIImageView
    var signUpButton: UIButton
    var buttonDivider: UIView
    var loginButton: UIButton
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = WalkthroughTitleFont
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var titleString = "October".uppercaseString
        var titleRange = NSMakeRange(0, count(titleString))
        var title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: titleLabel.font!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 3.2, range: titleRange)
        titleLabel.attributedText = title
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = SubtitleGreyColor
        subtitleLabel.font = HomeViewSubtitle
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "Share lyrics & songs from any of your favorite artists right from your keyboard."
        
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        artistsBgImageView = UIImageView()
        artistsBgImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistsBgImageView.contentMode = .ScaleAspectFit
        artistsBgImageView.image = UIImage(named: "ArtistsBackground")
        
        signUpButton = UIButton()
        signUpButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signUpButton.backgroundColor = BlackColor
        signUpButton.setTitle("sign up".uppercaseString, forState: .Normal)
        signUpButton.titleLabel!.font = ButtonFont
        signUpButton.setTitleColor(SignUpButtonFontColor, forState: .Normal)
        
        buttonDivider = UIView()
        buttonDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonDivider.backgroundColor = LightBlackColor
        
        buttonView = ButtonView()
        buttonView.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonView.backgroundColor = SignUpSpacerColor
        
        loginButton = UIButton()
        loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginButton.backgroundColor = BlackColor
        loginButton.setTitle("login".uppercaseString, forState: .Normal)
        loginButton.titleLabel!.font = ButtonFont
        loginButton.setTitleColor(SignUpButtonFontColor, forState: .Normal)
    
        super.init(frame: frame)
        
        backgroundColor = WalkthroughBackgroungColor
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(artistsBgImageView)
        addSubview(facebookButton)
        addSubview(buttonView)
        
        buttonView.addSubview(buttonDivider)
        buttonView.addSubview(signUpButton)
        buttonView.addSubview(loginButton)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 37,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_height == 60,
            
            signUpButton.al_top == buttonView.al_top,
            signUpButton.al_left == buttonView.al_left,
            signUpButton.al_right == buttonDivider.al_left,
            signUpButton.al_bottom == buttonView.al_bottom,
            
            loginButton.al_top == buttonView.al_top,
            loginButton.al_left == buttonDivider.al_right,
            loginButton.al_right == buttonView.al_right,
            loginButton.al_bottom == buttonView.al_bottom,
            
            buttonDivider.al_top == buttonView.al_top + 5,
            buttonDivider.al_width == 1.2,
            buttonDivider.al_centerX == buttonView.al_centerX,
            buttonDivider.al_bottom == buttonView.al_bottom - 5,
            
            buttonView.al_height == 50,
            buttonView.al_right == al_right,
            buttonView.al_left == al_left,
            buttonView.al_bottom == al_bottom,
            
            facebookButton.al_height == 60,
            facebookButton.al_bottom == buttonView.al_top,
            facebookButton.al_left == al_left,
            facebookButton.al_right == al_right,
            
            artistsBgImageView.al_width == al_width,
            artistsBgImageView.al_top == subtitleLabel.al_bottom + 10,
            artistsBgImageView.al_bottom == facebookButton.al_top - 20,
            artistsBgImageView.al_left == al_left
        ])
    }

}