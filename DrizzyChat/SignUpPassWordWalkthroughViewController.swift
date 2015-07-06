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
        
        errorView.errorMessageLabel.text = "passwords must have at least 8 characters".uppercaseString
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
        var characterCount = count(addPasswordPage.passwordTxtField.text)
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            if self.didAnimateUp && characterCount >= 1 {
                self.nextButton.hidden = false
                self.nextButton.frame.origin.y -= 50
                self.didAnimateUp = false
                self.addPasswordPage.termsAndPrivacyView.hidden = true
            } else if self.didAnimateUp == false && characterCount <= 1 {
                self.nextButton.frame.origin.y += 50
                self.didAnimateUp = true
                self.addPasswordPage.termsAndPrivacyView.hidden = false
                self.hideButton = true
            }
            }, completion: {
                (finished: Bool) in
                if self.hideButton {
                    self.nextButton.hidden = true
                    self.hideButton = false
                }
        })
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
            
            let selectArtistvc = SignUpConfirmPassWordWalkthroughViewController(viewModel: self.viewModel)
            navigationController?.pushViewController(selectArtistvc, animated: true)
            
        } else {
            errorFound()
            return
        }
    }
}
