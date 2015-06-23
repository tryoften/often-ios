//
//  SignUpPhoneNumber.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpPhoneNumberView: UIView {
    var titleLabel: UILabel!
    var phoneNumberTxtField: UITextField!
    var spacer: UIView!
    var subtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        let titleString = "Welcome to October!"
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
        
        phoneNumberTxtField = UITextField()
        phoneNumberTxtField.textAlignment = .Center
        phoneNumberTxtField.font = UIFont(name: "OpenSans", size: 14)
        phoneNumberTxtField.placeholder = "###-###-####"
        phoneNumberTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = BlackColor
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = SubtitleFont
        subtitleLabel.textColor = SubtitleGreyColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "To make sure you’re really really real, we gotta text you a confirmation code fam"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(spacer)
        addSubview(phoneNumberTxtField)
        
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
            
            phoneNumberTxtField.al_top == titleLabel.al_bottom + 20,
            phoneNumberTxtField.al_left == al_left + 20,
            phoneNumberTxtField.al_right == al_right - 20,
            phoneNumberTxtField.al_centerX == al_centerX,
            
            spacer.al_top == phoneNumberTxtField.al_bottom + 8,
            spacer.al_height == 0.60,
            spacer.al_width == 40,
            spacer.al_centerX == al_centerX,
            
            subtitleLabel.al_top == spacer.al_bottom + 110,
            subtitleLabel.al_left == al_left + 32,
            subtitleLabel.al_right == al_right - 32,
            subtitleLabel.al_height == 80,
        ])
    }
    
}
