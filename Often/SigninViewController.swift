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
        
        signinView.cancelButton.addTarget(self,  action: #selector(SigninViewController.didTapcancelButton(_:)), forControlEvents: .TouchUpInside)
        signinView.signinButton.addTarget(self, action: #selector(SigninViewController.didTapSigninButton(_:)), forControlEvents: .TouchUpInside)
        signinView.signinButton.addTarget(self, action: #selector(UserCreationViewController.didTapLoginButton(_:)), forControlEvents: .TouchUpInside)
        signinView.signinFacebookButton.addTarget(self, action:#selector(UserCreationViewController.didTapLoginButton(_:)), forControlEvents: .TouchUpInside)
        signinView.signinTwitterButton.addTarget(self, action:#selector(UserCreationViewController.didTapLoginButton(_:)), forControlEvents: .TouchUpInside)
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func didTapSigninButton(sender: UIButton) {
        viewModel.userAuthData.email = signinView.emailTextField.text!
        viewModel.userAuthData.password = signinView.passwordTextField.text!
        viewModel.userAuthData.isNewUser = false

    }

    func didTapcancelButton(sender: UIButton) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)

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
        
        presentRootViewController(RootViewController())
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let characterCount = signinView.passwordTextField.text!.characters.count
        if characterCount >= 3 {
            signinView.signinButton.selected = true
            signinView.signinButton.layer.borderWidth = 0
            signinView.signinButton.backgroundColor = UIColor(fromHexString: "#152036")
        } else {
            signinView.signinButton.backgroundColor = UIColor.whiteColor()
            signinView.signinButton.selected = false
            signinView.signinButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
            signinView.signinButton.layer.borderWidth = 2
        }
        
        return true
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
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
