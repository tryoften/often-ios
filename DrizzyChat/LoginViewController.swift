//
//  LoginViewConroller.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginViewController : WalkthroughViewController {
    var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginView = LoginView()
        loginView.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginView.facebookButton.addTarget(self, action: "didTapFacebookButton", forControlEvents: .TouchUpInside)
        
        setupNavBar("")
        
        view.addSubview(loginView)
    }
    
    func didTapFacebookButton() {
        sessionManager.login()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
        
        title = "login".uppercaseString
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            loginView.emailTxtField.becomeFirstResponder()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    override func setupLayout() {
        
        var constraints: [NSLayoutConstraint] = [
            loginView.al_top == view.al_top,
            loginView.al_bottom == view.al_bottom,
            loginView.al_left == view.al_left,
            loginView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

    func walkthroughViewModelDidLoginUser(walkthroughViewModel: SignUpWalkthroughViewModel, user: User, isNewUser: Bool) {
        var presentedViewController: UIViewController
        if isNewUser {
            presentedViewController = SelectArtistWalkthroughViewController()
            navigationController?.pushViewController(presentedViewController, animated: true)
        } else {
            presentedViewController = TabBarController()
            self.presentViewController(presentedViewController, animated: true, completion: nil)
        }

        viewModel.delegate = nil
    }
}