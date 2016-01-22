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
    let orSpacer: ViewSpacerWithText
    let signinButton: UIButton
    let signinTwitterButton: UIButton
    let signinFacebookButton: UIButton
    let forgetPasswordButton: UIButton
    let cancelButton: UIButton

    private var titleLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 90
        }
        return 120
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.text = "Sign in"
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
        subtitleLabel.text = "Welcome back fam."
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.74
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.font = UIFont(name: "Montserrat-Regular", size: 11)
        
        emailTextFieldDivider = UIView()
        emailTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Montserrat-Regular", size: 11)
        passwordTextField.secureTextEntry = true
        
        passwordTextFieldDivider = UIView()
        passwordTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        signinButton = LoginButton.EmailButton()
        signinButton.setTitle("sign in".uppercaseString, forState: .Normal)
        
        signinTwitterButton = LoginButton.TwitterButton()
        signinFacebookButton = LoginButton.FacebookButton()

        orSpacer = ViewSpacerWithText(title:"Or With")
        orSpacer.translatesAutoresizingMaskIntoConstraints = false
        
        forgetPasswordButton = UIButton()
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButton.setTitle("Forgot?", forState: .Normal)
        forgetPasswordButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        forgetPasswordButton.setTitleColor(CreateAccountViewSignupTwitterButtonColor , forState: .Normal)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfButtonclose(scale: 1.0), forState: .Normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 17, left: 20, bottom: 20, right: 15)
        
        
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
        addSubview(signinFacebookButton)
        addSubview(forgetPasswordButton)
        addSubview(orSpacer)
        addSubview(cancelButton)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            cancelButton.al_top == al_top ,
            cancelButton.al_right == al_right,
            cancelButton.al_width == 55,
            cancelButton.al_height == 59,
            
            titleLabel.al_top == al_top + titleLabelHeightTopMargin,
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
            signinButton.al_height == 50,
            
            signinTwitterButton.al_top == orSpacer.al_bottom + 5,
            signinTwitterButton.al_left == al_left + 40,
            signinTwitterButton.al_right == al_centerX - 2,
            signinTwitterButton.al_height == 50,

            signinFacebookButton.al_top == signinTwitterButton.al_top,
            signinFacebookButton.al_left == al_centerX + 2,
            signinFacebookButton.al_right == al_right - 40,
            signinFacebookButton.al_height == 50,

            orSpacer.al_top == signinButton.al_bottom + 5,
            orSpacer.al_left == al_left + 40,
            orSpacer.al_right == al_right - 40,
            orSpacer.al_height == 40,
            ])
    }
    
}