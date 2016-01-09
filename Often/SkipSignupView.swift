//
//  SkipSignupView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SkipSignupView: UIView {
    let twitterLogoImageView: UIImageView
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let twitterSignupButton: UIButton
    let facebookSignupButton: UIButton
    let oftenAccountButton: UIButton
    let orSpacer: ViewSpacerWithText
    
    override init(frame: CGRect) {
        twitterLogoImageView = UIImageView()
        twitterLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        twitterLogoImageView.layer.cornerRadius = 40
        twitterLogoImageView.clipsToBounds = true
        twitterLogoImageView.image = UIImage(named: "twitteremptystate")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Create an Account"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Sign up with Twitter or Facebook\n to get unique lyric recommendations"
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12.0)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        
        twitterSignupButton = UIButton()
        twitterSignupButton.translatesAutoresizingMaskIntoConstraints = false
        twitterSignupButton.layer.cornerRadius = 5
        twitterSignupButton.setTitle("twitter".uppercaseString, forState: .Normal)
        twitterSignupButton.setTitleColor(WhiteColor, forState: .Normal)
        twitterSignupButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11.0)
        twitterSignupButton.backgroundColor = UIColor(fromHexString: "#62A9E0")
        
        oftenAccountButton = UIButton()
        oftenAccountButton.translatesAutoresizingMaskIntoConstraints = false
        oftenAccountButton.layer.cornerRadius = 5
        oftenAccountButton.setTitle("sign up with email".uppercaseString, forState: .Normal)
        oftenAccountButton.setTitleColor(WhiteColor, forState: .Normal)
        oftenAccountButton
            .titleLabel?.font = UIFont(name: "Montserrat", size: 11.0)
        oftenAccountButton.backgroundColor = UIColor(fromHexString: "#152036")
        
        orSpacer = ViewSpacerWithText(title:"Or")
        orSpacer.translatesAutoresizingMaskIntoConstraints = false
        orSpacer.backgroundColor = VeryLightGray

        facebookSignupButton = UIButton()
        facebookSignupButton.translatesAutoresizingMaskIntoConstraints = false
        facebookSignupButton.backgroundColor = FacebookButtonNormalBackgroundColor
        facebookSignupButton.setTitle("facebook".uppercaseString, forState: .Normal)
        facebookSignupButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        facebookSignupButton.setTitleColor(FacebookButtonTitleTextColor , forState: .Normal)
        facebookSignupButton.layer.cornerRadius = 4.0
        facebookSignupButton.clipsToBounds = true
        
        super.init(frame: frame)
        backgroundColor = VeryLightGray
        
        addSubview(twitterLogoImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(twitterSignupButton)
        addSubview(oftenAccountButton)
        addSubview(orSpacer)
        addSubview(facebookSignupButton)

        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            twitterLogoImageView.al_centerX == al_centerX,
            twitterLogoImageView.al_bottom == titleLabel.al_top - 15,
            twitterLogoImageView.al_width == 80,
            twitterLogoImageView.al_height == 80,
            
            titleLabel.al_bottom == subtitleLabel.al_top,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_height == 17,
            titleLabel.al_width == 200,
            
            subtitleLabel.al_bottom == twitterSignupButton.al_top - 10,
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_height == 50,
            subtitleLabel.al_width == 300,
            
            twitterSignupButton.al_top == al_centerY,
            twitterSignupButton.al_centerX == al_centerX,
            twitterSignupButton.al_left == al_left + 40,
            twitterSignupButton.al_right == al_centerX - 2,
            twitterSignupButton.al_height == 50,

            facebookSignupButton.al_top == twitterSignupButton.al_top,
            facebookSignupButton.al_centerX == al_centerX,
            facebookSignupButton.al_left == al_centerX + 2,
            facebookSignupButton.al_right == al_right - 40,
            facebookSignupButton.al_height == 50,
            
            orSpacer.al_top == facebookSignupButton.al_bottom + 20,
            orSpacer.al_left == al_left + 40,
            orSpacer.al_right == al_right - 40,
            orSpacer.al_height == 20,

            oftenAccountButton.al_top == orSpacer.al_bottom + 20,
            oftenAccountButton.al_centerX == al_centerX,
            oftenAccountButton.al_left == al_left + 40,
            oftenAccountButton.al_right == al_right - 40,
            oftenAccountButton.al_height == 50
            ])
    }

}