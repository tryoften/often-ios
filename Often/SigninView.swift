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
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
        subtitleLabel.text = "Welcome back fam."
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.74
        
        emailTextField = UITextField()
        emailTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTextField.placeholder = "Email"
        emailTextField.font = UIFont(name: "Montserrat-Regular", size: 11)
        
        emailTextFieldDivider = UIView()
        emailTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        passwordTextField = UITextField()
        passwordTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Montserrat-Regular", size: 11)
        
        passwordTextFieldDivider = UIView()
        passwordTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        signinButton = UIButton()
        signinButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signinButton.backgroundColor = SigninViewSigninButtonColor
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        signinButton.titleLabel!.font = UIFont(name: "Montserrat", size: 12)
        signinButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        signinButton.layer.cornerRadius = 4.0
        signinButton.clipsToBounds = true
        
        signinTwitterButton = UIButton()
        signinTwitterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signinTwitterButton.setTitle("sign in with twitter".uppercaseString, forState: .Normal)
        signinTwitterButton.titleLabel!.font = UIFont(name: "Montserrat", size: 12)
        signinTwitterButton.setTitleColor(CreateAccountViewSignupTwitterButtonColor, forState: .Normal)
        
        forgetPasswordButton = UIButton()
        forgetPasswordButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        forgetPasswordButton.setTitle("Forgot?", forState: .Normal)
        forgetPasswordButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        forgetPasswordButton.setTitleColor(CreateAccountViewSignupTwitterButtonColor , forState: .Normal)
        
        cancelButton = UIButton()
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.setImage(UIImage(named: "close"), forState: .Normal)
        
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(emailTextField)
        addSubview(emailTextFieldDivider)
        addSubview(passwordTextField)
        addSubview(passwordTextFieldDivider)
        addSubview(signinButton)
        addSubview(signinTwitterButton)
        addSubview(forgetPasswordButton)
        addSubview(cancelButton)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            cancelButton.al_top == al_top + 20,
            cancelButton.al_right == al_right - 20,
            cancelButton.al_width == 20,
            cancelButton.al_height == 20,
            
            titleLabel.al_top == al_top + 120,
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
            emailTextFieldDivider.al_height == 1,
            
            passwordTextField.al_top == emailTextFieldDivider.al_bottom + 20,
            passwordTextField.al_left == al_left + 40,
            passwordTextField.al_right == forgetPasswordButton.al_left,
            passwordTextField.al_height == 40,
            
            forgetPasswordButton.al_right == al_right - 40,
            forgetPasswordButton.al_width == 70,
            forgetPasswordButton.al_height == 40,
            forgetPasswordButton.al_centerY == passwordTextField.al_centerY,
            
            passwordTextFieldDivider.al_top == passwordTextField.al_bottom,
            passwordTextFieldDivider.al_left == al_left + 40,
            passwordTextFieldDivider.al_right == al_right - 40,
            passwordTextFieldDivider.al_height == 1,
            
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