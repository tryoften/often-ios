//
//  SoundcloudCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/30/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SoundcloudCollectionViewCell: UICollectionViewCell {
    var usernameLabel: UILabel
    var trackLabel: UILabel
    var playsLabel: UILabel
    var dateLabel: UILabel
    var trackImageView: UIImageView
    
    override init(frame: CGRect) {
        usernameLabel = UILabel()
        usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        usernameLabel.font = UIFont(name: "OpenSans", size: 12.0)
        
        trackLabel = UILabel()
        trackLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        trackLabel.font = UIFont(name: "OpenSans", size: 12.0)
        
        playsLabel = UILabel()
        playsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        playsLabel.font = UIFont(name: "OpenSans", size: 12.0)
        playsLabel.textColor = LightGrey
        
        dateLabel = UILabel()
        dateLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        dateLabel.font = UIFont(name: "OpenSans", size: 12.0)
        dateLabel.textColor = LightGrey
        
        trackImageView = UIImageView()
        trackImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        trackImageView.contentMode = .ScaleAspectFit
        
        super.init(frame: frame)
        
        addSubview(usernameLabel)
        addSubview(trackLabel)
        addSubview(playsLabel)
        addSubview(dateLabel)
        addSubview(trackImageView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            usernameLabel.al_left == al_left + 5,
            usernameLabel.al_top == al_top + 5,
            
            trackLabel.al_left == al_left + 5,
            trackLabel.al_top == usernameLabel.al_bottom + 5,
            
            playsLabel.al_bottom == al_bottom + 5,
            playsLabel.al_left == al_left + 5,
            
            dateLabel.al_left == playsLabel.al_right + 5,
            dateLabel.al_bottom == al_bottom + 5,
            
            trackImageView.al_right == al_right,
            trackImageView.al_top == al_top,
            trackImageView.al_bottom == al_bottom,
            trackImageView.al_width == 100
        ])
    }
}
