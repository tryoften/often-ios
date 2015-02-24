//
//  SignUpWalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 2/8/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SignUpWalkthroughPage: WalkthroughPage {
    
    var facebookButton: FacebookButton
    var signUpButton: UIButton
    var loginButton: UIButton
    var skipButton: UIButton
    var loginIndicatorView: LoginIndicatorView

    required init(frame: CGRect) {
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        signUpButton = UIButton(frame: CGRectZero)
        signUpButton.setTitle("Sign up with email", forState: .Normal)
        signUpButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 14)
        signUpButton.setTitleColor(BlueColor, forState: .Normal)
        signUpButton.contentHorizontalAlignment = .Left
        signUpButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        loginButton = UIButton(frame: CGRectZero)
        loginButton.setTitle("Log in with account", forState: .Normal)
        loginButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 14)
        loginButton.setTitleColor(BlueColor, forState: .Normal)
        loginButton.contentHorizontalAlignment = .Right
        loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        skipButton = UIButton(frame: CGRectZero)
        skipButton.setTitle("Skip to main screen", forState: .Normal)
        skipButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 20)
        skipButton.backgroundColor = UIColor(fromHexString: "#ffb61d")
        skipButton.contentHorizontalAlignment = .Center
        skipButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        loginIndicatorView = LoginIndicatorView(frame: CGRectZero)
        loginIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(frame: frame)
        type = .SignUpPage
        
        addSubview(facebookButton)
        addSubview(signUpButton)
        addSubview(loginButton)
        addSubview(skipButton)
        addSubview(loginIndicatorView)
        
        facebookButton.addTarget(self, action: "didTapFacebookButton", forControlEvents: .TouchUpInside)
        signUpButton.addTarget(self, action: "didTapSignUpButton", forControlEvents: .TouchUpInside)
        loginButton.addTarget(self, action: "didTapLoginButton", forControlEvents: .TouchUpInside)
        skipButton.addTarget(self, action: "didTapSkipButton", forControlEvents: .TouchUpInside)
    }
    
    func didTapSignUpButton() {
        self.walkthroughViewController.presentSignUpFormView(nil)
    }
    
    func didTapLoginButton() {
        
    }
    
    func didTapSkipButton() {
        self.walkthroughViewController.presentHomeView(nil)
    }
    
    func loginStateChanged() {
        var currentUser = PFUser.currentUser()
        println("\(currentUser)")
        
        if currentUser != nil {
            if let fullName = currentUser["fullName"] as? String {
                loginIndicatorView.nameLabel.text = "Wassup, \(fullName)"
            } else {
                loginIndicatorView.nameLabel.text = "Wassup homie"
            }
            skipButton.setTitle("Go to main screen", forState: .Normal)
            signUpButton.hidden = true
            loginButton.hidden = true
        } else {
            loginIndicatorView.hidden = true
        }
    }
    
    func didTapFacebookButton() {
        PFFacebookUtils.logInWithPermissions(["public_profile", "email"], block: { (user, error) in
            // The user cancelled the facebook login
            if user == nil {

                var alertView = UIAlertView(title: "Sign Up Failed", message: "The facebook sign up was cancelled or failed, please try again", delegate: nil, cancelButtonTitle: "Bah! Fine")
                
                alertView.show()
            }
            // The user signed up and logged in through facebook
            else if user.isNew {
                self.walkthroughViewController.presentSignUpFormView(user)
            }
            // User logged in through facebook
            else {
                self.walkthroughViewController.getUserInfo({ (result, err) in
                    self.walkthroughViewController.presentHomeView(result)
                })
            }
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loginStateChanged()
    }
    
    override func setupPage() {
        var covers = [UIImageView]()
        
        var cover1 = UIImageView(image: UIImage(named: "kanye"))
        var cover2 = UIImageView(image: UIImage(named: "kendrick"))
        var cover3 = UIImageView(image: UIImage(named: "tswift"))
        
        covers += [cover1, cover2, cover3]
        
        for cover in covers {
            cover.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        var topMargin: CGFloat = 0
        
        if isIPhone5() {
            topMargin = 40
        } else {
            topMargin = 60
        }
        
        addSubview(cover2)
        addSubview(cover3)
        addSubview(cover1)
        
        addConstraints([
            cover1.al_top == subtitleLabel.al_bottom + topMargin,
            cover1.al_centerX == al_centerX,
            cover1.al_width == CGRectGetWidth(cover1.frame),
            cover1.al_height == CGRectGetHeight(cover1.frame),
            
            cover2.al_width == cover1.al_width * 0.9,
            cover2.al_height == cover1.al_height * 0.9,
            cover2.al_centerY == cover1.al_centerY,
            cover2.al_centerX == cover1.al_centerX - 50,
            
            cover3.al_width == cover1.al_width * 0.9,
            cover3.al_height == cover1.al_height * 0.9,
            cover3.al_centerY == cover1.al_centerY,
            cover3.al_centerX == cover1.al_centerX + 50,
            
            facebookButton.al_top == cover1.al_bottom + 40,
            facebookButton.al_centerX == al_centerX,
            facebookButton.al_left == cover2.al_left,
            facebookButton.al_right == cover3.al_right,
            facebookButton.al_height == 50,
            
            signUpButton.al_top == facebookButton.al_bottom + 10,
            signUpButton.al_left == facebookButton.al_left,
            signUpButton.al_height == 30,
            signUpButton.al_width == facebookButton.al_width / 2,
            
            loginButton.al_top == facebookButton.al_bottom + 10,
            loginButton.al_right == facebookButton.al_right,
            loginButton.al_height == 30,
            loginButton.al_width == facebookButton.al_width / 2,
            
            skipButton.al_bottom == al_bottom,
            skipButton.al_left == al_left,
            skipButton.al_width == al_width,
            skipButton.al_height == 50,
            
            loginIndicatorView.al_top == cover1.al_bottom + 40,
            loginIndicatorView.al_height == 100,
            loginIndicatorView.al_width == al_width,
            loginIndicatorView.al_left == al_left
        ])
    }
    
    func toggleLoginControls(visible: Bool) {
        facebookButton.hidden = !visible
        loginButton.hidden = !visible
        signUpButton.hidden = !visible
    }
    
    override func pageDidShow() {
        super.pageDidShow()
        delegate?.walkthroughPage(self, shouldHideControls: true)
    }
    
    override func pageDidHide() {
        super.pageDidHide()
        delegate?.walkthroughPage(self, shouldHideControls: false)
    }
}
