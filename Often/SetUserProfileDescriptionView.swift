//
//  SetUserProfileDescriptionView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfileDescriptionView: UIView {
    private var title: UILabel
    private var subtitle: UILabel
    private var titleLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 90
        }
        return 120
    }

    var descriptionTextField: UITextField
    var descriptionTextFieldDivider: UIView
    var skipButton: UIButton
    var nextButton: UIButton
    
    override init(frame: CGRect) {
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .Center
        title.setTextWith(UIFont(name: "Montserrat-Regular", size: 18)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: "Let’s set up your profile")

        subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .Center
        subtitle.setTextWith(UIFont(name: "OpenSans", size: 13)!, letterSpacing: 0.5, color: UIColor.oftBlack74Color(), text: "Choose a cover pic for your keyboard! Your friends will see this btw")

        descriptionTextField = UITextField()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Description"
        descriptionTextField.font = UIFont(name: "Montserrat-Regular", size: 11)

        descriptionTextFieldDivider = UIView()
        descriptionTextFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        let buttonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor(hex: "#E3E3E3")
        ]

        skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.backgroundColor = UIColor.whiteColor()
        skipButton.setAttributedTitle( NSAttributedString(string: "skip".uppercaseString, attributes: buttonAttributes), forState: .Normal)
        skipButton.layer.cornerRadius = 25
        skipButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        skipButton.layer.borderWidth = 2
        skipButton.clipsToBounds = true

        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.setAttributedTitle( NSAttributedString(string: "next".uppercaseString, attributes: buttonAttributes), forState: .Normal)
        nextButton.layer.cornerRadius = 25
        nextButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        nextButton.layer.borderWidth = 2
        nextButton.clipsToBounds = true

        super.init(frame: frame)

        addSubview(title)
        addSubview(subtitle)
        addSubview(descriptionTextField)
        addSubview(descriptionTextFieldDivider)
        addSubview(skipButton)
        addSubview(nextButton)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            title.al_top == al_top + titleLabelHeightTopMargin,
            title.al_left == al_left,
            title.al_right == al_right,
            title.al_height == 30,

            subtitle.al_top == title.al_bottom,
            subtitle.al_left == al_left + 40,
            subtitle.al_right == al_right - 40,
            subtitle.al_height == 60,

            descriptionTextField.al_top == subtitle.al_bottom + 40,
            descriptionTextField.al_left == al_left + 40,
            descriptionTextField.al_right == al_right - 40,
            descriptionTextField.al_height == 40,

            descriptionTextFieldDivider.al_top == descriptionTextField.al_bottom,
            descriptionTextFieldDivider.al_left == al_left + 40,
            descriptionTextFieldDivider.al_right == al_right - 40,
            descriptionTextFieldDivider.al_height == 1,

            skipButton.al_left == al_left + 40.5,
            skipButton.al_right == al_centerX - 3.5,
            skipButton.al_height == 52,
            skipButton.al_top == descriptionTextFieldDivider.al_bottom + 36,

            nextButton.al_right == al_right - 40.5,
            nextButton.al_left == al_centerX + 3.5,
            nextButton.al_height == 52,
            nextButton.al_top == descriptionTextFieldDivider.al_bottom + 36,
            ])
    }
}