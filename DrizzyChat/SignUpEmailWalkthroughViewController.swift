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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
        return true
    }
    
    func checkCharacterCountOfTextField() {
        if (count(addEmailPage.emailTxtField.text) >= 2) {
            nextButton.hidden = false
            addEmailPage.termsAndPrivacyView.hidden = true
        } else {
            nextButton.hidden = true
            addEmailPage.termsAndPrivacyView.hidden = false
        }
    }
    
    override func didTapNavButton() {
        if EmailIsValid(addEmailPage.emailTxtField.text) {
            viewModel.user.email = addEmailPage.emailTxtField.text
        }
        else {
            println("enter email")
            return
        }
        
        let Passwordvc = SignUpPassWordWalkthroughViewController(viewModel:self.viewModel)
        
        navigationController?.pushViewController(Passwordvc, animated: true)
    }
}
