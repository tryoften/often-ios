//
//  SetUserProfileDescriptionView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfileDescriptionView: UIView {
    var titleLabel: UILabel
    var titleTextField: UITextField
    var titleTextFieldDivider: UIView
    var descriptionLabel: UILabel
    var descriptionTextField: UITextField
    var descriptionTextFieldDivider: UIView
    
    override init(frame: CGRect) {

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Left
        titleLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 9)!, letterSpacing: 1.0, color: BlackColor, text: "title".uppercaseString)
        
        titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Ex Komoji, Katemoji, Bootychamp, etc."
        titleTextField.font = UIFont(name: "OpenSans-Semibold", size: 12)!
        
        titleTextFieldDivider = UIView()
        titleTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        titleTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .Left
        descriptionLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 9)!, letterSpacing: 1.0, color: BlackColor, text: "description".uppercaseString)
        
        descriptionTextField = UITextField()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Make your friends want thisssss"
        descriptionTextField.font = UIFont(name: "OpenSans", size: 12)

        descriptionTextFieldDivider = UIView()
        descriptionTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(titleTextField)
        addSubview(titleTextFieldDivider)
        addSubview(descriptionLabel)
        addSubview(descriptionTextField)
        addSubview(descriptionTextFieldDivider)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top,
            titleLabel.al_left == al_left + 18,
            titleLabel.al_height == 10,
            
            titleTextField.al_top == titleLabel.al_bottom + 2,
            titleTextField.al_left == al_left + 30,
            titleTextField.al_right == al_right - 30,
            titleTextField.al_height == 40,
            
            titleTextFieldDivider.al_top == titleTextField.al_bottom,
            titleTextFieldDivider.al_left == al_left + 18,
            titleTextFieldDivider.al_right == al_right - 18,
            titleTextFieldDivider.al_height == 1,
            
            descriptionLabel.al_top == titleTextFieldDivider.al_bottom + 25,
            descriptionLabel.al_left == al_left + 18,
            descriptionLabel.al_height == 10,

            descriptionTextField.al_top == descriptionLabel.al_bottom + 2,
            descriptionTextField.al_left == al_left + 30,
            descriptionTextField.al_right == al_right - 30,
            descriptionTextField.al_height == 40,

            descriptionTextFieldDivider.al_top == descriptionTextField.al_bottom,
            descriptionTextFieldDivider.al_left == al_left + 18,
            descriptionTextFieldDivider.al_right == al_right - 18,
            descriptionTextFieldDivider.al_height == 1,

            ])
    }
}