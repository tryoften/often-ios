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
    var phoneNumberTxtField : UITextField!
    var spacer: UIView!
    var subtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = BaseFont
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "WHAT YOUR NUMBER #?"
        
        phoneNumberTxtField = UITextField()
        phoneNumberTxtField.textAlignment = .Center
        phoneNumberTxtField.font = BaseFont
        phoneNumberTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = BaseFont
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "vsnclkxdmkl"
        
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
            
            titleLabel.al_top == al_top + 170,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_centerX == al_centerX,
            
            phoneNumberTxtField.al_top == titleLabel.al_bottom + 20,
            phoneNumberTxtField.al_width == 100,
            phoneNumberTxtField.al_height == 44,
            phoneNumberTxtField.al_centerX == al_centerX,
            
            spacer.al_top == phoneNumberTxtField.al_bottom + 8,
            spacer.al_height == 1,
            spacer.al_width == 60,
            spacer.al_centerX == al_centerX,
            
            subtitleLabel.al_top == spacer.al_bottom + 60,
            subtitleLabel.al_left == al_left,
            subtitleLabel.al_right == al_right,
            subtitleLabel.al_height == 80,
            ])
    }
    
    
}
