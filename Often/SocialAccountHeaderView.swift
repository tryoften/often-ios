//
//  SocialAccountHeaderView.swift
//  Often
//
//  Created by Kervins Valcourt on 10/5/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SocialAccountHeaderView: UICollectionReusableView {
    var titleView: UILabel
    var subtitleView: UILabel
    var connectImageView: UIImageView
    var learnMoreButton: UIButton
    
    override init(frame: CGRect) {
        titleView = UILabel()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.font = UIFont(name: "Montserrat", size: 11.5)
        titleView.text = "connect".uppercaseString
        titleView.textAlignment = .Center
        
        subtitleView = UILabel()
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.font = UIFont(name: "OpenSans", size: 12.0)
        subtitleView.text = "Connect your profiles to use Venmo, share Spotify favorites, and more! Learn More"
        subtitleView.numberOfLines = 0
        subtitleView.textAlignment = .Center
        subtitleView.alpha = 0.74
        
        
        learnMoreButton = UIButton()
        learnMoreButton.translatesAutoresizingMaskIntoConstraints = false
        learnMoreButton.setTitle("Learn More", forState: .Normal)
        learnMoreButton.titleLabel?.font = UIFont(name: "Montserrat", size: 14.0)
        learnMoreButton.titleLabel?.textAlignment = .Left
        
        connectImageView = UIImageView()
        connectImageView.translatesAutoresizingMaskIntoConstraints = false
        connectImageView.contentMode = .ScaleAspectFit
        connectImageView.image = UIImage(named: "connectImage")
        
        super.init(frame: frame)
    
        addSubview(titleView)
        addSubview(subtitleView)
        addSubview(connectImageView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout() {
        addConstraints([
            connectImageView.al_top == al_top + 50,
            connectImageView.al_left == al_left + 20,
            connectImageView.al_right == al_right - 90,
            connectImageView.al_height == 80,
            
            titleView.al_top == connectImageView.al_bottom + 30,
            titleView.al_left == al_left + 20,
            titleView.al_right == al_right - 90,
            titleView.al_height == 16,
          
            subtitleView.al_top == titleView.al_bottom,
            subtitleView.al_right == al_right - 90,
            subtitleView.al_left == al_left + 20,
            subtitleView.al_height == 50,
            
            ])
    }
    
}


