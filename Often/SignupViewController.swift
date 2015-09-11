//
//  SignupViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SignupViewController: UIViewController {
    var viewModel: SignupViewModel
    var signupView: SignupView
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        signupView = SignupView()
        signupView.setTranslatesAutoresizingMaskIntoConstraints(false)
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(signupView)
        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupView.createAccountButton.addTarget(self,  action: "didTapcreateAccountButton:", forControlEvents: .TouchUpInside)
        signupView.signinButton.addTarget(self, action: "didTapSigninButton:", forControlEvents: .TouchUpInside)
        
    }
    
    func didTapcreateAccountButton(sender: UIButton) {
        let createAccount = CreateAccountViewController(viewModel:self.viewModel)
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    func didTapSigninButton(sender: UIButton) {
        let createAccount = SigninViewController(viewModel:self.viewModel)
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            signupView.al_bottom == view.al_bottom,
            signupView.al_top == view.al_top,
            signupView.al_left == view.al_left,
            signupView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

}