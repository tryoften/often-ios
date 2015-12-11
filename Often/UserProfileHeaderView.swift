//
//  UserProfileHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView {
    var profileImageView: UIImageView
    var nameLabel: UILabel
    var descriptionLabel: UILabel
    var scoreLabel: UILabel
    var scoreNameLabel: UILabel
    var nameLabelHeightConstraint: NSLayoutConstraint?
    var nameLabelHorizontalConstraint: NSLayoutConstraint?
    var descriptionLabelTopConstraint: NSLayoutConstraint?
    var scoreLabelHeightConstraint: NSLayoutConstraint?
    var scoreNameLabelHeightConstraint: NSLayoutConstraint?
    var tabContainerView: FavoritesAndRecentsTabView
    var offsetValue: CGFloat

    static var preferredSize: CGSize {
        return CGSizeMake(
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height / 2 - 10
        )
    }
    
    var nameLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 55
        }
        return 100
    }
    
    var descriptionTextTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 0
        }
        return 10
    }
    
    var tabContainerViewHeight: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 50
        }
        return 60
    }
    
    var profileImageViewWidth: CGFloat {
        if Diagnostics.platformString().number == 6 {
            return 80
        }
        
        return 68
    }
    
    var descriptionText: String {
        didSet {
            let subtitle = NSMutableAttributedString(string: descriptionText)
            let subtitleRange = NSMakeRange(0, descriptionText.characters.count)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
            subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
            descriptionLabel.attributedText = subtitle
            descriptionLabel.textAlignment = .Center
        }
    }
    
    override init(frame: CGRect) {
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 34
        profileImageView.image = UIImage(named: "userprofileplaceholder")
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat", size: 18.0)
        nameLabel.textAlignment = .Center
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.5)
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 3
        descriptionLabel.alpha = 0.54
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont(name: "Montserrat", size: 18.0)
        scoreLabel.textAlignment = .Center
        
        scoreNameLabel = UILabel()
        scoreNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreNameLabel.font = UIFont(name: "OpenSans", size: 12.0)
        scoreNameLabel.textAlignment = .Center
        
        tabContainerView = FavoritesAndRecentsTabView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false

        offsetValue = 0.0
        descriptionText = "Designer. Co-Founder of @DrizzyApp, Previously @Amazon & @Square. Husting & taking notes."
        
        super.init(frame: frame)

        backgroundColor = WhiteColor
        clipsToBounds = true

        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(scoreLabel)
        addSubview(scoreNameLabel)
        addSubview(tabContainerView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            
            nameLabelHeightConstraint?.constant = (-nameLabelHeightTopMargin * progressiveness)
            descriptionLabelTopConstraint?.constant = (descriptionTextTopMargin *  progressiveness)
            descriptionLabel.alpha = progressiveness - 0.2
        }
    }
    
    func setupLayout() {
        nameLabelHeightConstraint = nameLabel.al_bottom == tabContainerView.al_top - nameLabelHeightTopMargin
        descriptionLabelTopConstraint = descriptionLabel.al_top == nameLabel.al_bottom + descriptionTextTopMargin
        scoreNameLabelHeightConstraint = scoreNameLabel.al_bottom == tabContainerView.al_top - descriptionTextTopMargin
        
        addConstraints([
            profileImageView.al_bottom == nameLabel.al_top - 10,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_width == profileImageViewWidth,
            profileImageView.al_height == profileImageView.al_width,
            
            nameLabelHeightConstraint!,
            nameLabel.al_centerX == al_centerX,
            
            descriptionLabelTopConstraint!,
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_width == 250,
            
            scoreLabel.al_bottom == scoreNameLabel.al_top,
            scoreLabel.al_centerX == al_centerX,
            scoreLabel.al_height == 30,
            
            scoreNameLabelHeightConstraint!,
            scoreNameLabel.al_centerX == al_centerX,
            
            tabContainerView.al_bottom == al_bottom,
            tabContainerView.al_left == al_left,
            tabContainerView.al_right == al_right,
            tabContainerView.al_height == tabContainerViewHeight,
        ])
    }

}