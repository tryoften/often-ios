//
//  UsernameView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UsernameView: UIView {
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let textField: UITextField
    let textFieldDivider: UIView
    let confirmButton: UIButton
    var progressBar: OnboardingProgressBar

    private var titleLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 90
        }
        return 120
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.text = "Great! Let’s get started"
        titleLabel.textAlignment = .Center

        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
        subtitleLabel.text = "Create a username below to share your keyboard with friends!"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.74

        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.font = UIFont(name: "Montserrat-Regular", size: 11)

        textFieldDivider = UIView()
        textFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        textFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        let signinButtonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.grayColor()
        ]

        let signinSelectButtonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        confirmButton = LoginButton.EmailButton()
        confirmButton.setAttributedTitle(NSAttributedString(string: "next".uppercaseString, attributes: signinButtonAttributes), forState: .Normal)
        confirmButton.setAttributedTitle(NSAttributedString(string: "next".uppercaseString, attributes: signinSelectButtonAttributes), forState: .Selected)
        confirmButton.backgroundColor = UIColor.whiteColor()
        confirmButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        confirmButton.layer.borderWidth = 2
        
        progressBar = OnboardingProgressBar(progressIndex: 1.0, endIndex: 8.0, frame: CGRectZero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(textField)
        addSubview(textFieldDivider)
        addSubview(confirmButton)
        addSubview(progressBar)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + titleLabelHeightTopMargin,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 40,
            subtitleLabel.al_right == al_right - 40,
            subtitleLabel.al_height == 60,

            textField.al_top == subtitleLabel.al_bottom + 40,
            textField.al_left == al_left + 40,
            textField.al_right == al_right - 40,
            textField.al_height == 40,

            textFieldDivider.al_top == textField.al_bottom,
            textFieldDivider.al_left == al_left + 40,
            textFieldDivider.al_right == al_right - 40,
            textFieldDivider.al_height == 1,

            confirmButton.al_top == textFieldDivider.al_bottom + 20,
            confirmButton.al_left == al_left + 40,
            confirmButton.al_right == al_right - 40,
            confirmButton.al_height == 50,
            
            progressBar.al_left == al_left,
            progressBar.al_right == al_right,
            progressBar.al_bottom == al_bottom,
            progressBar.al_height == 5
            ])
    }

}