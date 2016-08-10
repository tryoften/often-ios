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
    let nameTextField: UITextField
    let nameTextFieldDivider: UIView
    let emailTextField: UITextField
    let emailTextFieldDivider: UIView
    let passwordTextField: UITextField
    let passwordTextFieldDivider: UIView
    let signupButton: UIButton
    let cancelButton: UIButton
    let termsOfUseAndPrivacyPolicyButton: UIButton

    private var titleLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 60
        }
        return 75
    }

    private var usernameTextFieldHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 30
        }
        return 40
    }

    private var subtitleLabelHeightLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 40
        }
        return 60
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.text = "Create your account"
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.text = "Save your favorite packs to your keyboard \n and profile by creating an account!"
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.54
        
        nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Name"
        nameTextField.font = UIFont(name: "Montserrat", size: 11)
        
        nameTextFieldDivider = UIView()
        nameTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
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
        
        signupButton = LoginButton.EmailButton()

        let signupButtonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.grayColor()
        ]

        let signupSelectButtonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        signupButton.setAttributedTitle(NSAttributedString(string: "sign up".uppercaseString, attributes: signupButtonAttributes), forState: .Normal)
        signupButton.setAttributedTitle(NSAttributedString(string: "sign up".uppercaseString, attributes: signupSelectButtonAttributes), forState: .Selected)
        signupButton.backgroundColor = UIColor.whiteColor()
        signupButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        signupButton.layer.borderWidth = 2

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
        addSubview(nameTextField)
        addSubview(nameTextFieldDivider)
        addSubview(emailTextField)
        addSubview(emailTextFieldDivider)
        addSubview(passwordTextField)
        addSubview(passwordTextFieldDivider)
        addSubview(signupButton)
        addSubview(cancelButton)
        addSubview(termsOfUseAndPrivacyPolicyButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + titleLabelHeightTopMargin,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,
            
            cancelButton.al_top == al_top,
            cancelButton.al_right == al_right,
            cancelButton.al_width == 55,
            cancelButton.al_height == 59,

            subtitleLabel.al_top == titleLabel.al_bottom + 8,
            subtitleLabel.al_left == al_left  + subtitleLabelHeightLeftAndRightMargin,
            subtitleLabel.al_right == al_right - subtitleLabelHeightLeftAndRightMargin,
            
            nameTextField.al_top == subtitleLabel.al_bottom + usernameTextFieldHeightTopMargin,
            nameTextField.al_left == al_left + 40,
            nameTextField.al_right == al_right - 40,
            nameTextField.al_height == 40,
            
            nameTextFieldDivider.al_top == nameTextField.al_bottom,
            nameTextFieldDivider.al_left == al_left + 40,
            nameTextFieldDivider.al_right == al_right - 40,
            nameTextFieldDivider.al_height == 1,
            
            emailTextField.al_top == nameTextFieldDivider.al_bottom + 20,
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
            
            termsOfUseAndPrivacyPolicyButton.al_top == signupButton.al_bottom + 10,
            termsOfUseAndPrivacyPolicyButton.al_left == al_left + 40,
            termsOfUseAndPrivacyPolicyButton.al_right == al_right - 40,
            termsOfUseAndPrivacyPolicyButton.al_height == 36,
        ])

    }

}