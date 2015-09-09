//
//  SigninView.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SigninView: UIView {
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let emailTextField: UITextField
    let emailTextFieldDivider: UIView
    let passwordTextField: UITextField
    let passwordTextFieldDivider: UIView
    let signinButton: UIButton
    let signinTwitterButton: UIButton
    let forgetPasswordButton: UIButton
    let cancelButton: UIButton
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = SigninViewTitleLabelFont
        titleLabel.text = "Sign in"
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.font = SigninViewSubtitleLabelFont
        subtitleLabel.text = "Welcome back fam."
        subtitleLabel.textAlignment = .Center
        
        emailTextField = UITextField()
        emailTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTextField.placeholder = "Email"
        emailTextField.font = SigninViewTitleLabelFont
        
        emailTextFieldDivider = UIView()
        emailTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTextFieldDivider.backgroundColor = SigninViewButtonDividersColor
        
        passwordTextField = UITextField()
        passwordTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTextField.placeholder = "Password"
        passwordTextField.font = SigninViewTitleLabelFont
        
        passwordTextFieldDivider = UIView()
        passwordTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTextFieldDivider.backgroundColor = SigninViewTitleLabelFont
        
        signinButton = UIButton()
        signinButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signinButton.backgroundColor = SigninViewSigninButtonColor
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        signinButton.titleLabel!.font = SigninViewSigninButtonFont
        signinButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
        signinTwitterButton = UIButton()
        signinTwitterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signinTwitterButton.backgroundColor = SigninViewSigninTwitterButtonColor
        signinTwitterButton.setTitle("sign in with twitter".uppercaseString, forState: .Normal)
        signinTwitterButton.titleLabel!.font = SigninViewSigninTwitterButtonFont
        signinTwitterButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
        forgetPasswordButton = UIButton()
        forgetPasswordButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        forgetPasswordButton.backgroundColor = SigninViewSigninTwitterButtonColor
        forgetPasswordButton.setTitle("Forget?", forState: .Normal)
        forgetPasswordButton.titleLabel!.font = SigninViewSigninButtonFont
        forgetPasswordButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
        cancelButton = UIButton()
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.backgroundColor = SignupViewCreateAccountButtonColor
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.titleLabel!.font = SignupViewCreateAccountButtonFont
        cancelButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
       super.init(frame: frame)
        
        backgroundColor = WalkthroughBackgroungColor
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(emailTextField)
        addSubview(emailTextFieldDivider)
        addSubview(passwordTextField)
        addSubview(passwordTextFieldDivider)
        addSubview(signinButton)
        addSubview(signinTwitterButton)
        addSubview(forgetPasswordButton)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            cancelButton.al_top == al_top + 10,
            cancelButton.al_right == al_right,
            cancelButton.al_width == 40,
            cancelButton.al_height == 20,
            
            titleLabel.al_top == al_top + 37,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_height == 60,
            
            emailTextField.al_top == subtitleLabel.al_bottom + 40,
            emailTextField.al_left == al_left + 40,
            emailTextField.al_right == al_right - 40,
            emailTextField.al_height == 40,
            
            emailTextFieldDivider.al_top == emailTextField.al_bottom,
            emailTextFieldDivider.al_left == al_left + 40,
            emailTextFieldDivider.al_right == al_right - 40,
            emailTextFieldDivider.al_height == 1.5,
            
            passwordTextField.al_top == emailTextFieldDivider.al_bottom + 20,
            passwordTextField.al_left == al_left + 40,
            passwordTextField.al_right == forgetPasswordButton.al_left,
            passwordTextField.al_height == 40,
            
            forgetPasswordButton.al_top == emailTextFieldDivider.al_bottom + 20,
            forgetPasswordButton.al_right == al_right - 40,
            forgetPasswordButton.al_width == 40,
            forgetPasswordButton.al_height == 20,
            
            passwordTextFieldDivider.al_top == emailTextField.al_bottom,
            passwordTextFieldDivider.al_left == al_left + 40,
            passwordTextFieldDivider.al_right == al_right - 40,
            passwordTextFieldDivider.al_height == 1.5,
            
            signinButton.al_top == passwordTextFieldDivider.al_bottom + 20,
            signinButton.al_left == al_left + 40,
            signinButton.al_right == al_right - 40,
            signinButton.al_height == 40,
            
            signinTwitterButton.al_top == signinButton.al_bottom + 20,
            signinTwitterButton.al_left == al_left + 40,
            signinTwitterButton.al_right == al_right - 40,
            signinTwitterButton.al_height == 40,
            ])
    }
    
}