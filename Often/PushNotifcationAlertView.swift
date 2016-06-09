//
//  PushNotifcationAlertView.swift
//  Often
//
//  Created by Kervins Valcourt on 6/3/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class PushNotifcationAlertView: AlertView {
    let declineButton: UIButton

     override init(frame: CGRect) {
        declineButton = UIButton()
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.setTitle("NAH".uppercaseString, forState: .Normal)
        declineButton.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)
        declineButton.setTitleColor(BlackColor , forState: .Normal)
        declineButton.backgroundColor = UIColor.oftWhiteFourColor()
        declineButton.layer.cornerRadius = 20
        declineButton.clipsToBounds = true

        super.init(frame: frame)

        actionButton.setTitle("AIGHT".uppercaseString, forState: .Normal)
        actionButton.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)

        characterImageView.image = UIImage(named: "pushNotificationModal")
        characterImageView.contentMode = .ScaleAspectFill

        titleLabel.text = "Stay Updated!"

        subtitleLabel.text = "Turn on push notifications to see when we add new gifs & quotes!"
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)

        addSubview(declineButton)
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

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 27,
            subtitleLabel.al_right == al_right - 27,
            subtitleLabel.al_height == 40,

            declineButton.al_centerX == al_centerX,
            declineButton.al_left == al_left + 27,
            declineButton.al_right == al_centerX - 3.5,
            declineButton.al_height == 40,
            declineButton.al_top == subtitleLabel.al_bottom + 18,

            actionButton.al_centerX == al_centerX,
            actionButton.al_left == al_centerX + 3.5,
            actionButton.al_right == al_right - 27,
            actionButton.al_height == 40,
            actionButton.al_top == subtitleLabel.al_bottom + 18,
            ])
    }
}
