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
        titleLabel.setTextWith(UIFont(name: "Montserrat", size: 16.0)!,
                               letterSpacing: 1.0,
                               color: BlackColor,
                               text: "my voice".uppercaseString)

        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.setTextWith(UIFont(name: "OpenSans", size: 12)!,
                                  letterSpacing: 0.5,
                                  color: UIColor.oftDarkGrey74Color(),
                                  lineHeight: 1.1,
                                  text: "Share quotes from Angie Martinez's new book \"My Voice\"")

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
            browsePicker.view.al_top == al_top + 15,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_height == 260,
            
            titleLabel.al_top == browsePicker.view.al_bottom,
            titleLabel.al_centerX == al_centerX,

            premiumIcon.al_centerY == titleLabel.al_centerY,
            premiumIcon.al_left == titleLabel.al_right + 5,

            subtitleLabel.al_top == titleLabel.al_bottom + 5,
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_left == al_left + 52,
            subtitleLabel.al_right == al_right - 52,
            subtitleLabel.al_height == 40,

            topBorderView.al_left == al_left,
            topBorderView.al_right == al_right,
            topBorderView.al_top == al_top,
            topBorderView.al_height == 0.5
        ])
    }
}
