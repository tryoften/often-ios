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
    var passwordTxtFieldTwo : UITextField!
    var spacer : UIView!
    var spacerTwo : UIView!
    var termAndServiceLabel: UILabel!
    var andLabel: UILabel!
    var termsofService: UIButton!
    var privacyPolicy: UIButton!
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = BaseFont
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "CHOOSE A PASSWORD"
        
        titleLabelTwo = UILabel()
        titleLabelTwo.textAlignment = .Center
        titleLabelTwo.font = BaseFont
        titleLabelTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabelTwo.text = "COMFIRM THAT PASSWORD:"
        
        passwordTxtFieldOne = UITextField()
        passwordTxtFieldOne.textAlignment = .Center
        passwordTxtFieldOne.font = BaseFont
        passwordTxtFieldOne.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        passwordTxtFieldTwo = UITextField()
        passwordTxtFieldTwo.textAlignment = .Center
        passwordTxtFieldTwo.font = BaseFont
        passwordTxtFieldTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        spacer = UIView()
        spacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacer.backgroundColor = UIColor.blackColor()
        
        spacerTwo = UIView()
        spacerTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        spacerTwo.backgroundColor = UIColor.blackColor()
        
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
        addSubview(titleLabelTwo)
        addSubview(passwordTxtFieldOne)
        addSubview(passwordTxtFieldTwo)
        addSubview(spacer)
        addSubview(spacerTwo)
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
            titleLabel.al_top == al_top + 110,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_centerX == al_centerX,
            
            passwordTxtFieldOne.al_top == titleLabel.al_bottom + 20,
            passwordTxtFieldOne.al_width == 100,
            passwordTxtFieldOne.al_height == 44,
            passwordTxtFieldOne.al_centerX == al_centerX,
            
            spacer.al_top == passwordTxtFieldOne.al_bottom + 8,
            spacer.al_height == 1,
            spacer.al_width == 60,
            spacer.al_centerX == al_centerX,
            
            titleLabelTwo.al_top == spacer.al_bottom + 20,
            titleLabelTwo.al_left == al_left,
            titleLabelTwo.al_right == al_right,
            titleLabelTwo.al_centerX == al_centerX,
            
            passwordTxtFieldTwo.al_top == titleLabelTwo.al_bottom + 20,
            passwordTxtFieldTwo.al_width == 100,
            passwordTxtFieldTwo.al_height == 44,
            passwordTxtFieldTwo.al_centerX == al_centerX,
            
            spacerTwo.al_top == passwordTxtFieldTwo.al_bottom + 8,
            spacerTwo.al_height == 1,
            spacerTwo.al_width == 60,
            spacerTwo.al_centerX == al_centerX,
            
            termAndServiceLabel.al_top == spacerTwo.al_bottom + 20,
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
