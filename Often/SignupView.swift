//
//  SignupView.swift
//  Often
//
//  Created by Kervins Valcourt on 9/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SignupView: UIView {
    let titleLabel: UILabel
    var appDescriptionLabel: UILabel
    var imageView: UIImageView
    let pageControl: UIPageControl
    let createAccountButton: UIButton
    let skipButton: UIButton
    var buttonDivider: UIView
    let signinButton: UIButton
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = SignupViewTitleLabelFont
        titleLabel.text = "often".uppercaseString
        titleLabel.textAlignment = .Center
        
        appDescriptionLabel = UILabel()
        appDescriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        appDescriptionLabel.font = SignupViewAppDescriptionLabelFont
        appDescriptionLabel.text = "The non-basic keyboard. Share the latest videos, songs, GIFs & news from any app."
        appDescriptionLabel.numberOfLines = 2
        appDescriptionLabel.textAlignment = .Center
        
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = SignupViewPageControlHighlightColor
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        createAccountButton = UIButton()
        createAccountButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        createAccountButton.backgroundColor = SignupViewCreateAccountButtonColor
        createAccountButton.setTitle("create your account".uppercaseString, forState: .Normal)
        createAccountButton.titleLabel!.font = SignupViewCreateAccountButtonFont
        createAccountButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
        skipButton = UIButton()
        skipButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        skipButton.setTitle("skip".uppercaseString, forState: .Normal)
        skipButton.titleLabel!.font = SignupViewSkipButtonFont
        skipButton.setTitleColor(SignupViewSkipButtonFontColor , forState: .Normal)
        
        signinButton = UIButton()
        signinButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        signinButton.titleLabel!.font = SignupViewSigninButtonFont
        signinButton.setTitleColor(SignupViewSigninButtonFontColor , forState: .Normal)
        
        buttonDivider = UIView()
        buttonDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonDivider.backgroundColor = SignupViewSigninButtonFontColor
        
        super.init(frame: frame)
        
        backgroundColor = WalkthroughBackgroungColor
        addSubview(titleLabel)
        addSubview(appDescriptionLabel)
        addSubview(imageView)
        addSubview(pageControl)
        addSubview(createAccountButton)
        addSubview(buttonDivider)
        addSubview(skipButton)
        addSubview(signinButton)
        
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
            
            appDescriptionLabel.al_top == titleLabel.al_bottom,
            appDescriptionLabel.al_left == al_left + 20,
            appDescriptionLabel.al_right == al_right - 20,
            appDescriptionLabel.al_height == 60,
            
            imageView.al_top == appDescriptionLabel.al_bottom,
            imageView.al_left == al_left + 20,
            imageView.al_right == al_right - 20,
            imageView.al_bottom == pageControl.al_top,
            
            pageControl.al_top == imageView.al_bottom,
            pageControl.al_centerX == al_centerX,
            pageControl.al_height == 30,
            
            createAccountButton.al_top == pageControl.al_bottom,
            createAccountButton.al_left == al_left + 20,
            createAccountButton.al_right == al_right - 20,
            createAccountButton.al_height == 60,
            
            skipButton.al_top == pageControl.al_bottom,
            skipButton.al_left == al_left + 20,
            skipButton.al_right == al_right - 20,
            skipButton.al_height == 60,
            
            signinButton.al_top == pageControl.al_bottom,
            signinButton.al_left == al_left + 20,
            signinButton.al_right == al_right - 20,
            signinButton.al_height == 60,
            
            buttonDivider.al_top == pageControl.al_bottom,
            buttonDivider.al_left == al_left + 20,
            buttonDivider.al_right == al_right - 20,
            buttonDivider.al_height == 60,

            ])
    }
}