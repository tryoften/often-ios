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
    
    var tabContainerView: UIView
    var favoritesTabButton: UIButton
    var recentsTabButton: UIButton
    var highlightBarView: UIView
    var leftHighlightBarPositionConstraint: NSLayoutConstraint?
    var rightHighlightBarPositionConstraint: NSLayoutConstraint?
    var offsetValue: CGFloat
    
    var setServicesRevealButton: UIButton
    var settingsRevealButton: UIButton

    var delegate: UserProfileHeaderDelegate?
    
    override init(frame: CGRect) {
        profileImageView = UIImageView()
        profileImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.image = UIImage(named: "regy")
        
        nameLabel = UILabel()
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.font = UIFont(name: "Montserrat", size: 18.0)
        nameLabel.text = "Regy Perlera"
        nameLabel.textAlignment = .Center
        
        descriptionLabel = UILabel()
        descriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.text = "Designer. Co-Founder of @DrizzyApp, Previously @Amazon & @Square. Husting & taking notes."
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 3
        
        scoreLabel = UILabel()
        scoreLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        scoreLabel.font = UIFont(name: "Montserrat", size: 18.0)
        scoreLabel.text = "583"
        scoreLabel.textAlignment = .Center
        
        scoreNameLabel = UILabel()
        scoreNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        scoreNameLabel.font = UIFont(name: "OpenSans", size: 12.0)
        scoreNameLabel.text = "Source Cred"
        scoreNameLabel.textAlignment = .Center
        
        tabContainerView = UIView()
        tabContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        favoritesTabButton = UIButton()
        favoritesTabButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        favoritesTabButton.setTitle("FAVORITES", forState: .Normal)
        favoritesTabButton.setTitleColor(BlackColor, forState: .Normal)
        favoritesTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12.0)
        favoritesTabButton.titleLabel?.textAlignment = .Center
        
        recentsTabButton = UIButton()
        recentsTabButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        recentsTabButton.setTitle("RECENTS", forState: .Normal)
        recentsTabButton.setTitleColor(BlackColor, forState: .Normal)
        recentsTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12.0)
        recentsTabButton.titleLabel?.textAlignment = .Center
        
        highlightBarView = UIView()
        highlightBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        highlightBarView.backgroundColor = TealColor
        
        setServicesRevealButton = UIButton()
        setServicesRevealButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        setServicesRevealButton.setImage(UIImage(named: "hamburger"), forState: .Normal)
        
        settingsRevealButton = UIButton()
        settingsRevealButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsRevealButton.setImage(UIImage(named: "settings"), forState: .Normal)
        
        offsetValue = 0.0
        
        leftHighlightBarPositionConstraint = highlightBarView.al_left == tabContainerView.al_left
        rightHighlightBarPositionConstraint = highlightBarView.al_right == tabContainerView.al_centerX
        
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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UserScrollHeaderDelegate
    func userScrollViewDidScroll(offsetX: CGFloat) {
        println("scrolling: \(offsetX)")
        offsetValue = offsetX
    
        leftHighlightBarPositionConstraint?.constant = offsetValue/2
        rightHighlightBarPositionConstraint?.constant = offsetValue/2
        
        layoutIfNeeded()
    }
    
    
    func setupLayout() {
         leftHighlightBarPositionConstraint = highlightBarView.al_left == tabContainerView.al_left
         rightHighlightBarPositionConstraint = highlightBarView.al_right == tabContainerView.al_centerX
        
        addConstraints([
            setServicesRevealButton.al_left == al_left + 20,
            setServicesRevealButton.al_top == al_top + 16,
            setServicesRevealButton.al_height == 16,
            setServicesRevealButton.al_width == 16,
            
            settingsRevealButton.al_top == al_top + 15,
            settingsRevealButton.al_right == al_right - 15,
            settingsRevealButton.al_height == 22,
            settingsRevealButton.al_width == 22,
            
            profileImageView.al_bottom == nameLabel.al_top - 20,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_height == 60,
            profileImageView.al_width == 60,
            
            nameLabel.al_bottom == descriptionLabel.al_top - 9,
            nameLabel.al_centerX == al_centerX,
            
            descriptionLabel.al_bottom == scoreLabel.al_top - 10,
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_width == 200,
            
            scoreLabel.al_bottom == scoreNameLabel.al_top,
            scoreLabel.al_centerX == al_centerX,
            scoreLabel.al_height == 30,
            
            scoreNameLabel.al_bottom == tabContainerView.al_top - 10,
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
            leftHighlightBarPositionConstraint!,
            rightHighlightBarPositionConstraint!
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
