//
//  CreateAccountView.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
// swiftlint:disable function_body_length

import Foundation

class CreateAccountView: UIView {
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let usernameTextField: UITextField
    let usernameTextFieldDivider: UIView
    let emailTextField: UITextField
    let emailTextFieldDivider: UIView
    let passwordTextField: UITextField
    let passwordTextFieldDivider: UIView
    let signupButton: UIButton
    let signupTwitterButton: UIButton
    let signupFacebookButton: UIButton
    let orSpacer: ViewSpacerWithText
    let cancelButton: UIButton
    let termsOfUseAndPrivacyPolicyButton: UIButton

    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.text = "Create your account"
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.text = "Save your favorite lyrics to your keyboard \n and profile by creating an account!"
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.54
        
        usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Username"
        usernameTextField.font = UIFont(name: "Montserrat", size: 11)
        
        usernameTextFieldDivider = UIView()
        usernameTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        usernameTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email Address"
        emailTextField.font = UIFont(name: "Montserrat", size: 11)
    
        emailTextFieldDivider = UIView()
        emailTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Add Password (min 6 characters)"
        passwordTextField.font = UIFont(name: "Montserrat", size: 11)
        passwordTextField.secureTextEntry = true
        
        passwordTextFieldDivider = UIView()
        passwordTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        signupButton = UIButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.backgroundColor = CreateAccountViewSignupButtonColor
        signupButton.setTitle("sign up".uppercaseString, forState: .Normal)
        signupButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signupButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        signupButton.layer.cornerRadius = 4.0
        signupButton.clipsToBounds = true
        
        orSpacer = ViewSpacerWithText(title:"Or With")
        orSpacer.translatesAutoresizingMaskIntoConstraints = false

        signupTwitterButton = UIButton()
        signupTwitterButton.translatesAutoresizingMaskIntoConstraints = false
        signupTwitterButton.backgroundColor = CreateAccountViewSignupTwitterButtonColor
        signupTwitterButton.setTitle("twitter".uppercaseString, forState: .Normal)
        signupTwitterButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signupTwitterButton.setTitleColor(CreateAccountViewSignupTwitterButtonFontColor , forState: .Normal)
        signupTwitterButton.layer.cornerRadius = 4.0
        signupTwitterButton.clipsToBounds = true

        signupFacebookButton = UIButton()
        signupFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        signupFacebookButton.backgroundColor = FacebookButtonNormalBackgroundColor
        signupFacebookButton.setTitle("facebook".uppercaseString, forState: .Normal)
        signupFacebookButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signupFacebookButton.setTitleColor(FacebookButtonTitleTextColor , forState: .Normal)
        signupFacebookButton.layer.cornerRadius = 4.0
        signupFacebookButton.clipsToBounds = true
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfButtonclose(scale: 1.0), forState: .Normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 17, left: 20, bottom: 20, right: 15)
        
        termsOfUseAndPrivacyPolicyButton = UIButton()
        termsOfUseAndPrivacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        termsOfUseAndPrivacyPolicyButton.setTitle("By creating an account, I agree to Oftens \n Terms of use and Privacy Policy", forState: .Normal)
        termsOfUseAndPrivacyPolicyButton.titleLabel!.font = UIFont(name: "Montserrat", size: 8)
        termsOfUseAndPrivacyPolicyButton.titleLabel!.numberOfLines = 0
        termsOfUseAndPrivacyPolicyButton.titleLabel!.textAlignment = .Center
        termsOfUseAndPrivacyPolicyButton.setTitleColor(BlackColor , forState: .Normal)
        termsOfUseAndPrivacyPolicyButton.alpha = 0.36
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(usernameTextField)
        addSubview(usernameTextFieldDivider)
        addSubview(emailTextField)
        addSubview(emailTextFieldDivider)
        addSubview(passwordTextField)
        addSubview(passwordTextFieldDivider)
        addSubview(signupFacebookButton)
        addSubview(signupButton)
        addSubview(signupTwitterButton)
        addSubview(orSpacer)
        addSubview(cancelButton)
        addSubview(termsOfUseAndPrivacyPolicyButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 75,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            cancelButton.al_top == al_top,
            cancelButton.al_right == al_right,
            cancelButton.al_width == 55,
            cancelButton.al_height == 59,

            subtitleLabel.al_top == titleLabel.al_bottom + 8,
            subtitleLabel.al_left == al_left  + 60,
            subtitleLabel.al_right == al_right - 60,
            
            usernameTextField.al_top == subtitleLabel.al_bottom + 40,
            usernameTextField.al_left == al_left + 40,
            usernameTextField.al_right == al_right - 40,
            usernameTextField.al_height == 40,
            
            usernameTextFieldDivider.al_top == usernameTextField.al_bottom,
            usernameTextFieldDivider.al_left == al_left + 40,
            usernameTextFieldDivider.al_right == al_right - 40,
            usernameTextFieldDivider.al_height == 1,
            
            emailTextField.al_top == usernameTextFieldDivider.al_bottom + 20,
            emailTextField.al_left == al_left + 40,
            emailTextField.al_right == al_right - 40,
            emailTextField.al_height == 40,
            
            emailTextFieldDivider.al_top == emailTextField.al_bottom,
            emailTextFieldDivider.al_left == al_left + 40,
            emailTextFieldDivider.al_right == al_right - 40,
            emailTextFieldDivider.al_height == 1,
            
            passwordTextField.al_top == emailTextFieldDivider.al_bottom + 20,
            passwordTextField.al_left == al_left + 40,
            passwordTextField.al_right == al_right - 40,
            passwordTextField.al_height == 40,
            
            passwordTextFieldDivider.al_top == passwordTextField.al_bottom,
            passwordTextFieldDivider.al_left == al_left + 40,
            passwordTextFieldDivider.al_right == al_right - 40,
            passwordTextFieldDivider.al_height == 1,
            
            signupButton.al_top == passwordTextFieldDivider.al_bottom + 40,
            signupButton.al_left == al_left + 40,
            signupButton.al_right == al_right - 40,
            signupButton.al_height == 50,
            
            orSpacer.al_top == signupButton.al_bottom + 5,
            orSpacer.al_left == al_left + 40,
            orSpacer.al_right == al_right - 40,
            orSpacer.al_height == 40,

        ])

        addConstraints([
            signupTwitterButton.al_top == orSpacer.al_bottom + 5,
            signupTwitterButton.al_left == al_left + 40,
            signupTwitterButton.al_right == al_centerX - 2,
            signupTwitterButton.al_height == 50,

            signupFacebookButton.al_top == signupTwitterButton.al_top,
            signupFacebookButton.al_left == al_centerX + 2,
            signupFacebookButton.al_right == al_right - 40,
            signupFacebookButton.al_height == 50,

            termsOfUseAndPrivacyPolicyButton.al_top == signupTwitterButton.al_bottom + 10,
            termsOfUseAndPrivacyPolicyButton.al_left == al_left + 40,
            termsOfUseAndPrivacyPolicyButton.al_right == al_right - 40,
            termsOfUseAndPrivacyPolicyButton.al_height == 36,
            
            ])


    }

}