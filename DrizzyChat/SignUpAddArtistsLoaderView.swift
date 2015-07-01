//
//  SignUpAddArtistsLoaderView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpAddArtistsLoaderView: UIView {
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var cardImageView: UIImageView
    
    override init(frame: CGRect) {
        let titleString = "Hey, Komreezy"
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans-Semibold", size: 18)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1.5, range: titleRange)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 18)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.attributedText = title
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = SubtitleFont
        subtitleLabel.textColor = SubtitleGreyColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "Let's start by adding a few artists you like"
        
        cardImageView = UIImageView()
        cardImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        cardImageView.contentMode = .ScaleAspectFit
        cardImageView.image = UIImage(named: "outlinecards")
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(cardImageView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 170,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_centerX == al_centerX,
            
            cardImageView.al_top == subtitleLabel.al_bottom + 20,
            cardImageView.al_left == al_right,
        ])
    }
}