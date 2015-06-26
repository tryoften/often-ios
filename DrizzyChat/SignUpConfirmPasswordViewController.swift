//
//  SignUpConfirmPasswordViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpConfirmPassWordWalkthroughViewController: WalkthroughViewController  {
    var addPasswordPage: SignUpConfirmPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPasswordPage = SignUpConfirmPasswordView()
        addPasswordPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPasswordPage.confirmPasswordTxtField.delegate = self
        addPasswordPage.confirmPasswordTxtField.returnKeyType = .Next
        
        view.addSubview(addPasswordPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPasswordPage.confirmPasswordTxtField.becomeFirstResponder()
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
        
        return true 
    }
    
    func checkCharacterCountOfTextField() {
        if (count(addPasswordPage.confirmPasswordTxtField.text) >= 2) {
            nextButton.hidden = false
            addPasswordPage.termsAndPrivacyView.hidden = true
        } else {
            nextButton.hidden = true
            addPasswordPage.termsAndPrivacyView.hidden = false
        }
    }
    
    override func didTapNavButton() {
        if PasswordIsValid(addPasswordPage.confirmPasswordTxtField.text) {
            if arePasswordMatchingValid(viewModel.password, addPasswordPage.confirmPasswordTxtField.text) {
                viewModel.password = addPasswordPage.confirmPasswordTxtField.text
            } else {
                println("password didnt match")
                return
            }
            
        } else {
            println("need more chars")
            return
        }
        let selectArtistvc = SelectArtistWalkthroughViewController(viewModel: self.viewModel)
        
        navigationController?.pushViewController(selectArtistvc, animated: true)
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        didTapNavButton()
        
        return true
    }
}