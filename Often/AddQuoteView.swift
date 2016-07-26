//
//  AddQuoteView.swift
//  Often
//
//  Created by Katelyn Findlay on 7/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddQuoteView: UIView {
    var quoteTextView: UITextView
    var sourceTextField: UITextField
    var placeholderLabel: UILabel
    
    override init(frame: CGRect) {
        
        quoteTextView = UITextView()
        quoteTextView.translatesAutoresizingMaskIntoConstraints = false
        quoteTextView.textAlignment = .Right
        quoteTextView.font = UIFont(name: "Montserrat-Regular", size: 24)!
        quoteTextView.textColor = BlackColor
        quoteTextView.becomeFirstResponder()
        
        sourceTextField = UITextField()
        sourceTextField.translatesAutoresizingMaskIntoConstraints = false
        sourceTextField.placeholder = "Add Source"
        sourceTextField.textAlignment = .Left
        sourceTextField.font = UIFont(name: "OpenSans-Semibold", size: 18)!
        sourceTextField.textColor = BlackColor
        
        placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 24)!, letterSpacing: 0.5, color: UIColor.lightGrayColor(), text: "Your Text Here")
        placeholderLabel.hidden = false
        
        super.init(frame: frame)
        
        addSubview(quoteTextView)
        addSubview(placeholderLabel)
        addSubview(sourceTextField)
        
        backgroundColor = WhiteColor
        layer.cornerRadius = 2.5
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowColor = MediumLightGrey.CGColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            quoteTextView.al_top == al_top + 35,
            quoteTextView.al_right == al_right - 35,
            quoteTextView.al_width == 230,
            quoteTextView.al_height == 230,
            
            placeholderLabel.al_top == al_top + 41,
            placeholderLabel.al_right == al_right - 41,
            
            sourceTextField.al_left == al_left + 35,
            sourceTextField.al_bottom == al_bottom - 35,
            sourceTextField.al_right == al_right
        ])
    }
    
}