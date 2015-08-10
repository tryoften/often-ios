//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    var userInformationContainerView: UIView
    var profileImageView: UIImageView
    var nameLabel: UILabel
    var descriptionLabel: UILabel
    var scoreLabel: UILabel
    var scoreNameLabel: UILabel
    
    var tableViewsContainerView: UIView
    
    init() {
        userInformationContainerView = UIView()
        userInformationContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
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
        
        tableViewsContainerView = UIView()
        tableViewsContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableViewsContainerView.backgroundColor = TealColor
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(userInformationContainerView)
        userInformationContainerView.addSubview(profileImageView)
        userInformationContainerView.addSubview(nameLabel)
        userInformationContainerView.addSubview(descriptionLabel)
        userInformationContainerView.addSubview(scoreLabel)
        userInformationContainerView.addSubview(scoreNameLabel)
        
        
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = WhiteColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout() {
        view.addConstraints([
            userInformationContainerView.al_left == view.al_left,
            userInformationContainerView.al_right == view.al_right,
            userInformationContainerView.al_top == view.al_top,
            userInformationContainerView.al_bottom == view.al_centerY,
            
            profileImageView.al_bottom == nameLabel.al_top - 20,
            profileImageView.al_centerX == userInformationContainerView.al_centerX,
            profileImageView.al_height == 60,
            profileImageView.al_width == 60,
            
            nameLabel.al_bottom == descriptionLabel.al_top - 9,
            nameLabel.al_centerX == userInformationContainerView.al_centerX,
            
            descriptionLabel.al_bottom == scoreLabel.al_top - 10,
            descriptionLabel.al_centerX == userInformationContainerView.al_centerX,
            descriptionLabel.al_width == 200,
            
            scoreLabel.al_bottom == scoreNameLabel.al_top,
            scoreLabel.al_centerX == userInformationContainerView.al_centerX,
            scoreLabel.al_height == 30,
            
            scoreNameLabel.al_bottom == userInformationContainerView.al_bottom - 50,
            scoreNameLabel.al_centerX == userInformationContainerView.al_centerX,
            
            tableViewsContainerView.al_top == view.al_centerY,
            tableViewsContainerView.al_left == view.al_left,
            tableViewsContainerView.al_right == view.al_right,
            tableViewsContainerView.al_bottom == view.al_bottom
        ])
    }
}
