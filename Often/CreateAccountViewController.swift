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
        createAccountView.nameTextField.delegate = self
        createAccountView.passwordTextField.delegate = self
        createAccountView.emailTextField.delegate = self
        
        createAccountView.cancelButton.addTarget(self,  action: #selector(CreateAccountViewController.didTapCancelButton(_:)), forControlEvents: .TouchUpInside)
        createAccountView.signupButton.addTarget(self, action: #selector(CreateAccountViewController.didTapSignupButton(_:)), forControlEvents: .TouchUpInside)
        createAccountView.signupButton.addTarget(self, action: #selector(UserCreationViewController.didTapLoginButton(_:)), forControlEvents: .TouchUpInside)
        createAccountView.termsOfUseAndPrivacyPolicyButton.addTarget(self, action: #selector(CreateAccountViewController.didTapTermsOfUseButton(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func didTapCancelButton(sender: UIButton) {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)

        dismissViewControllerAnimated(true, completion: nil)
    }
        
    func didTapSignupButton(sender: UIButton) {
        viewModel.userAuthData.name = createAccountView.nameTextField.text!
        viewModel.userAuthData.email = createAccountView.emailTextField.text!
        viewModel.userAuthData.password = createAccountView.passwordTextField.text!
        viewModel.userAuthData.isNewUser = true
    }
    
    func didTapTermsOfUseButton(sender: UIButton) {
        self.presentViewController(TermsOfUseViewController(title: "terms of use & privacy policy", website: "http://tryoften.com/privacy"), animated: true, completion: nil)
    }
    
    func createAddUsernameViewController() {
        let vc = AddUsernameViewController(viewModel: UsernameViewModel())
        presentViewController(vc, animated: true, completion: nil)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let characterCount = createAccountView.passwordTextField.text!.characters.count
        if characterCount >= 3 {
            createAccountView.signupButton.selected = true
            createAccountView.signupButton.layer.borderWidth = 0
            createAccountView.signupButton.backgroundColor = UIColor(fromHexString: "#152036")
        } else {
            createAccountView.signupButton.backgroundColor = UIColor.whiteColor()
            createAccountView.signupButton.selected = false
            createAccountView.signupButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
            createAccountView.signupButton.layer.borderWidth = 2
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
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == createAccountView.nameTextField {
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
        createAddUsernameViewController()
    }

}