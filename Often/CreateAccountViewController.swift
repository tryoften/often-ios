//
//  CreateAccountViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/10/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class CreateAccountViewController: UserCreationViewController, UITextFieldDelegate {
    var createAccountView: CreateAccountView
    
    override init (viewModel: LoginViewModel) {
        createAccountView = CreateAccountView()
        createAccountView.translatesAutoresizingMaskIntoConstraints = false
    
        super.init(viewModel: viewModel)

        self.viewModel.sessionManager.sessionManagerFlags.userHasOpenedKeyboard = false
        self.viewModel.delegate = self

        view.addSubview(createAccountView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountView.usernameTextField.delegate = self
        createAccountView.passwordTextField.delegate = self
        createAccountView.emailTextField.delegate = self
        
        createAccountView.cancelButton.addTarget(self,  action: "didTapCancelButton:", forControlEvents: .TouchUpInside)
        createAccountView.signupButton.addTarget(self, action: "didTapSignupButton:", forControlEvents: .TouchUpInside)
        createAccountView.signupButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        createAccountView.signupFacebookButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        createAccountView.signupTwitterButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        createAccountView.termsOfUseAndPrivacyPolicyButton.addTarget(self, action: "didTapTermsOfUseButton:", forControlEvents: .TouchUpInside)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func didTapCancelButton(sender: UIButton) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)

        dismissViewControllerAnimated(true, completion: nil)
    }
        
    func didTapSignupButton(sender: UIButton) {
        viewModel.userAuthData.username = createAccountView.usernameTextField.text!
        viewModel.userAuthData.email = createAccountView.emailTextField.text!
        viewModel.userAuthData.password = createAccountView.passwordTextField.text!
        viewModel.userAuthData.isNewUser = true


    }
    
    func didTapTermsOfUseButton(sender: UIButton) {
        self.presentViewController(TermsOfUseViewController(title: "terms of use & privacy policy", website: "http://www.tryoften.com/privacypolicy.html"), animated: true, completion: nil)
        
    }
    
    func createKeyboardInstallationWalkthroughViewController() {
        let keyboardInstallationWalkthrough = InstallationWalkthroughViewContoller(viewModel: self.viewModel)
        self.presentViewController(keyboardInstallationWalkthrough, animated: true, completion: nil)

    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let characterCount = createAccountView.passwordTextField.text!.characters.count
        if characterCount >= 3 {
            createAccountView.signupButton.backgroundColor = UIColor(fromHexString: "#152036")
        } else {
            createAccountView.signupButton.backgroundColor = CreateAccountViewSignupButtonColor
        }
        
        return true
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            createAccountView.al_bottom == view.al_bottom,
            createAccountView.al_top == view.al_top,
            createAccountView.al_left == view.al_left,
            createAccountView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == createAccountView.usernameTextField {
            createAccountView.emailTextField.becomeFirstResponder()
            
        } else if textField == createAccountView.emailTextField {
            createAccountView.passwordTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)
        createKeyboardInstallationWalkthroughViewController()
    }

}