//
//  SigninViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/10/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SigninViewController: UserCreationViewController, UITextFieldDelegate {
    var signinView: SigninView

    
    override init (viewModel: LoginViewModel) {
        signinView = SigninView()
        signinView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(viewModel: viewModel)
        self.viewModel.delegate = self
        
        view.addSubview(signinView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signinView.emailTextField.delegate = self
        signinView.passwordTextField.delegate = self
        
        signinView.cancelButton.addTarget(self,  action: "didTapcancelButton:", for: .touchUpInside)
        signinView.signinButton.addTarget(self, action: "didTapSigninButton:", for: .touchUpInside)
        signinView.signinButton.addTarget(self, action: "didTapButton:", for: .touchUpInside)
        signinView.signinFacebookButton.addTarget(self, action:"didTapButton:", for: .touchUpInside)
        signinView.signinTwitterButton.addTarget(self, action:"didTapButton:", for: .touchUpInside)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didTapSigninButton(_ sender: UIButton) {
        viewModel.userAuthData.email = signinView.emailTextField.text!
        viewModel.userAuthData.password = signinView.passwordTextField.text!
        viewModel.userAuthData.isNewUser = false

    }

    func didTapcancelButton(_ sender: UIButton) {
        UIApplication.shared().sendAction("resignFirstResponder", to: nil, from: nil, for: nil)

        dismiss(animated: true, completion: nil)
    }

    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            signinView.al_bottom == view.al_bottom,
            signinView.al_top == view.al_top,
            signinView.al_left == view.al_left,
            signinView.al_right == view.al_right,
            ]
        view.addConstraints(constraints)
    }
    
    func createProfileViewController() {
        viewModel.sessionManager.sessionManagerFlags.userIsAnonymous = false
        
        present(RootViewController(), animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let characterCount = signinView.passwordTextField.text!.characters.count
        if characterCount >= 3 {
            signinView.signinButton.backgroundColor = UIColor(fromHexString: "#152036")
        } else {
            signinView.signinButton.backgroundColor = CreateAccountViewSignupButtonColor
        }
        
        return true
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared().sendAction("resignFirstResponder", to: nil, from: nil, for: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signinView.emailTextField {
            signinView.passwordTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func loginViewModelDidLoginUser(_ userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)
        
        createProfileViewController()
    }

}
