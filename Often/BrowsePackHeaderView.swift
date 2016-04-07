//
//  BrowsePackHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowsePackHeaderView: UICollectionReusableView {
    var browsePicker: BrowsePackHeaderCollectionViewController
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var premiumIcon: UIImageView
    var topBorderView: UIView
    
    override init(frame: CGRect) {
        browsePicker = BrowsePackHeaderCollectionViewController()
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

        premiumIcon = UIImageView(image: StyleKit.imageOfPremium(color: TealColor, frame: CGRectMake(0, 0, 25, 25)))
        premiumIcon.translatesAutoresizingMaskIntoConstraints = false

        topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = LightGrey

        super.init(frame: frame)

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.oftWhiteColor().CGColor, UIColor.oftWhiteThreeColor().CGColor]
        layer.insertSublayer(gradient, atIndex: 0)

        clipsToBounds = true
        
        addSubview(browsePicker.view)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(premiumIcon)
        addSubview(topBorderView)

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
            browsePicker.view.al_top == al_top + 25,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_height == 260,
            
            titleLabel.al_top == browsePicker.view.al_bottom,
            titleLabel.al_centerX == al_centerX,

            premiumIcon.al_centerY == titleLabel.al_centerY,
            premiumIcon.al_left == titleLabel.al_right + 5,

            subtitleLabel.al_top == titleLabel.al_bottom + 5,
            subtitleLabel.al_centerX == al_centerX,

            topBorderView.al_left == al_left,
            topBorderView.al_right == al_right,
            topBorderView.al_top == al_top,
            topBorderView.al_height == 0.5
        ])
    }
}
