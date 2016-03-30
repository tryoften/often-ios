//
//  PackBrowseHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackBrowseHeaderView: UICollectionReusableView {
    var browsePicker: PackBrowseHeaderCollectionViewController
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var actionButton: UIButton // Download or Buy
    var underlineButton: UIButton
    var sectionHeaderView: PackBrowseSectionHeaderView
    var premiumIcon: UIImageView
    
    override init(frame: CGRect) {
        browsePicker = PackBrowseHeaderCollectionViewController()
        browsePicker.view.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 16.0)
        titleLabel.textColor = BlackColor
        titleLabel.textAlignment = .Center
        titleLabel.text = "my voice".uppercaseString
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 10.5)
        subtitleLabel.textColor = BlackColor
        subtitleLabel.textAlignment = .Center
        subtitleLabel.text = "Share quotes from Angie Martinez's new book \"My Voice\""
        
        actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = BlackColor
        actionButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        actionButton.layer.cornerRadius = 15
        actionButton.setTitle("BUY $0.99", forState: .Normal)
        actionButton.setTitleColor(WhiteColor, forState: .Normal)
        
        sectionHeaderView = PackBrowseSectionHeaderView()
        sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderView.leftLabel.text = "featured packs".uppercaseString

        premiumIcon = UIImageView(image: StyleKit.imageOfPremium(color: TealColor, frame: CGRectMake(0, 0, 25, 25)))
        premiumIcon.translatesAutoresizingMaskIntoConstraints = false
        
        underlineButton = UIButton()
        
        if let font = UIFont(name: "OpenSans-Semibold", size: 9.0) {
            let attributes = [
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : BlackColor,
                NSUnderlineStyleAttributeName : 1,
                NSKernAttributeName: 1
            ]
            let buttonTitle = NSMutableAttributedString(string: "")
            let buttonTitleString = NSMutableAttributedString(string: "try sample".uppercaseString, attributes: attributes)
            
            underlineButton.translatesAutoresizingMaskIntoConstraints = false
            buttonTitle.appendAttributedString(buttonTitleString)
            underlineButton.setAttributedTitle(buttonTitle, forState: .Normal)
        }
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.oftWhiteThreeColor()
        clipsToBounds = true
        
        addSubview(browsePicker.view)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(premiumIcon)
        addSubview(sectionHeaderView)

        setupLayout()
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness

            UIView.animateWithDuration(0.3) {
                if progressiveness <= 0.8 {
                    let val = progressiveness - 0.3
                    self.browsePicker.view.alpha = val
                } else {
                    self.browsePicker.view.alpha = 1.0
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            browsePicker.view.al_top == sectionHeaderView.al_bottom,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_height == 260,
            
            titleLabel.al_top == browsePicker.view.al_bottom,
            titleLabel.al_centerX == al_centerX,

            premiumIcon.al_centerY == titleLabel.al_centerY,
            premiumIcon.al_left == titleLabel.al_right + 5,

            subtitleLabel.al_top == titleLabel.al_bottom + 5,
            subtitleLabel.al_centerX == al_centerX,

            sectionHeaderView.al_top == al_top,
            sectionHeaderView.al_right == al_right,
            sectionHeaderView.al_left == al_left,
            sectionHeaderView.al_height == 35,
        ])
    }
}
