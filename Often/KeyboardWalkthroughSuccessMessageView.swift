//
//  KeyboardWalkthroughSuccessMessageView.swift
//  Often
//
//  Created by Kervins Valcourt on 1/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardWalkthroughSuccessMessageView: UIView {
    let characterImageView: UIImageView
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let finishedButton: UIButton

    private var subtitleLabelLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 40
        }
        return 80
    }

    override init(frame: CGRect) {
        characterImageView = UIImageView()
        characterImageView.contentMode = .ScaleAspectFill
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.image = UIImage(named: "completestatecharacter")

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.textColor = WalkthroughTitleFontColor
        titleLabel.alpha = 0.90
        titleLabel.text = "Congrats!"

        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
        subtitleLabel.textColor = WalkthroughSubTitleFontColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.alpha = 0.74
        subtitleLabel.text = "You’ve successfully installed Often. Tap “Finish” to start adding packs."

        finishedButton = UIButton()
        finishedButton.translatesAutoresizingMaskIntoConstraints = false
        finishedButton.setTitle("finish".uppercaseString, forState: .Normal)
        finishedButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        finishedButton.setTitleColor(WhiteColor , forState: .Normal)
        finishedButton.backgroundColor = TealColor
        finishedButton.layer.cornerRadius = 20
        finishedButton.clipsToBounds = true

        super.init(frame: frame)
        backgroundColor = WhiteColor

        addSubview(characterImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(finishedButton)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            characterImageView.al_height == 120,
            characterImageView.al_width == 120,
            characterImageView.al_centerX == al_centerX,
            characterImageView.al_bottom == titleLabel.al_top - 12,

            titleLabel.al_centerY == al_centerY,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 36,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + subtitleLabelLeftAndRightMargin,
            subtitleLabel.al_right == al_right - subtitleLabelLeftAndRightMargin,
            subtitleLabel.al_height == 40,

            finishedButton.al_centerX == al_centerX,
            finishedButton.al_left == al_left + 100,
            finishedButton.al_right == al_right - 100,
            finishedButton.al_height == 40,
            finishedButton.al_top == subtitleLabel.al_bottom + 20

            ])
    }
}