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
        
        signinView.cancelButton.addTarget(self,  action: "didTapcancelButton:", forControlEvents: .TouchUpInside)
        signinView.signinButton.addTarget(self, action: "didTapSigninButton:", forControlEvents: .TouchUpInside)
        signinView.signinTwitterButton.addTarget(self, action:"didTapTwitterButton:", forControlEvents: .TouchUpInside)
        signinView.signinFacebookButton.addTarget(self, action:"didTapFacebookButton:", forControlEvents: .TouchUpInside)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didTapSigninButton(sender: UIButton) {
        super.didTapSignupButton(sender)

        do {
            try viewModel.signInUser(signinView.emailTextField.text!, password: signinView.passwordTextField.text!) { results in

                switch results {
                case .Success(_): PKHUD.sharedHUD.hide(animated: true)
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): self.showSystemErrorView(err)
                }
            }
            
        } catch {
            
        }

    }

    func didTapcancelButton(sender: UIButton) {
        self.view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
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
        
        presentViewController(RootViewController(), animated: true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let characterCount = signinView.passwordTextField.text!.characters.count
        if characterCount >= 3 {
            signinView.signinButton.backgroundColor = UIColor(fromHexString: "#152036")
        } else {
            signinView.signinButton.backgroundColor = CreateAccountViewSignupButtonColor
        }
        
        return true
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == signinView.emailTextField {
            signinView.passwordTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)
        
        createProfileViewController()
    }

}
