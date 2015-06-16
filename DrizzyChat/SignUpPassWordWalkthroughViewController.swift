//
//  SignUpPassWordWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpPassWordWalkthroughViewController: WalkthroughViewController  {
    var addPasswordPage: SignUpPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPasswordPage = SignUpPasswordView()
        addPasswordPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPasswordPage.passwordTxtFieldOne.delegate = self
        addPasswordPage.passwordTxtFieldOne.returnKeyType = .Next
        addPasswordPage.confirmPasswordTxtField.delegate = self
        addPasswordPage.confirmPasswordTxtField.hidden = true
        addPasswordPage.titleLabelTwo.hidden = true
        addPasswordPage.spacerTwo.hidden = true
        
        setupNavBar("next")
        
        view.addSubview(addPasswordPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPasswordPage.passwordTxtFieldOne.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addPasswordPage.al_top == view.al_top,
            addPasswordPage.al_bottom == view.al_bottom,
            addPasswordPage.al_left == view.al_left,
            addPasswordPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        if PasswordIsValid(addPasswordPage.passwordTxtFieldOne.text) {
            if arePasswordMatchingValid(addPasswordPage.passwordTxtFieldOne.text, addPasswordPage.confirmPasswordTxtField.text) {
                viewModel.password = addPasswordPage.passwordTxtFieldOne.text
            } else {
                println("passwords dont match")
                return
            }
            
        } else {
            println("need more chars")
            return
        }
        let selectArtistvc = SelectArtistWalkthroughViewController()
        selectArtistvc.viewModel = viewModel
        
        navigationController?.pushViewController(selectArtistvc, animated: true)
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == .Next {
            addPasswordPage.confirmPasswordTxtField.hidden = false
            addPasswordPage.titleLabelTwo.hidden = false
            addPasswordPage.spacerTwo.hidden = false
            addPasswordPage.confirmPasswordTxtField.becomeFirstResponder()
        } else {
            didTapNavButton()
        }
        return true
    }
}
