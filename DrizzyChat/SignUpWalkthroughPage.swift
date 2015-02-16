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

        super.init(frame: frame)
        type = .SignUpPage
        
        facebookButton.addTarget(self, action: "didTapFacebookButton", forControlEvents: .TouchUpInside)
        signUpButton.addTarget(self, action: "didTapSignUpButton", forControlEvents: .TouchUpInside)
        
        addSubview(facebookButton)
        addSubview(signUpButton)
        addSubview(loginButton)
    }
    
    func didTapSignUpButton() {
        var signUpFormViewController = SignUpFormViewController()
        var navigationController = UINavigationController(rootViewController: signUpFormViewController)
        
        let attributes: NSDictionary = [
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 14)!
        ]

        navigationController.navigationBar.titleTextAttributes = attributes
        walkthroughViewController.presentViewController(navigationController, animated: true, completion: {})
    }
    
    func didTapFacebookButton() {
        var session = FBSession.activeSession()
        
        // If the session state is any of the two "open" states when the button is clicked
        if session.state == .Open || session.state == .OpenTokenExtended {
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            session.closeAndClearTokenInformation()
        }
        
        // If the session state is not any of the two "open" states when the button is clicked
        else {
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: {
                (session: FBSession!, state: FBSessionState, err: NSError!) in
                var appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
                
                appDelegate.sessionStateChanged(session, state: state, error: err)
            })
        }
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
            topMargin = 60
        } else {
            topMargin = 80
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
            
            facebookButton.al_top == cover1.al_bottom + 20,
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
            loginButton.al_width == facebookButton.al_width / 2
        ])
    }
}
