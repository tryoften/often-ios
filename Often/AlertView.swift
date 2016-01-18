//
//  AlertView.swift
//  Often
//
//  Created by Kervins Valcourt on 10/13/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Spring

class AlertView: SpringView {
    let characterImageView: UIImageView
    let titleLabel: UILabel
    var subtitleLabel: UILabel
    let actionButton: UIButton

    var subtitleLabelLeftRightMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 80
        }
        return 60
    }

    var actionButtonLeftRightMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 100
        }
        return 70
    }

    override init(frame: CGRect) {
        characterImageView = UIImageView()
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.contentMode = .ScaleAspectFill
        characterImageView.image = UIImage(named: "majorkeycharacter")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.textColor = WalkthroughTitleFontColor
        titleLabel.alpha = 0.90
        titleLabel.text = "Major Key Alert"

        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.alpha = 0.74
        subtitleLabel.textColor = WalkthroughSubTitleFontColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Any lyrics you favorite here get added to your keyboard"

        actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("got it".uppercaseString, forState: .Normal)
        actionButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        actionButton.setTitleColor(WhiteColor , forState: .Normal)
        actionButton.backgroundColor = TealColor
        actionButton.layer.cornerRadius = 20
        actionButton.clipsToBounds = true

        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        layer.cornerRadius = 4
        
        animation = "slideUp"
        curve = "easeOut"
        duration = 0.7
        force = 2.0
        
        addSubview(characterImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionButton)

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

            titleLabel.al_centerY == al_centerY + 20,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 30,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + subtitleLabelLeftRightMargin,
            subtitleLabel.al_right == al_right - subtitleLabelLeftRightMargin,
            subtitleLabel.al_height == 32,

            actionButton.al_centerX == al_centerX,
            actionButton.al_left == al_left + actionButtonLeftRightMargin,
            actionButton.al_right == al_right - actionButtonLeftRightMargin,
            actionButton.al_height == 40,
            actionButton.al_top == subtitleLabel.al_bottom + 18

            ])
    }
}
