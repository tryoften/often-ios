//
//  SigninViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/10/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SigninViewController: UIViewController, UITextFieldDelegate {
    var viewModel: SignupViewModel
    var signinView: SigninView

    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        signinView = SigninView()
        signinView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
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
        signinView.signinTwitterButton.addTarget(self, action:"didTapSigninTwitterButton:", forControlEvents: .TouchUpInside)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func didTapSigninButton(sender: UIButton) {
        self.view.endEditing(true)
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        
        do {
            try viewModel.signInUser(signinView.emailTextField.text!, password: signinView.passwordTextField.text!) { results -> Void in
                PKHUD.sharedHUD.hide(animated: true)
                switch results {
                case .Success(_): self.createProfileViewController()
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            }
            
        } catch {
            
        }

    }
    
    func didTapSigninTwitterButton(sender: UIButton) {
        self.view.endEditing(true)
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        do {
            try viewModel.sessionManager.login(.Twitter, completion: { results  -> Void in
                PKHUD.sharedHUD.hide(animated: true)
                switch results {
                case .Success(_): self.createProfileViewController()
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err):  DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })
        } catch {
            
        }
        
        
    }
    
    func showErrorView(error:ErrorType) {
        switch error {
        case TwitterAccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case TwitterAccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("Need to be connected to the internet", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case SessionManagerError.UnvalidSignUp:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case SignupError.EmailNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild email", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case SignupError.PasswordNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild password", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        default: break
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

}
