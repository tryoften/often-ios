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
    var subtitleLabel: UILabel
    var imageView: UIImageView
    let pageControl: UIPageControl
    let createAccountButton: UIButton
    let skipButton: UIButton
    var buttonDivider: UIView
    let signinButton: UIButton
    
    override init(frame: CGRect) {
        let titleString = "often".uppercaseString
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat", size: 30)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 2, range: titleRange)
        
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = titleString
        titleLabel.textColor = SignupViewTitleLabelFontColor
        titleLabel.textAlignment = .Center
        titleLabel.attributedText = title
        
        subtitleLabel = UILabel()
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.font = SignupViewAppDescriptionLabelFont
        subtitleLabel.text = "The non-basic keyboard. Share the latest videos, songs, GIFs & news from any app."
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .Center
        
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = SignupViewPageControlHighlightColor
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = UIColor(fromHexString: "#D2D2D2")
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        createAccountButton = UIButton()
        createAccountButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        createAccountButton.backgroundColor = SignupViewCreateAccountButtonColor
        createAccountButton.setTitle("create your account".uppercaseString, forState: .Normal)
        createAccountButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 11)
        createAccountButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        createAccountButton.layer.cornerRadius = 4.0
        createAccountButton.clipsToBounds = true
        
        skipButton = UIButton()
        skipButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        skipButton.setTitle("skip".uppercaseString, forState: .Normal)
        skipButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        skipButton.setTitleColor(UIColor(fromHexString: "#152036") , forState: .Normal)
        skipButton.alpha = 0.54
        
        signinButton = UIButton()
        signinButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        signinButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signinButton.setTitleColor(UIColor(fromHexString: "#152036")  , forState: .Normal)
        signinButton.alpha = 0.54
        
        buttonDivider = UIView()
        buttonDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonDivider.backgroundColor = UIColor(fromHexString: "#D2D2D2")
        
        super.init(frame: frame)
        
        backgroundColor = WalkthroughBackgroungColor
        addSubview(titleLabel)
        addSubview(subtitleLabel)
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
            titleLabel.al_height == 40,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_height == 60,
            
            imageView.al_top == subtitleLabel.al_bottom,
            imageView.al_left == al_left + 20,
            imageView.al_right == al_right - 20,
            imageView.al_bottom == pageControl.al_top,
            imageView.al_height == 370,
            
            pageControl.al_top == imageView.al_bottom,
            pageControl.al_centerX == al_centerX,
            pageControl.al_height == 2,
            pageControl.al_width == 50,
            
            createAccountButton.al_top == pageControl.al_bottom + 20,
            createAccountButton.al_left == al_left + 60,
            createAccountButton.al_right == al_right - 60,
            createAccountButton.al_height == 50,
            
            skipButton.al_top == createAccountButton.al_bottom + 10,
            skipButton.al_left == al_left + 20,
            skipButton.al_right == buttonDivider.al_left,
            skipButton.al_height == 60,
            skipButton.al_width == al_width/2 - 20,
            
            signinButton.al_top == createAccountButton.al_bottom + 10,
            signinButton.al_left == buttonDivider.al_right,
            signinButton.al_right == al_right - 20,
            signinButton.al_height == 60,
            signinButton.al_width == al_width/2 - 20,
            
            buttonDivider.al_centerY == signinButton.al_centerY,
            buttonDivider.al_centerX == al_centerX,
            buttonDivider.al_height == 30,
            buttonDivider.al_width == 1.0,
            ])
    }
}