//
//  CreateAccountViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/10/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    var viewModel: SignupViewModel
    var createAccountView: CreateAccountView
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        self.viewModel.sessionManager.setUserDefaultsValue(false, forKey: "keyboardInstall")
        
        createAccountView = CreateAccountView()
        createAccountView.translatesAutoresizingMaskIntoConstraints = false
    
        super.init(nibName: nil, bundle: nil)
        
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
        createAccountView.signupTwitterButton.addTarget(self, action: "didTapSignupTwitterButton:", forControlEvents: .TouchUpInside)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func didTapCancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapSignupTwitterButton(sender: UIButton) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        do {
            try viewModel.sessionManager.login(.Twitter, completion: { results  -> Void in
                PKHUD.sharedHUD.hide(animated: true)
                switch results {
                case .Success(_): self.createKeyboardInstallationWalkthroughViewController()
                case .Error(let e): print("Error", e)
                default: break
                }
            })
        } catch {
    
        }
    }
    
    func didTapSignupButton(sender: UIButton) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        if createAccountView.usernameTextField.text!.characters.count != 0 && createAccountView.emailTextField.text!.characters.count != 0  && createAccountView.passwordTextField.text!.characters.count != 0 {
            viewModel.user.name = createAccountView.usernameTextField.text!
            viewModel.user.email = createAccountView.emailTextField.text!
            viewModel.password = createAccountView.passwordTextField.text!
            do {
                try viewModel.signUpUser({ results -> Void in
                     PKHUD.sharedHUD.hide(animated: true)
                    switch results {
                    case .Success(_): self.createKeyboardInstallationWalkthroughViewController()
                    case .Error(let e): print("Error", e)
                    default: break
                    }
                })
            } catch {
                
            }
        }
        else {
            PKHUD.sharedHUD.hide(animated: true)

        }
    }
    
    func createKeyboardInstallationWalkthroughViewController() {
        let keyboardInstallationWalkthrough = KeyboardInstallationWalkthroughViewController(viewModel: self.viewModel)
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
        self.view.endEditing(true)
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
}