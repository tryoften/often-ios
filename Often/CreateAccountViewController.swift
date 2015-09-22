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
    var pkRevealController: PKRevealController?
    var frontNavigationController: UINavigationController?
    var frontViewController: UserProfileViewController?
    var leftViewController: SocialAccountSettingsCollectionViewController?
    var rightViewController: AppSettingsViewController?
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
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
    
    func didTapCancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapSignupTwitterButton(sender: UIButton) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        viewModel.sessionManager.login(.Twitter, completion: { err in
            PKHUD.sharedHUD.hide(animated: true)
            if (err != nil) {
                print("didn't work")
            } else {
                self.createProfileViewController()
            }
        })
        
    }
    
    func didTapSignupButton(sender: UIButton) {
        if createAccountView.usernameTextField.text!.characters.count != 0 && createAccountView.emailTextField.text!.characters.count != 0  && createAccountView.passwordTextField.text!.characters.count != 0 {
            viewModel.user.name = createAccountView.usernameTextField.text!
            viewModel.user.email = createAccountView.emailTextField.text!
            viewModel.password = createAccountView.passwordTextField.text!
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            viewModel.signUpUser({ success  in
                PKHUD.sharedHUD.hide(animated: true)
                if success {
                    self.createProfileViewController()
                }
            })
        }
        else {
            return
        }
    }
    
    func createProfileViewController() {
        let userProfileViewModel = UserProfileViewModel(sessionManager: self.viewModel.sessionManager)
        let socialAccountViewModel = SocialAccountSettingsViewModel(sessionManager: self.viewModel.sessionManager, venmoAccountManager: self.viewModel.venmoAccountManager, spotifyAccountManager: self.viewModel.spotifyAccountManager, soundcloudAccountManager: self.viewModel.soundcloudAccountManager)
        
        // Front view controller must be navigation controller - will hide the nav bar
        self.frontViewController = UserProfileViewController(collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(), viewModel: userProfileViewModel)
        self.frontNavigationController = UINavigationController(rootViewController: self.frontViewController!)
        self.frontNavigationController?.setNavigationBarHidden(true, animated: true)
        
        // left view controller: Set Services for keyboard
        // right view controller: App Settings
        self.leftViewController = SocialAccountSettingsCollectionViewController(collectionViewLayout: SocialAccountSettingsCollectionViewController.provideCollectionViewLayout(), viewModel: socialAccountViewModel)
        self.rightViewController = AppSettingsViewController()
        
        
        // instantiate PKRevealController and set as mainController to do revealing
        self.pkRevealController = PKRevealController(frontViewController: self.frontNavigationController, leftViewController: self.leftViewController, rightViewController: self.rightViewController)
        self.pkRevealController?.setMinimumWidth(320.0, maximumWidth: 340.0, forViewController: self.leftViewController)
        self.pkRevealController?.setMinimumWidth(320.0, maximumWidth: 340.0, forViewController: self.rightViewController)
        self.presentViewController(self.pkRevealController!, animated: true, completion: nil)

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