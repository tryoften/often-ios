//
//  UserProfileHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView, UserScrollHeaderDelegate {
    var profileImageView: UIImageView
    var nameLabel: UILabel
    var descriptionLabel: UILabel
    var scoreLabel: UILabel
    var scoreNameLabel: UILabel
    var nameLabelHeightConstraint: NSLayoutConstraint?
    var nameLabelHorizontalConstraint: NSLayoutConstraint?
    var descriptionLabelHeightConstraint: NSLayoutConstraint?
    var scoreLabelHeightConstraint: NSLayoutConstraint?
    var scoreNameLabelHeightConstraint: NSLayoutConstraint?
    
    var tabContainerView: UIView
    var favoritesTabButton: UIButton
    var recentsTabButton: UIButton
    var highlightBarView: UIView
    var leftHighlightBarPositionConstraint: NSLayoutConstraint?
    var offsetValue: CGFloat
    
    var setServicesRevealButton: UIButton
    var settingsRevealButton: UIButton

    var delegate: UserProfileHeaderDelegate?
    
    override init(frame: CGRect) {
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.image = UIImage(named: "userprofileplaceholder")
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat", size: 18.0)
        nameLabel.text = "Regy Perlera"
        nameLabel.textAlignment = .Center
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.5)
        descriptionLabel.text = "Designer. Co-Founder of @DrizzyApp, Previously @Amazon & @Square. Husting & taking notes."
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
        
        tabContainerView = UIView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        favoritesTabButton = UIButton()
        favoritesTabButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesTabButton.setTitle("FAVORITES", forState: .Normal)
        favoritesTabButton.setTitleColor(BlackColor, forState: .Normal)
        favoritesTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        favoritesTabButton.titleLabel?.textAlignment = .Center
        
        recentsTabButton = UIButton()
        recentsTabButton.translatesAutoresizingMaskIntoConstraints = false
        recentsTabButton.setTitle("RECENTS", forState: .Normal)
        recentsTabButton.setTitleColor(BlackColor, forState: .Normal)
        recentsTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        recentsTabButton.titleLabel?.textAlignment = .Center
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = TealColor
        
        setServicesRevealButton = UIButton()
        setServicesRevealButton.translatesAutoresizingMaskIntoConstraints = false
        setServicesRevealButton.setImage(UIImage(named: "hamburger"), forState: .Normal)
        setServicesRevealButton.contentEdgeInsets = UIEdgeInsets(top: 21, left: 20, bottom: 20, right: 20)
        
        settingsRevealButton = UIButton()
        settingsRevealButton.translatesAutoresizingMaskIntoConstraints = false
        settingsRevealButton.setImage(UIImage(named: "settings"), forState: .Normal)
        settingsRevealButton.contentEdgeInsets = UIEdgeInsets(top: 17, left: 20, bottom: 20, right: 15)
        
        
        offsetValue = 0.0
        
        super.init(frame: frame)
    
        backgroundColor = WhiteColor
        clipsToBounds = true
        
        setServicesRevealButton.addTarget(self, action: "setServicesRevealTapped", forControlEvents: .TouchUpInside)
        settingsRevealButton.addTarget(self, action: "settingsRevealTapped", forControlEvents: .TouchUpInside)
        favoritesTabButton.addTarget(self, action: "favoritesTabTapped", forControlEvents: .TouchUpInside)
        recentsTabButton.addTarget(self, action: "recentsTabTapped", forControlEvents: .TouchUpInside)
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(scoreLabel)
        addSubview(scoreNameLabel)
        addSubview(setServicesRevealButton)
        addSubview(settingsRevealButton)
        
        addSubview(tabContainerView)
        tabContainerView.addSubview(favoritesTabButton)
        tabContainerView.addSubview(recentsTabButton)
        tabContainerView.addSubview(highlightBarView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UserScrollHeaderDelegate
    
    func userDidSelectTab(type: String) {
        if type == "favorites" {
            leftHighlightBarPositionConstraint?.constant = 0.0
        } else {
            leftHighlightBarPositionConstraint?.constant = UIScreen.mainScreen().bounds.width / 2
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            
            if progressiveness > 0 && progressiveness <= 1 {
                nameLabelHeightConstraint?.constant = (-140 * progressiveness)
                descriptionLabelHeightConstraint?.constant = (-15 * (1 - progressiveness))
                scoreNameLabelHeightConstraint?.constant = (-120 * (1 - progressiveness)) - 30
                scoreNameLabel.alpha = progressiveness - 0.2
                scoreLabel.alpha = progressiveness - 0.2
                descriptionLabel.alpha = progressiveness - 0.2
            }
        }
    }
    
    func setupLayout() {
            leftHighlightBarPositionConstraint = highlightBarView.al_left == tabContainerView.al_left
            nameLabelHeightConstraint = nameLabel.al_bottom == tabContainerView.al_top - 140
            descriptionLabelHeightConstraint = descriptionLabel.al_bottom == scoreLabel.al_top
            scoreNameLabelHeightConstraint = scoreNameLabel.al_bottom == tabContainerView.al_top - 30
        
        addConstraints([
            setServicesRevealButton.al_left == al_left,
            setServicesRevealButton.al_top == al_top,
            setServicesRevealButton.al_height == 55,
            setServicesRevealButton.al_width == 59,
            
            settingsRevealButton.al_top == al_top,
            settingsRevealButton.al_right == al_right,
            settingsRevealButton.al_height == 59,
            settingsRevealButton.al_width == 57,
            
            profileImageView.al_bottom == nameLabel.al_top - 10,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_height == 68,
            profileImageView.al_width == 68,
            
            nameLabelHeightConstraint!,
            nameLabel.al_centerX == al_centerX,
            
            descriptionLabelHeightConstraint!,
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
            tabContainerView.al_height == 60,
            
            favoritesTabButton.al_left == tabContainerView.al_left,
            favoritesTabButton.al_bottom == tabContainerView.al_bottom,
            favoritesTabButton.al_top == tabContainerView.al_top,
            favoritesTabButton.al_right == tabContainerView.al_centerX,
            
            recentsTabButton.al_bottom == tabContainerView.al_bottom,
            recentsTabButton.al_top == tabContainerView.al_top,
            recentsTabButton.al_right == tabContainerView.al_right,
            recentsTabButton.al_left == tabContainerView.al_centerX,
            
            highlightBarView.al_bottom == tabContainerView.al_bottom,
            highlightBarView.al_height == 4,
            highlightBarView.al_width == tabContainerView.al_width / 2,
            leftHighlightBarPositionConstraint!
        ])
    }
    
    // User Profile Header Delegate
    func setServicesRevealTapped() {
        if let delegate = delegate {
            delegate.revealSetServicesViewDidTap()
        }
    }
    
    func settingsRevealTapped() {
        if let delegate = delegate {
            delegate.revealSettingsViewDidTap()
        }
    }
    
    func favoritesTabTapped() {
        if let delegate = delegate {
            delegate.userFavoritesTabSelected()
        }
    }
    
    func recentsTabTapped() {
        if let delegate = delegate {
            delegate.userRecentsTabSelected()
        }
    }
}

protocol UserProfileHeaderDelegate {
    func revealSetServicesViewDidTap()
    func revealSettingsViewDidTap()
    func userFavoritesTabSelected()
    func userRecentsTabSelected()
}
