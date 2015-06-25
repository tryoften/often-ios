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


class TermAndPrivacyWebView: UIViewController {
    var webView: WKWebView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
        webView = WKWebView()
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let url = NSURL(string:"http://www.appcoda.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
     func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            webView.al_top == view.al_top,
            webView.al_bottom == view.al_bottom,
            webView.al_left == view.al_left,
            webView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

}


