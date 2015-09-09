//
//  CreateAccountView.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

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
    let orSpacerOne: UIView
    let orSpacerTwo: UIView
    let orLabel: UILabel
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = CreateAccountViewTitleLabelFont
        titleLabel.text = "Create your account"
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.font = CreateAccountViewSubtitleLabelFont
        subtitleLabel.text = "Save your favorite videos, links, GIFs and songs by creating an account!"
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .Center
        
        usernameTextField = UITextField()
        usernameTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        usernameTextField.placeholder = "Username"
        usernameTextField.font = CreateAccountViewTitleLabelFont
        
        usernameTextFieldDivider = UIView()
        usernameTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        usernameTextFieldDivider.backgroundColor = CreateAccountViewButtonDividersColor
        
        emailTextField = UITextField()
        emailTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTextField.placeholder = "Email Address"
        emailTextField.font = SignupViewCreateAccountButtonFont
        
        emailTextFieldDivider = UIView()
        emailTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTextFieldDivider.backgroundColor = CreateAccountViewButtonDividersColor
        
        passwordTextField = UITextField()
        passwordTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTextField.placeholder = "Add Password (min 6 characters)"
        passwordTextField.font = SignupViewCreateAccountButtonFont
        
        passwordTextFieldDivider = UIView()
        passwordTextFieldDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTextFieldDivider.backgroundColor = CreateAccountViewButtonDividersColor
        
        signupButton = UIButton()
        signupButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signupButton.backgroundColor = CreateAccountViewSignupButtonColor
        signupButton.setTitle("sign up".uppercaseString, forState: .Normal)
        signupButton.titleLabel!.font = CreateAccountViewSignupButtonFont
        signupButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
        orLabel = UILabel()
        orLabel.textAlignment = .Center
        orLabel.font = WalkthroughSpacerFront
        orLabel.textColor = CreateAccountViewButtonDividersColor
        orLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        orLabel.text = "Or"
        
        orSpacerOne = UIView()
        orSpacerOne.setTranslatesAutoresizingMaskIntoConstraints(false)
        orSpacerOne.backgroundColor = CreateAccountViewButtonDividersColor
        
        orSpacerTwo = UIView()
        orSpacerTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        orSpacerTwo.backgroundColor = CreateAccountViewButtonDividersColor
        
        signupTwitterButton = UIButton()
        signupTwitterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        signupTwitterButton.backgroundColor = CreateAccountViewSignupTwitterButtonColor
        signupTwitterButton.setTitle("sign up".uppercaseString, forState: .Normal)
        signupTwitterButton.titleLabel!.font = CreateAccountViewSignupTwitterButtonFont
        signupTwitterButton.setTitleColor(CreateAccountViewSignupTwitterButtonFontColor , forState: .Normal)
        
        super.init(frame: frame)
        
        backgroundColor = WalkthroughBackgroungColor
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(usernameTextField)
        addSubview(usernameTextFieldDivider)
        addSubview(emailTextField)
        addSubview(emailTextFieldDivider)
        addSubview(passwordTextField)
        addSubview(passwordTextFieldDivider)
        addSubview(signupButton)
        addSubview(signupTwitterButton)
        addSubview(orSpacerOne)
        addSubview(orSpacerTwo)
        addSubview(orLabel)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 37,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_height == 60,
            
            usernameTextField.al_top == subtitleLabel.al_bottom + 40,
            usernameTextField.al_left == al_left + 40,
            usernameTextField.al_right == al_right - 40,
            usernameTextField.al_height == 40,
            
            usernameTextFieldDivider.al_top == usernameTextField.al_bottom,
            usernameTextFieldDivider.al_left == al_left + 40,
            usernameTextFieldDivider.al_right == al_right - 40,
            usernameTextFieldDivider.al_height == 1.5,
            
            emailTextField.al_top == usernameTextFieldDivider.al_bottom + 20,
            emailTextField.al_left == al_left + 40,
            emailTextField.al_right == al_right - 40,
            emailTextField.al_height == 40,
            
            emailTextFieldDivider.al_top == emailTextField.al_bottom,
            emailTextFieldDivider.al_left == al_left + 40,
            emailTextFieldDivider.al_right == al_right - 40,
            emailTextFieldDivider.al_height == 1.5,
            
            passwordTextField.al_top == emailTextFieldDivider.al_bottom + 20,
            passwordTextField.al_left == al_left + 40,
            passwordTextField.al_right == al_right - 40,
            passwordTextField.al_height == 40,
            
            passwordTextFieldDivider.al_top == passwordTextField.al_bottom,
            passwordTextFieldDivider.al_left == al_left + 40,
            passwordTextFieldDivider.al_right == al_right - 40,
            passwordTextFieldDivider.al_height == 1.5,
            
            signupButton.al_top == passwordTextFieldDivider.al_bottom + 40,
            signupButton.al_left == al_left + 40,
            signupButton.al_right == al_right - 40,
            signupButton.al_height == 40,
            
            orLabel.al_top == signupButton.al_bottom + 20,
            orLabel.al_width == 40,
            orLabel.al_centerX == al_centerX,
            orLabel.al_height == 40,
            
            orSpacerOne.al_top == signupButton.al_bottom + 30,
            orSpacerOne.al_right == orLabel.al_left,
            orSpacerOne.al_left == al_left + 50,
            orSpacerOne.al_height == 1,
            
            orSpacerTwo.al_top == signupButton.al_bottom + 30,
            orSpacerTwo.al_right == al_right - 50,
            orSpacerTwo.al_left == orLabel.al_right,
            orSpacerTwo.al_height == 1,
            
            signupTwitterButton.al_top == orLabel.al_bottom + 20,
            signupTwitterButton.al_left == al_left + 40,
            signupTwitterButton.al_right == al_right - 40,
            signupTwitterButton.al_height == 40,
            ])
    }
}