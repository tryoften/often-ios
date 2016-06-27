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
        
        createAccountView.cancelButton.addTarget(self,  action: "didTapCancelButton:", for: .touchUpInside)
        createAccountView.signupButton.addTarget(self, action: "didTapSignupButton:", for: .touchUpInside)
        createAccountView.signupButton.addTarget(self, action: "didTapButton:", for: .touchUpInside)
        createAccountView.signupFacebookButton.addTarget(self, action: "didTapButton:", for: .touchUpInside)
        createAccountView.signupTwitterButton.addTarget(self, action: "didTapButton:", for: .touchUpInside)
        createAccountView.termsOfUseAndPrivacyPolicyButton.addTarget(self, action: "didTapTermsOfUseButton:", for: .touchUpInside)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func didTapCancelButton(_ sender: UIButton) {
        UIApplication.shared().sendAction("resignFirstResponder", to: nil, from: nil, for: nil)

        dismiss(animated: true, completion: nil)
    }
        
    func didTapSignupButton(_ sender: UIButton) {
        viewModel.userAuthData.username = createAccountView.usernameTextField.text!
        viewModel.userAuthData.email = createAccountView.emailTextField.text!
        viewModel.userAuthData.password = createAccountView.passwordTextField.text!
        viewModel.userAuthData.isNewUser = true


    }
    
    func didTapTermsOfUseButton(_ sender: UIButton) {
        self.present(TermsOfUseViewController(title: "terms of use & privacy policy", website: "http://www.tryoften.com/privacypolicy.html"), animated: true, completion: nil)
        
    }
    
    func createKeyboardInstallationWalkthroughViewController() {
        let keyboardInstallationWalkthrough = InstallationWalkthroughViewContoller(viewModel: self.viewModel)
        self.present(keyboardInstallationWalkthrough, animated: true, completion: nil)

    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared().sendAction("resignFirstResponder", to: nil, from: nil, for: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == createAccountView.usernameTextField {
            createAccountView.emailTextField.becomeFirstResponder()
            
        } else if textField == createAccountView.emailTextField {
            createAccountView.passwordTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func loginViewModelDidLoginUser(_ userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)
        createKeyboardInstallationWalkthroughViewController()
    }

}
