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
        loginView.emailTxtField.delegate = self
        loginView.passwordTxtField.delegate = self
        loginView.facebookButton.addTarget(self, action: "didTapFacebookButton", forControlEvents: .TouchUpInside)
        
        errorView.errorMessageLabel.text = "email login & password are incorrect".uppercaseString
        
        view.addSubview(loginView)
    }
    
    func didTapFacebookButton() {
        HUDProgressView.show()
        loginView.facebookButton.enabled = false
        errorView.errorMessageLabel.text = "an error occurred. please try again".uppercaseString
        
        viewModel.sessionManager.login { (user, error) -> () in
            if error != nil {
                HUDProgressView.hide()
                self.errorFound()
                self.loginView.facebookButton.enabled = true
            }

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
        
        var navBar = NavBarTitleView(frame: CGRectMake(0,0, 100, 40))
        navBar.navBarTitle.text = "login".uppercaseString
        navigationItem.titleView = navBar

        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
        
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            loginView.emailTxtField.becomeFirstResponder()
        }
        
    }
    
    func checkCharacterCountOfTextField() {
        var characterCount = count(loginView.passwordTxtField.text)
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            if self.didAnimateUp && characterCount >= 3 {
                self.nextButton.hidden = false
                self.nextButton.frame.origin.y -= 50
                self.didAnimateUp = false
                self.loginView.facebookButton.hidden = true
                self.loginView.orLabel.hidden = true
                self.loginView.orSpacerOne.hidden = true
                self.loginView.orSpacerTwo.hidden = true
            } else if self.didAnimateUp == false && characterCount <= 3 {
                self.nextButton.frame.origin.y += 50
                self.didAnimateUp = true
                self.loginView.orLabel.hidden = false
                self.loginView.orSpacerOne.hidden = false
                self.loginView.orSpacerTwo.hidden = false
                self.loginView.facebookButton.hidden = false
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

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            loginView.al_bottom == view.al_bottom,
            loginView.al_top == view.al_top,
            loginView.al_left == view.al_left,
            loginView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        if EmailIsValid(loginView.emailTxtField.text) && PasswordIsValid(loginView.emailTxtField.text) {
            viewModel.sessionManager.loginWithUsername(loginView.emailTxtField.text, password: loginView.passwordTxtField.text, completion: { (error) -> () in
                if error != nil {
                    self.errorFound()
                }
            })
        } else {
            errorFound()
        }
    }
}