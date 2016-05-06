//
//  SignupView.swift
//  Often
//
//  Created by Kervins Valcourt on 9/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable function_body_length

import Foundation

class LoginView: UIView {
    let titleLabel: UILabel
    var subtitleLabel: UILabel
    var scrollView: UIScrollView
    let pageControl: UIPageControl
    let createAccountButton: UIButton
    let skipButton: UIButton
    var launchScreenLoader: UIImageView
    let signinButton: UIButton

    private var subtitleLabelLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 30
        }
        return 55
    }
    
    override init(frame: CGRect) {
        let titleString = "Share lyrics, quotes & GIFS".uppercaseString
        let titleRange = NSMakeRange(0, titleString.characters.count)
        let title = NSMutableAttributedString(string: titleString)
        let subtitleString = "Pick packs from TV Shows, Artists, \n Movies, Tweets, Sports & More"
        let subtitleRange = NSMakeRange(0, subtitleString.characters.count)
        let subtitle = NSMutableAttributedString(string: subtitleString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
        subtitle.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 13)!, range: subtitleRange)
        subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)

        title.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat", size: 14)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1, range: titleRange)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleString
        titleLabel.textColor = SignupViewTitleLabelFontColor
        titleLabel.textAlignment = .Center
        titleLabel.attributedText = title
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = SignupViewAppDescriptionLabelFont
        subtitleLabel.text = subtitleString
        subtitleLabel.attributedText = subtitle
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.54
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor(fromHexString: "#ffffff")
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = SignupViewPageControlHighlightColor
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = UIColor(fromHexString: "#DDDDDD")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        createAccountButton = UIButton()
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.backgroundColor = SignupViewCreateAccountButtonColor
        createAccountButton.setTitle("sign up".uppercaseString, forState: .Normal)
        createAccountButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 11)
        createAccountButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        createAccountButton.layer.cornerRadius = 0
        createAccountButton.clipsToBounds = true
        
        skipButton = LoginButton.AnonymousButton()
        skipButton.setTitle("skip".uppercaseString, forState: .Normal)
        skipButton.setTitleColor(UIColor(fromHexString: "#202020") , forState: .Normal)
        skipButton.alpha = 0.54
        
        signinButton = UIButton()
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        signinButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signinButton.setTitleColor(UIColor(fromHexString: "#202020")  , forState: .Normal)
        signinButton.alpha = 0.54
        
        var splashImage: UIImage = UIImage(named: "LaunchImage-800-667h@2x")!
        
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            splashImage = UIImage(named: "LaunchImage-568h@2x")!
        }
        
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            splashImage = UIImage(named: "LaunchImage-800-Portrait-736h@3x")!
        }
        
        launchScreenLoader = UIImageView(image: splashImage)
        launchScreenLoader.contentMode = .ScaleAspectFit
        launchScreenLoader.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#ffffff")
        
        addSubview(scrollView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(pageControl)
        addSubview(createAccountButton)
        addSubview(skipButton)
        addSubview(signinButton)
        addSubview(launchScreenLoader)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        var constraints = [
            skipButton.al_left == al_left + 25,
            skipButton.al_top == al_top + 25,
            skipButton.al_height == 25,
            skipButton.al_width == 49.6,
            
            signinButton.al_centerY == skipButton.al_centerY,
            signinButton.al_right == al_right - 25,
            signinButton.al_height == skipButton.al_height,
            signinButton.al_width == skipButton.al_width,
            
            scrollView.al_top == skipButton.al_bottom,
            scrollView.al_left == al_left + 20,
            scrollView.al_right == al_right - 20,
            scrollView.al_bottom == titleLabel.al_top,
            
            titleLabel.al_bottom == subtitleLabel.al_top - 10,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 16.5,
            
            subtitleLabel.al_bottom == pageControl.al_top - 18.5,
            subtitleLabel.al_left == al_left + 45,
            subtitleLabel.al_right == al_right - 45,
            subtitleLabel.al_height == 42,
            
            pageControl.al_bottom == createAccountButton.al_top - 34,
            pageControl.al_centerX == al_centerX,
            pageControl.al_height == 2,
            pageControl.al_width == 40,
            
            createAccountButton.al_bottom == al_bottom,
            createAccountButton.al_left == al_left,
            createAccountButton.al_right == al_right,
            createAccountButton.al_height == 55,
            
            launchScreenLoader.al_bottom == al_bottom,
            launchScreenLoader.al_top == al_top,
            launchScreenLoader.al_left == al_left,
            launchScreenLoader.al_right == al_right,
            launchScreenLoader.al_centerX == al_centerX,
            launchScreenLoader.al_centerY == al_centerY,
        ]
        
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            constraints += [
                skipButton.al_bottom == al_bottom - 10,
                scrollView.al_bottom == pageControl.al_top - 18,
            ]
        } else {
            constraints += [
                skipButton.al_bottom == al_bottom - 30,
                scrollView.al_bottom == pageControl.al_top - 3,
            ]
        }
        
        addConstraints(constraints)
    }
}