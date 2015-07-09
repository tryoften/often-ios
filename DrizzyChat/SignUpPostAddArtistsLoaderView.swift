//
//  SignUpPostAddArtistsLoaderView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpPostAddArtistsLoaderView: UIView {
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var disclaimerLabel: UILabel
    var cardImageView: UIImageView
    
    override init(frame: CGRect) {
        let titleString = "Nice"
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: WalkthroughNavBarTitleFont!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1.5, range: titleRange)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.textColor = WalkthroughTitleFontColor
        titleLabel.font = WalkthroughNavBarTitleFont
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.attributedText = title
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = SubtitleFont
        subtitleLabel.textColor = SubtitleGreyColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.text = "Adding cards to your keyboard now..."
        
        disclaimerLabel = UILabel()
        disclaimerLabel.textAlignment = .Center
        disclaimerLabel.font = SubtitleFont
        disclaimerLabel.textColor = SubtitleGreyColor
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        disclaimerLabel.text = "You can add or change these in your profile later"
        
        cardImageView = UIImageView()
        cardImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        cardImageView.contentMode = .ScaleAspectFit
        cardImageView.image = UIImage(named: "ArtistsCards")
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(cardImageView)
        addSubview(disclaimerLabel)
        
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
            
            subtitleLabel.al_top == titleLabel.al_bottom + 10,
            subtitleLabel.al_left == al_left + 20,
            subtitleLabel.al_right == al_right - 20,
            subtitleLabel.al_centerX == al_centerX,
            
            cardImageView.al_top == subtitleLabel.al_bottom + 20,
            cardImageView.al_left == al_right,
            
            disclaimerLabel.al_left == al_left + 20,
            disclaimerLabel.al_right == al_right - 20,
            disclaimerLabel.al_centerX == al_centerX,
            disclaimerLabel.al_bottom == al_bottom - 10,
        ])
    }
}