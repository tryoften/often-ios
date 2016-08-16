//
//  PackHeaderProfileButton.swift
//  Often
//
//  Created by Luc Succes on 8/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackHeaderProfileButton: UIButton {
    var handleLabel: UILabel
    var collapseProfileImageView: UIImageView

    private var profileImageViewWidth: CGFloat {
        return 30
    }

    override init(frame: CGRect) {
        handleLabel = UILabel()
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        handleLabel.font = UIFont(name: "OpenSans", size: 10.5)
        handleLabel.textColor = UIColor.whiteColor()
        
        collapseProfileImageView = UIImageView()
        collapseProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        collapseProfileImageView.contentMode = .ScaleAspectFit
        collapseProfileImageView.layer.borderColor = UserProfileHeaderViewProfileImageViewBackgroundColor
        collapseProfileImageView.layer.borderWidth = 2
        collapseProfileImageView.layer.cornerRadius = 15
        collapseProfileImageView.clipsToBounds = true
    
        super.init(frame: frame)

        addSubview(handleLabel)
        addSubview(collapseProfileImageView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            handleLabel.al_centerX == al_centerX,
            handleLabel.al_centerY == al_centerY,
            handleLabel.al_height == 30,
            
            collapseProfileImageView.al_left == handleLabel.al_right + 5,
            collapseProfileImageView.al_centerY == handleLabel.al_centerY,
            collapseProfileImageView.al_width == 30,
            collapseProfileImageView.al_height == 30
        ])
    }
}
