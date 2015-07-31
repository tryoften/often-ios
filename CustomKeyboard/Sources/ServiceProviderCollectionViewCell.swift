//
//  ServiceProviderCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class ServiceProviderCollectionViewCell: UICollectionViewCell {
    var informationContainerView: UIView
    var avatarImageView: UIImageView
    var headerLabel: UILabel
    var mainTextLabel: UILabel
    var leftSupplementLabel: UILabel
    var centerSupplementLabel: UILabel
    var rightSupplementLabel: UILabel
    var rightCornerImageView: UIImageView
    
    var contentImageView: UIImageView
    var contentImageViewWidthConstraint: NSLayoutConstraint
    var contentImage: UIImage {
        didSet (value) {
            contentImageView.image = value
            contentImageViewWidthConstraint = contentImageView.al_width == 100
        }
    }
    
    override init(frame: CGRect) {
        informationContainerView = UIView()
        informationContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        avatarImageView = UIImageView()
        avatarImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        avatarImageView.contentMode = .ScaleAspectFit
        
        headerLabel = UILabel()
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.font = UIFont(name: "OpenSans", size: 12.0)
        
        mainTextLabel = UILabel()
        mainTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainTextLabel.font = UIFont(name: "OpenSans", size: 12.0)
        
        centerSupplementLabel = UILabel()
        centerSupplementLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        centerSupplementLabel.font = UIFont(name: "OpenSans", size: 12.0)
        centerSupplementLabel.textColor = LightGrey
        
        leftSupplementLabel = UILabel()
        leftSupplementLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftSupplementLabel.font = UIFont(name: "OpenSans", size: 12.0)
        leftSupplementLabel.textColor = LightGrey
        
        rightSupplementLabel = UILabel()
        rightSupplementLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightSupplementLabel.font = UIFont(name: "OpenSans", size: 12.0)
        rightSupplementLabel.textColor = LightGrey
        
        rightCornerImageView = UIImageView()
        rightCornerImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightCornerImageView.contentMode = .ScaleAspectFit
        
        contentImage = UIImage()
        
        contentImageView = UIImageView()
        contentImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentImageView.contentMode = .ScaleAspectFit
        
        contentImageViewWidthConstraint = contentImageView.al_width == 0
        
        super.init(frame: frame)
        
        addSubview(informationContainerView)
        addSubview(contentImageView)
        informationContainerView.addSubview(avatarImageView)
        informationContainerView.addSubview(headerLabel)
        informationContainerView.addSubview(mainTextLabel)
        informationContainerView.addSubview(leftSupplementLabel)
        informationContainerView.addSubview(centerSupplementLabel)
        informationContainerView.addSubview(rightSupplementLabel)
        informationContainerView.addSubview(rightCornerImageView)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            informationContainerView.al_left == al_left,
            informationContainerView.al_top == al_top,
            informationContainerView.al_bottom == al_bottom,
            informationContainerView.al_right == contentImageView.al_left,
            
            contentImageView.al_right == al_right,
            contentImageView.al_top == al_top,
            contentImageView.al_bottom == al_bottom,
            
            avatarImageView.al_left == informationContainerView.al_left + 5,
            avatarImageView.al_top == informationContainerView.al_top + 5,
            avatarImageView.al_width == 10,
            avatarImageView.al_height == 10,
            
            headerLabel.al_left == avatarImageView.al_right + 2,
            headerLabel.al_top == informationContainerView.al_top + 5,
            
            mainTextLabel.al_left == informationContainerView.al_left + 5,
            mainTextLabel.al_top == headerLabel.al_bottom + 5,
            
            leftSupplementLabel.al_bottom == informationContainerView.al_bottom + 5,
            leftSupplementLabel.al_left == informationContainerView.al_left + 5,
            
            centerSupplementLabel.al_left == leftSupplementLabel.al_right + 5,
            centerSupplementLabel.al_bottom == informationContainerView.al_bottom + 5,
            
            rightSupplementLabel.al_left == informationContainerView.al_right - 5,
            rightSupplementLabel.al_bottom == informationContainerView.al_bottom + 5,
            
            rightCornerImageView.al_top == informationContainerView.al_top + 5,
            rightCornerImageView.al_right == contentImageView.al_left - 5
        ])
    }
}
