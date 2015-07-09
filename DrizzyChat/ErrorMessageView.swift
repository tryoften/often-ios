//
//  ErrorMessageView.swift
//  October
//
//  Created by Kervins Valcourt on 7/6/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

class ErrorMessageView: UIView {
    var errorMessageLabel: UILabel
    
    override init(frame: CGRect) {
        errorMessageLabel = UILabel()
        errorMessageLabel.font = ErrorMessageFont
        errorMessageLabel.textColor = UIColor.whiteColor()
        errorMessageLabel.textAlignment = .Center
        errorMessageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        backgroundColor = WalkthroughErrorMessageBackgroundColor
        
        addSubview(errorMessageLabel)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            errorMessageLabel.al_top == al_top ,
            errorMessageLabel.al_left == al_left + 10,
            errorMessageLabel.al_right == al_right - 10,
            errorMessageLabel.al_bottom == al_bottom
            ])
    }
    
    
}