//
//  LoginViewConroller.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginViewController : UIViewController, UITextFieldDelegate {
    var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView = LoginView()
        loginView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        title = "login"
        
        view.addSubview(loginView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        
        navigationController?.navigationBar.hidden = false
        
        delay(0.05) {
            loginView.emailTxtField.becomeFirstResponder()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    func setupLayout() {
        
        var constraints: [NSLayoutConstraint] = [
            loginView.al_top == view.al_top,
            loginView.al_bottom == view.al_bottom,
            loginView.al_left == view.al_left,
            loginView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

    

}