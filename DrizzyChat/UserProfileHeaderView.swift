//
//  UserProfileHeaderView.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView {
    var profileImageView: UIImageView
    var metadataView: UIView
    var nameLabel: UILabel
    var keyboardCountLabel: UILabel

    override init(frame: CGRect) {
        profileImageView = UIImageView()
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        metadataView = UIView()
        metadataView.setTranslatesAutoresizingMaskIntoConstraints(false)
        metadataView.backgroundColor = UIColor.whiteColor()
        
        nameLabel = UILabel()
        nameLabel.textAlignment = .Center
        nameLabel.font = BaseFont
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        keyboardCountLabel = UILabel()
        keyboardCountLabel.textAlignment = .Center
        keyboardCountLabel.font = SubtitleFont
        keyboardCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        addSubview(profileImageView)
        addSubview(metadataView)
        
        metadataView.addSubview(nameLabel)
        metadataView.addSubview(keyboardCountLabel)

        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            profileImageView.al_width == al_width,
            profileImageView.al_height == 200,
            profileImageView.al_left == al_left,
            profileImageView.al_top == al_top,

            metadataView.al_top == profileImageView.al_bottom,
            metadataView.al_width == al_width,
            metadataView.al_height == 100,
            
            nameLabel.al_top == metadataView.al_top + 30,
            nameLabel.al_left == metadataView.al_left,
            nameLabel.al_width == metadataView.al_width,
            nameLabel.al_height == 20,
            
            keyboardCountLabel.al_top == nameLabel.al_bottom + 10,
            keyboardCountLabel.al_centerX == metadataView.al_centerX
        ])
    }
}
