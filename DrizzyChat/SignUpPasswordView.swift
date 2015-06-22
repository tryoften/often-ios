//
//  SignUpPasswordView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpPasswordView: UIView {
    var titleLabel: UILabel!
    var titleLabelTwo: UILabel!
    var passwordTxtFieldOne : UITextField!
    var confirmPasswordTxtField : UITextField!
    var spacer : UIView!
    var spacerTwo : UIView!
    var termsAndPrivacyView : TermsAndPrivacyView
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "OpenSans", size: 14)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "choose a password:".uppercaseString
        
        titleLabelTwo = UILabel()
        titleLabelTwo.textAlignment = .Center
        titleLabelTwo.font = UIFont(name: "OpenSans", size: 14)
        titleLabelTwo.textColor = UIColor(fromHexString: "#202020")
        titleLabelTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabelTwo.text = "confirm that password:".uppercaseString
        
        passwordTxtFieldOne = UITextField()
        passwordTxtFieldOne.textAlignment = .Center
        passwordTxtFieldOne.font = UIFont(name: "OpenSans", size: 14)
        passwordTxtFieldOne.placeholder = "enter your password"
        passwordTxtFieldOne.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTxtFieldOne.secureTextEntry = true
        
        confirmPasswordTxtField = UITextField()
        confirmPasswordTxtField.textAlignment = .Center
        confirmPasswordTxtField.font = UIFont(name: "OpenSans", size: 14)
        confirmPasswordTxtField.placeholder = "re-enter your password"
        confirmPasswordTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        confirmPasswordTxtField.secureTextEntry = true
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        spacerTwo = UIView()
        spacerTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacerTwo.backgroundColor = UIColor.blackColor()
        
        termsAndPrivacyView = TermsAndPrivacyView()
        termsAndPrivacyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(titleLabelTwo)
        addSubview(passwordTxtFieldOne)
        addSubview(confirmPasswordTxtField)
        addSubview(spacer)
        addSubview(spacerTwo)
        addSubview(termsAndPrivacyView)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 90,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_centerX == al_centerX,
            
            passwordTxtFieldOne.al_top == titleLabel.al_bottom + 6,
            passwordTxtFieldOne.al_left == al_left + 20,
            passwordTxtFieldOne.al_right == al_right - 20,
            passwordTxtFieldOne.al_centerX == al_centerX,

            spacer.al_top == passwordTxtFieldOne.al_bottom + 8,
            spacer.al_height == 0.7,
            spacer.al_width == 40,
            spacer.al_centerX == al_centerX,

            titleLabelTwo.al_top == spacer.al_bottom + 20,
            titleLabelTwo.al_left == al_left,
            titleLabelTwo.al_right == al_right,
            titleLabelTwo.al_height == titleLabel.al_height,
            titleLabelTwo.al_centerX == al_centerX,
            
            confirmPasswordTxtField.al_top == titleLabelTwo.al_bottom + 6,
            confirmPasswordTxtField.al_left == al_left + 20,
            confirmPasswordTxtField.al_right == al_right - 20,
            confirmPasswordTxtField.al_centerX == al_centerX,
            
            spacerTwo.al_top == confirmPasswordTxtField.al_bottom + 8,
            spacerTwo.al_height == 0.7,
            spacerTwo.al_width == 40,
            spacerTwo.al_centerX == al_centerX,
            
            termsAndPrivacyView.al_top == spacerTwo.al_bottom + 55,
            termsAndPrivacyView.al_left == al_left + 32,
            termsAndPrivacyView.al_right == al_right - 32,
        ])
    }
}
