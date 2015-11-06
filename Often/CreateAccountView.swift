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
    let cancelButton: UIButton
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.text = "Create your account"
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.text = "Save your favorite videos, links, GIFs and songs by creating an account!"
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.74
        
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
        
        orLabel = UILabel()
        orLabel.textAlignment = .Center
        orLabel.font = UIFont(name: "OpenSans-Italic", size: 11)
        orLabel.textColor = UIColor(fromHexString: "#A0A0A0")
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.text = "Or"
        
        orSpacerOne = UIView()
        orSpacerOne.translatesAutoresizingMaskIntoConstraints = false
        orSpacerOne.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        orSpacerTwo = UIView()
        orSpacerTwo.translatesAutoresizingMaskIntoConstraints = false
        orSpacerTwo.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        signupTwitterButton = UIButton()
        signupTwitterButton.translatesAutoresizingMaskIntoConstraints = false
        signupTwitterButton.backgroundColor = CreateAccountViewSignupTwitterButtonColor
        signupTwitterButton.setTitle("sign up with twitter".uppercaseString, forState: .Normal)
        signupTwitterButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        signupTwitterButton.setTitleColor(CreateAccountViewSignupTwitterButtonFontColor , forState: .Normal)
        signupTwitterButton.layer.cornerRadius = 4.0
        signupTwitterButton.clipsToBounds = true
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfButtonclose(scale: 1.0), forState: .Normal)
        
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
        addSubview(signupButton)
        addSubview(signupTwitterButton)
        addSubview(orSpacerOne)
        addSubview(orSpacerTwo)
        addSubview(orLabel)
        addSubview(cancelButton)
        
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
            
            cancelButton.al_top == al_top + 20,
            cancelButton.al_right == al_right - 20,
            cancelButton.al_width == 20,
            cancelButton.al_height == 20,

            subtitleLabel.al_top == titleLabel.al_bottom + 8,
            subtitleLabel.al_left == al_left  + 80,
            subtitleLabel.al_right == al_right - 80,
            
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
            
            orLabel.al_top == signupButton.al_bottom + 5,
            orLabel.al_width == 70,
            orLabel.al_centerX == al_centerX,
            orLabel.al_height == 40,
            
            orSpacerOne.al_centerY == orLabel.al_centerY,
            orSpacerOne.al_right == orLabel.al_left,
            orSpacerOne.al_left == al_left + 40,
            orSpacerOne.al_height == 1,
            
            orSpacerTwo.al_centerY == orLabel.al_centerY,
            orSpacerTwo.al_right == al_right - 40,
            orSpacerTwo.al_left == orLabel.al_right,
            orSpacerTwo.al_height == 1,
            
            signupTwitterButton.al_top == orLabel.al_bottom + 5,
            signupTwitterButton.al_left == al_left + 40,
            signupTwitterButton.al_right == al_right - 40,
            signupTwitterButton.al_height == 50,
            ])
    }
}