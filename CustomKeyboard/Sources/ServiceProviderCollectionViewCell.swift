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
    var contentImage: UIImage? {
        didSet (value) {
            contentImageViewWidthConstraint = contentImageView.al_width == 100
            addConstraint(contentImageViewWidthConstraint)
            contentImageView.image = value
            layoutIfNeeded()
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
        headerLabel.font = UIFont(name: "OpenSans", size: 11.0)
        
        mainTextLabel = UILabel()
        mainTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainTextLabel.font = UIFont(name: "OpenSans", size: 12.0)
        mainTextLabel.numberOfLines = 2
        mainTextLabel.backgroundColor = ClearColor
        
        centerSupplementLabel = UILabel()
        centerSupplementLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        centerSupplementLabel.font = UIFont(name: "OpenSans", size: 10.0)
        centerSupplementLabel.textColor = UIColor(fromHexString: "#000000")
        
        leftSupplementLabel = UILabel()
        leftSupplementLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftSupplementLabel.font = UIFont(name: "OpenSans", size: 10.0)
        leftSupplementLabel.textColor = UIColor(fromHexString: "#000000")
        
        rightSupplementLabel = UILabel()
        rightSupplementLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightSupplementLabel.font = UIFont(name: "OpenSans", size: 10.0)
        rightSupplementLabel.textColor = UIColor(fromHexString: "#000000")
        
        rightCornerImageView = UIImageView()
        rightCornerImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightCornerImageView.contentMode = .ScaleAspectFit
        
        contentImageView = UIImageView()
        contentImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentImageView.contentMode = .ScaleAspectFit
        
        contentImageViewWidthConstraint = contentImageView.al_width == 0
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
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
        
        layoutIfNeeded()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
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
            contentImageView.al_left == informationContainerView.al_right,
            
            avatarImageView.al_left == informationContainerView.al_left + 15,
            avatarImageView.al_top == informationContainerView.al_top + 10,
            avatarImageView.al_width == 20,
            avatarImageView.al_height == 20,
            
            headerLabel.al_left == avatarImageView.al_right + 5,
            headerLabel.al_centerY == avatarImageView.al_centerY,
            headerLabel.al_height == 16,
            
            mainTextLabel.al_left == informationContainerView.al_left + 15,
            mainTextLabel.al_top == headerLabel.al_bottom + 1,
            mainTextLabel.al_bottom == leftSupplementLabel.al_top,
            mainTextLabel.al_right == contentImageView.al_left - 15,
            
            leftSupplementLabel.al_left == mainTextLabel.al_left,
            leftSupplementLabel.al_bottom == informationContainerView.al_bottom - 8,
            leftSupplementLabel.al_height == 15,
            
            centerSupplementLabel.al_left == leftSupplementLabel.al_right + 15,
            centerSupplementLabel.al_centerY == leftSupplementLabel.al_centerY,
            
            rightSupplementLabel.al_right == mainTextLabel.al_right,
            rightSupplementLabel.al_centerY == leftSupplementLabel.al_centerY,
            
            rightCornerImageView.al_top == informationContainerView.al_top + 10,
            rightCornerImageView.al_right == contentImageView.al_left - 15,
            rightCornerImageView.al_height == 20,
            rightCornerImageView.al_width == 20
        ])
    }
}
