//
//  SignUpName.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpNameView: UIView {
    var titleLabel: UILabel!
    var fullNameTxtField: UITextField!
    var spacer: UIView!
    var termsAndPrivacyView: TermsAndPrivacyView
    
     override init(frame: CGRect) {
        let titleString = "Great! What's your name?"
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans-Semibold", size: 18)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1.5, range: titleRange)
        
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = titleString
        titleLabel.attributedText = title
        
        fullNameTxtField = UITextField()
        fullNameTxtField.textAlignment = .Center
        fullNameTxtField.font = UIFont(name: "OpenSans", size: 14)
        fullNameTxtField.placeholder = "enter your name here"
        fullNameTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        termsAndPrivacyView = TermsAndPrivacyView()
        termsAndPrivacyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(fullNameTxtField)
        addSubview(spacer)
        addSubview(termsAndPrivacyView)
        
        setupLayout()
    }
    
     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 135,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_centerX == al_centerX,
            
            fullNameTxtField.al_top == titleLabel.al_bottom + 20,
            fullNameTxtField.al_left == al_left + 20,
            fullNameTxtField.al_right == al_right - 20,
            fullNameTxtField.al_centerX == al_centerX,
            
            spacer.al_top == fullNameTxtField.al_bottom + 8,
            spacer.al_height == 0.6,
            spacer.al_width == 40,
            spacer.al_centerX == al_centerX,
            
            termsAndPrivacyView.al_top == spacer.al_bottom + 80,
            termsAndPrivacyView.al_left == al_left + 32,
            termsAndPrivacyView.al_right == al_right - 32,
            ])
    }
    
}