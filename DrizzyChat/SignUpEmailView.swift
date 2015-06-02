//
//  SignUpEmailView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpEmailView: UIView {
    var titleLabel: UILabel!
    var emailTxtField : UITextField!
    var spacer : UIView!
    var termsAndPrivacyView : TermsAndPrivacyView
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "OpenSans", size: 14)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "what's your email?".uppercaseString
        
        emailTxtField = UITextField()
        emailTxtField.textAlignment = .Center
        emailTxtField.font = TitleFont
        emailTxtField.placeholder = "Email Here"
        emailTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        termsAndPrivacyView = TermsAndPrivacyView()
        termsAndPrivacyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(emailTxtField)
        addSubview(spacer)
        addSubview(termsAndPrivacyView)
        
        setupLayout()

        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 190,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_centerX == al_centerX,
            
            emailTxtField.al_top == titleLabel.al_bottom + 20,
            emailTxtField.al_left == al_left + 20,
            emailTxtField.al_right == al_right - 20,
            emailTxtField.al_centerX == al_centerX,
            
            spacer.al_top == emailTxtField.al_bottom + 8,
            spacer.al_height == 0.7,
            spacer.al_width == 40,
            spacer.al_centerX == al_centerX,
            
            termsAndPrivacyView.al_top == spacer.al_bottom + 75,
            termsAndPrivacyView.al_left == al_left + 32,
            termsAndPrivacyView.al_right == al_right - 32,
            ])
    }
}
    