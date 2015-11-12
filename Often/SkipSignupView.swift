//
//  SkipSignupView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SkipSignupView: UIView {
    var twitterLogoImageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var twitterSignupButton: UIButton
    var oftenAccountButton: UIButton
    var leftDividerLine: UIView
    var rightDividerLine: UIView
    var orLabel: UILabel
    
    override init(frame: CGRect) {
        twitterLogoImageView = UIImageView()
        twitterLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        twitterLogoImageView.layer.cornerRadius = 40
        twitterLogoImageView.clipsToBounds = true
        twitterLogoImageView.image = UIImage(named: "twitteremptystate")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Sign up with Twitter"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Often works even better with Twitter. In the\n future, any links you like there are saved here."
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12.0)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        
        twitterSignupButton = UIButton()
        twitterSignupButton.translatesAutoresizingMaskIntoConstraints = false
        twitterSignupButton.layer.cornerRadius = 5
        twitterSignupButton.setTitle("SIGN UP WITH TWITTER", forState: .Normal)
        twitterSignupButton.setTitleColor(WhiteColor, forState: .Normal)
        twitterSignupButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11.0)
        twitterSignupButton.backgroundColor = UIColor(fromHexString: "#62A9E0")
        
        oftenAccountButton = UIButton()
        oftenAccountButton.translatesAutoresizingMaskIntoConstraints = false
        oftenAccountButton.layer.cornerRadius = 5
        oftenAccountButton.setTitle("CREATE A FREE ACCOUNT", forState: .Normal)
        oftenAccountButton.setTitleColor(WhiteColor, forState: .Normal)
        oftenAccountButton
            .titleLabel?.font = UIFont(name: "Montserrat", size: 11.0)
        oftenAccountButton.backgroundColor = UIColor(fromHexString: "#152036")
        
        leftDividerLine = UIView()
        leftDividerLine.translatesAutoresizingMaskIntoConstraints = false
        leftDividerLine.backgroundColor = LightGrey
        
        rightDividerLine = UIView()
        rightDividerLine.translatesAutoresizingMaskIntoConstraints = false
        rightDividerLine.backgroundColor = LightGrey
        
        orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.text = "Or"
        orLabel.textColor = LightGrey
        orLabel.font = UIFont(name: "OpenSans-Italic", size: 12.0)
        
        super.init(frame: frame)
        backgroundColor = VeryLightGray
        
        addSubview(twitterLogoImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(twitterSignupButton)
        addSubview(oftenAccountButton)
        addSubview(leftDividerLine)
        addSubview(rightDividerLine)
        addSubview(orLabel)
        
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
            subtitleLabel.al_height == 80,
            subtitleLabel.al_width == 300,
            
            twitterSignupButton.al_top == al_centerY,
            twitterSignupButton.al_centerX == al_centerX,
            twitterSignupButton.al_left == al_left + 40,
            twitterSignupButton.al_right == al_right - 40,
            twitterSignupButton.al_height == 50,
            
            orLabel.al_centerX == al_centerX,
            orLabel.al_top == twitterSignupButton.al_bottom + 20,
            orLabel.al_width == 20,
            orLabel.al_height == 20,
            
            leftDividerLine.al_left == twitterSignupButton.al_left,
            leftDividerLine.al_right == orLabel.al_left - 20,
            leftDividerLine.al_height == 1,
            leftDividerLine.al_centerY == orLabel.al_centerY,
            
            rightDividerLine.al_right == twitterSignupButton.al_right,
            rightDividerLine.al_left == orLabel.al_right + 20,
            rightDividerLine.al_height == 1,
            rightDividerLine.al_centerY == orLabel.al_centerY,
            
            oftenAccountButton.al_top == orLabel.al_bottom + 20,
            oftenAccountButton.al_centerX == al_centerX,
            oftenAccountButton.al_left == al_left + 40,
            oftenAccountButton.al_right == al_right - 40,
            oftenAccountButton.al_height == 50
            ])
    }

}