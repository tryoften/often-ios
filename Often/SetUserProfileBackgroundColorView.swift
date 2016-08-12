//
//  SetUserProfileBackgroundColorView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
class SetUserProfileBackgroundColorView: UIView, ColorPickerDelegate {
    private var title: UILabel
    private var subtitle: UILabel

    var skipButton: UIButton
    var nextButton: UIButton
    var currentColorView: UIView
    var colorPicker: ColorPickerView

    override init(frame: CGRect) {
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .Center
        title.setTextWith(UIFont(name: "Montserrat-Regular", size: 18)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: "Pick a color!")

        subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .Center
        subtitle.setTextWith(UIFont(name: "OpenSans", size: 13)!, letterSpacing: 0.5, color: UIColor.oftBlack74Color(), text: "Express your inner Kanye and pick a background color for your profile")

        skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("Skip", forState: .Normal)
        skipButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15.0)
        skipButton.setTitleColor(UIColor.oftBlack54Color(), forState: .Normal)

        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", forState: .Normal)
        nextButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15.0)
        nextButton.setTitleColor(UIColor.oftBlack90Color(), forState: .Normal)

        currentColorView = UIView()
        currentColorView.translatesAutoresizingMaskIntoConstraints = false
        currentColorView.layer.cornerRadius = 75/2
        currentColorView.backgroundColor = LightGrey

        colorPicker = ColorPickerView()
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.layer.cornerRadius = 2

        super.init(frame: frame)

        colorPicker.delegate = self

        addSubview(title)
        addSubview(subtitle)
        addSubview(skipButton)
        addSubview(nextButton)
        addSubview(currentColorView)
        addSubview(colorPicker)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func colorPickerViewDidSetColor(picker: ColorPickerView, color: UIColor) {
        currentColorView.backgroundColor = color
    }

    func setupLayout() {
        addConstraints([
            title.al_top == al_top + 109,
            title.al_left == al_left + 72,
            title.al_right == al_right - 72,
            title.al_height == 20,

            subtitle.al_top == title.al_bottom + 17.5,
            subtitle.al_left == al_left + 60,
            subtitle.al_right == al_right - 60,
            subtitle.al_height == 42,

            skipButton.al_top == al_top + 32,
            skipButton.al_left == al_left + 19,
            skipButton.al_height == 25,
            skipButton.al_width == 49.6,

            nextButton.al_top == al_top + 32,
            nextButton.al_right == al_right - 19,
            nextButton.al_height == 25,
            nextButton.al_width == 49.6,

            currentColorView.al_centerX == al_centerX,
            currentColorView.al_top == subtitle.al_bottom + 58,
            currentColorView.al_height == 75,
            currentColorView.al_width == 75,

            colorPicker.al_top == currentColorView.al_bottom + 35,
            colorPicker.al_left == al_left + 18,
            colorPicker.al_right == al_right - 18,
            colorPicker.al_height == 24
            ])
    }
}