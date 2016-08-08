//
//  KeyboardInstallAlertView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/5/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardInstallAlertView: AlertView {
    var skipButton: UIButton

    override init(frame: CGRect) {
        skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("skip".uppercaseString, forState: .Normal)
        skipButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        skipButton.setTitleColor(LightGrey, forState: .Normal)

        super.init(frame: frame)

        titleLabel.text = "Almost done! One last thing"
        subtitleLabel.text = "Install the keyboard and come back here to start creating your pack!"
        characterImageView.image = UIImage(named: "keyboardInstall")
        actionButton.setTitle("install".uppercaseString, forState: .Normal)

        addSubview(skipButton)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupLayout() {
        addConstraints([
            characterImageView.al_height == 120,
            characterImageView.al_width == 120,
            characterImageView.al_centerX == al_centerX,
            characterImageView.al_bottom == titleLabel.al_top - 12,

            titleLabel.al_centerY == al_centerY + 20,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,

            actionButton.al_centerX == al_centerX,
            actionButton.al_left == al_left + actionButtonLeftRightMargin,
            actionButton.al_right == al_right - actionButtonLeftRightMargin,
            actionButton.al_height == 40,
            actionButton.al_top == subtitleLabel.al_bottom + 18,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_height == 40,

            skipButton.al_top == al_top + 10,
            skipButton.al_left == al_left + 10,
            skipButton.al_height == 25,
            skipButton.al_width == 49.6,
            ])
    }
    
}