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
    var pkRevealController: PKRevealController?
    var frontNavigationController: UINavigationController?
    var frontViewController: UserProfileViewController?
    var leftViewController: SocialAccountSettingsCollectionViewController?
    var rightViewController: AppSettingsViewController?
    
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
    
    func didTapSigninButton(sender: UIButton) {
        if EmailIsValid(signinView.emailTextField.text!) && PasswordIsValid(signinView.passwordTextField.text!) {
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            viewModel.sessionManager.loginWithUsername(signinView.emailTextField.text!, password: signinView.passwordTextField.text!, completion: { error  in
                PKHUD.sharedHUD.hide(animated: true)
                if error != nil {
                    print("error")
                } else {
                    self.createProfileViewController()
                }
            })
        } else {
            print("error")
        }

    }
    
    func didTapSigninTwitterButton(sender: UIButton) {
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
    
    func didTapcancelButton(sender: UIButton) {
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
        var characterCount = signinView.passwordTextField.text!.characters.count
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
