//
//  LoginView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginView: UIView {
    var emailTxtField : UITextField!
    var passwordTxtField : UITextField!
    var emailTxtSpacer: UIView!
    var passwordSpacer: UIView!
    var orSpacerOne: UIView!
    var orSpacerTwo: UIView!
    var orLabel: UILabel!
    var facebookButton: FacebookButton
    
     override init(frame: CGRect) {
        var passwordIconImageView = UIImageView();
        passwordIconImageView.image = UIImage(named: "PasswordIcon")
        passwordIconImageView.frame = CGRectMake(0, 0, 25, 25)
        passwordIconImageView.contentMode = .ScaleAspectFit
        
        var emailIconImageView = UIImageView();
        emailIconImageView.image = UIImage(named: "ProfileIcon")
        emailIconImageView.frame = CGRectMake(0, 0, 25, 25)
        emailIconImageView.contentMode = .ScaleAspectFit
        
        emailTxtField = UITextField()
        emailTxtField.textAlignment = .Left
        emailTxtField.font = UIFont(name: "OpenSans", size: 14)
        emailTxtField.placeholder = "email".uppercaseString
        emailTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTxtField.leftViewMode = .Always
        emailTxtField.leftView = emailIconImageView
        
        passwordTxtField = UITextField()
        passwordTxtField.textAlignment = .Left
        passwordTxtField.font = UIFont(name: "OpenSans", size: 14)
        passwordTxtField.placeholder = "password".uppercaseString
        passwordTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        passwordTxtField.leftViewMode = .Always
        passwordTxtField.leftView = passwordIconImageView
        
        emailTxtSpacer = UIView()
        emailTxtSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        emailTxtSpacer.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        orLabel = UILabel()
        orLabel.textAlignment = .Center
        orLabel.font = SubtitleFont
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
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(emailTxtField)
        addSubview(passwordTxtField)
        addSubview(emailTxtSpacer)
        addSubview(orLabel)
        addSubview(passwordSpacer)
        addSubview(orSpacerOne)
        addSubview(orSpacerTwo)
        addSubview(facebookButton)
        
        setupLayout()
    }
    
     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setupLayout() {
        addConstraints([
            emailTxtField.al_top == al_top + 50,
            emailTxtField.al_right == al_right,
            emailTxtField.al_left == al_left,
            emailTxtField.al_height == 44,
            
            emailTxtSpacer.al_top == emailTxtField.al_bottom,
            emailTxtSpacer.al_right == al_right,
            emailTxtSpacer.al_left == al_left,
            emailTxtSpacer.al_height == 0.5,
            
            passwordTxtField.al_top == emailTxtSpacer.al_bottom,
            passwordTxtField.al_right == al_right,
            passwordTxtField.al_left == al_left,
            passwordTxtField.al_height == 44,
            
            passwordSpacer.al_top == passwordTxtField.al_bottom,
            passwordSpacer.al_right == al_right,
            passwordSpacer.al_left == al_left,
            passwordSpacer.al_height == 0.5,
            
            orLabel.al_top == passwordSpacer.al_bottom + 170,
            orLabel.al_width == 40,
            orLabel.al_centerX == al_centerX,
            orLabel.al_height == 40,

            orSpacerOne.al_top == passwordSpacer.al_bottom + 190,
            orSpacerOne.al_right == orLabel.al_left - 20,
            orSpacerOne.al_left == al_left + 20,
            orSpacerOne.al_height == 2,
            
            orSpacerTwo.al_top == passwordSpacer.al_bottom + 190,
            orSpacerTwo.al_right == al_right - 20,
            orSpacerTwo.al_left == orLabel.al_right + 20,
            orSpacerTwo.al_height == 2,
            
            facebookButton.al_height == 60,
            facebookButton.al_top == orLabel.al_bottom + 10,
            facebookButton.al_left == al_left + 10,
            facebookButton.al_right == al_right - 10,
            ])
    }

}