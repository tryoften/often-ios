//
//  SkipSignupViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 11/10/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SkipSignupViewController: UIViewController {
    var servicesMenuButton: UIButton
    var settingsMenuButton: UIButton
    var twitterLogoImageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var twitterSignupButton: UIButton
    var oftenAccountButton: UIButton
    var leftDividerLine: UIView
    var rightDividerLine: UIView
    var orLabel: UILabel
    
    init() {
        servicesMenuButton = UIButton()
        servicesMenuButton.translatesAutoresizingMaskIntoConstraints = false
        servicesMenuButton.setImage(UIImage(named: "hamburger"), forState: .Normal)
        
        settingsMenuButton = UIButton()
        settingsMenuButton.translatesAutoresizingMaskIntoConstraints = false
        settingsMenuButton.setImage(UIImage(named: "settings"), forState: .Normal)
        
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
        
        super.init(nibName: nil, bundle: nil)
        
        twitterSignupButton.addTarget(self, action: "didSelectTwitterSignupButton", forControlEvents: .TouchUpInside)
        oftenAccountButton.addTarget(self, action: "didSelectOftenAccountButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(servicesMenuButton)
        view.addSubview(settingsMenuButton)
        view.addSubview(twitterLogoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(twitterSignupButton)
        view.addSubview(oftenAccountButton)
        view.addSubview(leftDividerLine)
        view.addSubview(rightDividerLine)
        view.addSubview(orLabel)
        
        setupLayout()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectTwitterSignupButton() {
       
    }
    
    func didSelectOftenAccountButton() {
        
    }
    
    func setupLayout() {
        view.addConstraints([
            servicesMenuButton.al_left == view.al_left + 15,
            servicesMenuButton.al_top == view.al_top + 15,
            servicesMenuButton.al_width == 15,
            servicesMenuButton.al_height == 15,
            
            settingsMenuButton.al_right == view.al_right - 15,
            settingsMenuButton.al_top == view.al_top + 15,
            settingsMenuButton.al_width == 20,
            settingsMenuButton.al_height == 20,
            
            twitterLogoImageView.al_centerX == view.al_centerX,
            twitterLogoImageView.al_bottom == titleLabel.al_top - 15,
            twitterLogoImageView.al_width == 80,
            twitterLogoImageView.al_height == 80,
            
            titleLabel.al_bottom == subtitleLabel.al_top,
            titleLabel.al_centerX == view.al_centerX,
            titleLabel.al_height == 17,
            titleLabel.al_width == 200,
            
            subtitleLabel.al_bottom == twitterSignupButton.al_top - 10,
            subtitleLabel.al_centerX == view.al_centerX,
            subtitleLabel.al_height == 80,
            subtitleLabel.al_width == 300,
            
            twitterSignupButton.al_top == view.al_centerY,
            twitterSignupButton.al_centerX == view.al_centerX,
            twitterSignupButton.al_left == view.al_left + 40,
            twitterSignupButton.al_right == view.al_right - 40,
            twitterSignupButton.al_height == 50,
            
            orLabel.al_centerX == view.al_centerX,
            orLabel.al_top == twitterSignupButton.al_bottom + 10,
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
            
            oftenAccountButton.al_top == orLabel.al_bottom + 10,
            oftenAccountButton.al_centerX == view.al_centerX,
            oftenAccountButton.al_left == view.al_left + 40,
            oftenAccountButton.al_right == view.al_right - 40,
            oftenAccountButton.al_height == 50
        ])
    }
}
