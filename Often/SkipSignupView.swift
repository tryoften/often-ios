//
//  SkipSignupView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SkipSignupView: UIView {
    let characterImageView: UIImageView
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let oftenAccountButton: UIButton

    override init(frame: CGRect) {
        characterImageView = UIImageView()
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.layer.cornerRadius = 40
        characterImageView.clipsToBounds = true
        characterImageView.image = UIImage(named: "createaccountemptystate")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Do you even love me?"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Creating an account lets you save all your\n favorite lyrics to the keyboard"
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12.0)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.alpha = 0.54

        oftenAccountButton = UIButton()
        oftenAccountButton.translatesAutoresizingMaskIntoConstraints = false
        oftenAccountButton.layer.cornerRadius = 5
        oftenAccountButton.setTitle("create an account".uppercaseString, forState: .Normal)
        oftenAccountButton.setTitleColor(WhiteColor, forState: .Normal)
        oftenAccountButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11.0)
        oftenAccountButton.backgroundColor = UIColor(fromHexString: "#152036")

        
        super.init(frame: frame)
        backgroundColor = VeryLightGray
        
        addSubview(characterImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(oftenAccountButton)

        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            characterImageView.al_centerX == al_centerX,
            characterImageView.al_bottom == titleLabel.al_top - 15,

            titleLabel.al_centerY == al_centerY,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_height == 17,
            titleLabel.al_width == 250,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_height == 50,
            subtitleLabel.al_width == 300,
            

            oftenAccountButton.al_top == subtitleLabel.al_bottom + 20,
            oftenAccountButton.al_centerX == al_centerX,
            oftenAccountButton.al_left == al_left + 40,
            oftenAccountButton.al_right == al_right - 40,
            oftenAccountButton.al_height == 50
            ])
    }

}