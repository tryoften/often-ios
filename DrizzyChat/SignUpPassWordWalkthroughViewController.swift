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
        addPasswordPage.passwordTxtField.delegate = self
        addPasswordPage.passwordTxtField.returnKeyType = .Next
        
        
        view.addSubview(addPasswordPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
        
        return true
    }
    
    func checkCharacterCountOfTextField() {
        if (count(addPasswordPage.passwordTxtField.text) >= 2) {
            nextButton.hidden = false
            addPasswordPage.termsAndPrivacyView.hidden = true
        } else {
            nextButton.hidden = true
            addPasswordPage.termsAndPrivacyView.hidden = false
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPasswordPage.passwordTxtField.becomeFirstResponder()
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
        if PasswordIsValid(addPasswordPage.passwordTxtField.text) {
            
                viewModel.password = addPasswordPage.passwordTxtField.text
            
        } else {
            println("need more chars")
            return
        }
        let selectArtistvc = SignUpConfirmPassWordWalkthroughViewController(viewModel: self.viewModel)
        
        navigationController?.pushViewController(selectArtistvc, animated: true)
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
            didTapNavButton()
        
        return true
    }
}
