//
//  LoginView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginView: UIView {
    var emailTxtField : FlexibleBoundsTextField
    var passwordTxtField : FlexibleBoundsTextField
    var emailTxtSpacer: UIView
    var passwordSpacer: UIView
    var orSpacerOne: UIView
    var orSpacerTwo: UIView
    var whiteBackground: UIView
    var orLabel: UILabel
    var facebookButton: FacebookButton
    
     override init(frame: CGRect) {
        var passwordIconImageView = UIImageView();
        passwordIconImageView.image = UIImage(named: "PasswordIcon")
        passwordIconImageView.frame = CGRectMake(0, 0, 20, 20)
        passwordIconImageView.contentMode = .ScaleAspectFit
        
        var emailIconImageView = UIImageView();
        emailIconImageView.image = UIImage(named: "ProfileIcon")
        emailIconImageView.frame = CGRectMake(0, 0, 20, 20)
        emailIconImageView.contentMode = .ScaleAspectFit
        
        emailTxtField = FlexibleBoundsTextField()
        emailTxtField.leftMargin = 40.0
        emailTxtField.textAlignment = .Left
        emailTxtField.font = UIFont(name: "OpenSans", size: 14)
        emailTxtField.placeholder = "email".uppercaseString
        emailTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTxtField.leftViewMode = .Always
        emailTxtField.leftView = emailIconImageView
        emailTxtField.backgroundColor = UIColor.whiteColor()
        
        passwordTxtField = FlexibleBoundsTextField()
        passwordTxtField.leftMargin = 40.0
        passwordTxtField.textAlignment = .Left
        passwordTxtField.font = UIFont(name: "OpenSans", size: 14)
        passwordTxtField.placeholder = "password".uppercaseString
        passwordTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTxtField.leftViewMode = .Always
        passwordTxtField.leftView = passwordIconImageView
        passwordTxtField.secureTextEntry = true
        passwordTxtField.backgroundColor = UIColor.whiteColor()
        
        emailTxtSpacer = UIView()
        emailTxtSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTxtSpacer.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        facebookButton.setTitle("Login w/ Facebook".uppercaseString, forState: .Normal)
        
        orLabel = UILabel()
        orLabel.textAlignment = .Center
        orLabel.font = UIFont(name: "OpenSans-Italic", size: 12)
        orLabel.textColor = SubtitleGreyColor
        orLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        orLabel.text = "Or"
        
        passwordSpacer = UIView()
        passwordSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordSpacer.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        orSpacerOne = UIView()
        orSpacerOne.setTranslatesAutoresizingMaskIntoConstraints(false)
        orSpacerOne.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        orSpacerTwo = UIView()
        orSpacerTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        orSpacerTwo.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        whiteBackground = UIView()
        whiteBackground.setTranslatesAutoresizingMaskIntoConstraints(false)
        whiteBackground.backgroundColor = UIColor.whiteColor()
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#F7F7F7")
        whiteBackground.addSubview(emailTxtField)
        whiteBackground.addSubview(passwordTxtField)
        whiteBackground.addSubview(emailTxtSpacer)
        addSubview(orLabel)
        whiteBackground.addSubview(passwordSpacer)
        whiteBackground.addSubview(orSpacerOne)
        whiteBackground.addSubview(orSpacerTwo)
        addSubview(whiteBackground)
        addSubview(facebookButton)
        
        setupLayout()
    }
    
     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setupLayout() {
        addConstraints([
            emailTxtField.al_top == al_top + 20,
            emailTxtField.al_right == al_right,
            emailTxtField.al_left == al_left + 20,
            emailTxtField.al_height == 44,
            
            emailTxtSpacer.al_top == emailTxtField.al_bottom,
            emailTxtSpacer.al_right == al_right - 20,
            emailTxtSpacer.al_left == al_left + 20,
            emailTxtSpacer.al_height == 0.5,
            
            passwordTxtField.al_top == emailTxtSpacer.al_bottom,
            passwordTxtField.al_right == al_right,
            passwordTxtField.al_left == al_left + 20,
            passwordTxtField.al_height == 44,
            
            passwordSpacer.al_top == passwordTxtField.al_bottom,
            passwordSpacer.al_right == al_right + 20,
            passwordSpacer.al_left == al_left - 20,
            passwordSpacer.al_height == 0.5,
            
            orLabel.al_top == whiteBackground.al_bottom + 140,
            orLabel.al_width == 40,
            orLabel.al_centerX == al_centerX,
            orLabel.al_height == 40,

            orSpacerOne.al_top == whiteBackground.al_bottom + 160,
            orSpacerOne.al_right == orLabel.al_left - 20,
            orSpacerOne.al_left == al_left + 50,
            orSpacerOne.al_height == 1,
            
            orSpacerTwo.al_top == whiteBackground.al_bottom + 160,
            orSpacerTwo.al_right == al_right - 50,
            orSpacerTwo.al_left == orLabel.al_right,
            orSpacerTwo.al_height == 1,
            
            whiteBackground.al_top == al_top + 20,
            whiteBackground.al_right == al_right,
            whiteBackground.al_left == al_left,
            whiteBackground.al_height == 88,
            
            facebookButton.al_height == 60,
            facebookButton.al_top == orLabel.al_bottom + 5,
            facebookButton.al_left == al_left + 10,
            facebookButton.al_right == al_right - 10,
            ])
    }

}