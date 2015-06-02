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
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(fullNameTxtField)
        addSubview(spacer)
        
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

            ])
    }
    
    
    
}