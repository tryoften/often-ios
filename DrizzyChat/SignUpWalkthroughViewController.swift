//
//  SignUpWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation
import WebKit

class SignUpLoginWalkthroughViewController: WalkthroughViewController {
    var loginSignUpPage: SignUpOrLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.hidden = true
        
        loginSignUpPage = SignUpOrLoginView()
        loginSignUpPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginSignUpPage.signUpButton.addTarget(self, action: "didTapSignUpButton", forControlEvents: .TouchUpInside)
        loginSignUpPage.loginButton.addTarget(self, action: "didTapLoginButton", forControlEvents: .TouchUpInside)
        loginSignUpPage.facebookButton.addTarget(self, action: "didTapFacebookButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(loginSignUpPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func setupLayout() {
     super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            loginSignUpPage.al_top == view.al_top,
            loginSignUpPage.al_bottom == view.al_bottom,
            loginSignUpPage.al_left == view.al_left,
            loginSignUpPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

    func didTapSignUpButton() {
        let phoneNumbervc = PhoneNumberWalkthroughViewController(viewModel: viewModel)
        navigationController?.pushViewController(phoneNumbervc, animated: true)
    }
    
    func didTapLoginButton() {
        let loginvc = LoginViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginvc, animated: true)
    }
    
    func didTapFacebookButton() {

        HUDProgressView.show()
        loginSignUpPage.facebookButton.enabled = false
        
        viewModel.sessionManager.login { (user, error) in
        }
    }
}
