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
    var fullNameTxtField : UITextField!
    var spacer : UIView!
    var termAndServiceLabel: UILabel!
    var andLabel: UILabel!
    var termsofService: UIButton!
    var privacyPolicy: UIButton!
    
     override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = BaseFont
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "WHAT YOUR NAME ?"
        
        fullNameTxtField = UITextField()
        fullNameTxtField.textAlignment = .Center
        fullNameTxtField.font = BaseFont
        fullNameTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        termAndServiceLabel = UILabel()
        termAndServiceLabel.textAlignment = .Center
        termAndServiceLabel.font = BaseFont
        termAndServiceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        termAndServiceLabel.text = "By registering, I accept the "
        
        andLabel = UILabel()
        andLabel.textAlignment = .Center
        andLabel.font = BaseFont
        andLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        andLabel.text = "&"
        
        termsofService = UIButton()
        termsofService.setTranslatesAutoresizingMaskIntoConstraints(false)
        termsofService.setTitle("Terms of Service", forState: .Normal)
        termsofService.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        privacyPolicy = UIButton()
        privacyPolicy.setTranslatesAutoresizingMaskIntoConstraints(false)
        privacyPolicy.setTitle("Privacy Policy", forState: .Normal)
        privacyPolicy.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(fullNameTxtField)
        addSubview(spacer)
        addSubview(termAndServiceLabel)
        addSubview(andLabel)
        addSubview(termsofService)
        addSubview(privacyPolicy)
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
            
            fullNameTxtField.al_top == titleLabel.al_bottom + 20,
            fullNameTxtField.al_width == 100,
            fullNameTxtField.al_height == 44,
            fullNameTxtField.al_centerX == al_centerX,
            
            spacer.al_top == fullNameTxtField.al_bottom + 8,
            spacer.al_height == 1,
            spacer.al_width == 60,
            spacer.al_centerX == al_centerX,
            
            termAndServiceLabel.al_top == spacer.al_bottom + 20,
            termAndServiceLabel.al_left == al_left,
            termAndServiceLabel.al_right == al_right,
            termAndServiceLabel.al_centerX == al_centerX,
            
            andLabel.al_top == termAndServiceLabel.al_bottom + 6,
            andLabel.al_width == 20,
            andLabel.al_centerX == al_centerX,
            
            termsofService.al_top == termAndServiceLabel.al_bottom + 2,
            termsofService.al_width == 140,
            termsofService.al_right == andLabel.al_left - 4,
            
            privacyPolicy.al_top == termAndServiceLabel.al_bottom + 2,
            privacyPolicy.al_width == 120,
            privacyPolicy.al_left == andLabel.al_right + 4,

            
            
            ])
    }
    
    
    
}