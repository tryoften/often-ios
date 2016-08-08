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
    private let titleLabel: UILabel
    private var subtitleLabel: UILabel
    private var imageView: UIImageView
    private let orSpacer: ViewSpacerWithText
    let emailButton: UIButton
    let signinButton: UIButton
    let twitterButton: UIButton
    let facebookButton: UIButton
    var launchScreenLoader: UIImageView

    private var subtitleLabelLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 30
        }
        return 55
    }
    
    override init(frame: CGRect) {
        let titleString = "Your own personal keyboard"
        let titleRange = NSMakeRange(0, titleString.characters.count)
        let title = NSMutableAttributedString(string: titleString)
        let subtitleString = "Create your very own keyboard with GIFs, \n Images, & Quotes for friends to use"
        let subtitleRange = NSMakeRange(0, subtitleString.characters.count)
        let subtitle = NSMutableAttributedString(string: subtitleString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
        subtitle.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 13)!, range: subtitleRange)
        subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)

        title.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat", size: 14)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1, range: titleRange)

        let signupEmailButtonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.oftBlackColor()
        ]
        
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
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(fromHexString: "#ffffff")
        imageView.image = UIImage(named: "signupImage")
        imageView.contentMode = .ScaleAspectFit

        emailButton = UIButton()
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.backgroundColor = UIColor.whiteColor()
        emailButton.setAttributedTitle( NSAttributedString(string: "sign up w/ email".uppercaseString, attributes: signupEmailButtonAttributes), forState: .Normal)
        emailButton.layer.cornerRadius = 25
        emailButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        emailButton.layer.borderWidth = 2
        emailButton.clipsToBounds = true

        signinButton = UIButton()
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        signinButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signinButton.setTitleColor(UIColor(fromHexString: "#202020")  , forState: .Normal)
        signinButton.alpha = 0.54

        facebookButton = LoginButton.FacebookButton()
        twitterButton = LoginButton.TwitterButton()

        orSpacer = ViewSpacerWithText(title:"Or With")
        orSpacer.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(imageView)
        addSubview(emailButton)
        addSubview(orSpacer)
        addSubview(signinButton)
        addSubview(facebookButton)
        addSubview(twitterButton)
        addSubview(launchScreenLoader)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints = [
            signinButton.al_top == al_top + 25,
            signinButton.al_right == al_right - 25,
            signinButton.al_height == 25,
            signinButton.al_width == 49.6,
            
            titleLabel.al_top == al_top + 82,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 16.5,

            subtitleLabel.al_top == titleLabel.al_bottom + 5,
            subtitleLabel.al_left == al_left + 45,
            subtitleLabel.al_right == al_right - 45,
            subtitleLabel.al_height == 42,

            imageView.al_top == subtitleLabel.al_bottom + 58,
            imageView.al_left == al_left + 80,
            imageView.al_right == al_right - 80,
            imageView.al_centerY == al_centerY - 30,

            emailButton.al_top == imageView.al_bottom + 30,
            emailButton.al_left == al_left + 40.5,
            emailButton.al_right == al_right - 40.5,
            emailButton.al_height == 55,

            orSpacer.al_top == emailButton.al_bottom + 18,
            orSpacer.al_left == al_left + 40.5,
            orSpacer.al_right == al_right - 40.5,
            orSpacer.al_height == 20,

            twitterButton.al_top == orSpacer.al_bottom + 18,
            twitterButton.al_left == al_left + 40,
            twitterButton.al_right == al_centerX - 2,
            twitterButton.al_height == 50,

            facebookButton.al_top == twitterButton.al_top,
            facebookButton.al_left == al_centerX + 2,
            facebookButton.al_right == al_right - 40,
            facebookButton.al_height == 50,

            launchScreenLoader.al_bottom == al_bottom,
            launchScreenLoader.al_top == al_top,
            launchScreenLoader.al_left == al_left,
            launchScreenLoader.al_right == al_right,
            launchScreenLoader.al_centerX == al_centerX,
            launchScreenLoader.al_centerY == al_centerY,
        ]
        
        addConstraints(constraints)
    }
}