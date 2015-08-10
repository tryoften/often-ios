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
    
    var tabContainerView: UIView
    var servicesTabLabel: UILabel
    var settingsTabLabel: UILabel
    var highlightBarView: UIView
    
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
        
        servicesTabLabel = UILabel()
        servicesTabLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        servicesTabLabel.font = UIFont(name: "Montserrat", size: 12.0)
        servicesTabLabel.text = "SERVICES"
        servicesTabLabel.textAlignment = .Center
        
        settingsTabLabel = UILabel()
        settingsTabLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsTabLabel.font = UIFont(name: "Montserrat", size: 12.0)
        settingsTabLabel.text = "SETTINGS"
        settingsTabLabel.textAlignment = .Center
        
        highlightBarView = UIView()
        highlightBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        highlightBarView.backgroundColor = TealColor
        
        super.init(frame: frame)
    
        backgroundColor = WhiteColor
        clipsToBounds = true
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(scoreLabel)
        addSubview(scoreNameLabel)
        
        addSubview(tabContainerView)
        tabContainerView.addSubview(servicesTabLabel)
        tabContainerView.addSubview(settingsTabLabel)
        tabContainerView.addSubview(highlightBarView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
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
            
            servicesTabLabel.al_left == tabContainerView.al_left,
            servicesTabLabel.al_bottom == tabContainerView.al_bottom,
            servicesTabLabel.al_top == tabContainerView.al_top,
            servicesTabLabel.al_right == tabContainerView.al_centerX,
            
            settingsTabLabel.al_bottom == tabContainerView.al_bottom,
            settingsTabLabel.al_top == tabContainerView.al_top,
            settingsTabLabel.al_right == tabContainerView.al_right,
            settingsTabLabel.al_left == tabContainerView.al_centerX,
            
            highlightBarView.al_left == tabContainerView.al_left,
            highlightBarView.al_right == tabContainerView.al_centerX,
            highlightBarView.al_bottom == tabContainerView.al_bottom,
            highlightBarView.al_height == 4,
        ])
    }
}
