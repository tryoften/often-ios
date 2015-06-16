//
//  SignUpEmailWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpEmailWalkthroughViewController: WalkthroughViewController  {
    var addEmailPage: SignUpEmailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEmailPage = SignUpEmailView()
        addEmailPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addEmailPage.emailTxtField.delegate = self
        addEmailPage.emailTxtField.keyboardType = .EmailAddress
        
        setupNavBar("next")
        
        view.addSubview(addEmailPage)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addEmailPage.emailTxtField.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addEmailPage.al_top == view.al_top,
            addEmailPage.al_bottom == view.al_bottom,
            addEmailPage.al_left == view.al_left,
            addEmailPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        if EmailIsValid(addEmailPage.emailTxtField.text) {
            viewModel.email = addEmailPage.emailTxtField.text
        }
        else {
            println("enter email")
            return
        }
        
        let Passwordvc = SignUpPassWordWalkthroughViewController()
        Passwordvc.viewModel = viewModel
        
        navigationController?.pushViewController(Passwordvc, animated: true)
    }
}
