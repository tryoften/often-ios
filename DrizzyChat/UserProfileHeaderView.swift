//
//  UserProfileHeaderView.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView {
    var coverPhotoView: UIImageView
    var profileImageView: UIImageView
    var imageOverlayView: UIVisualEffectView
    var metadataView: UIView
    var nameLabel: UILabel
    var keyboardCountLabel: UILabel
    var settingsButton: UIButton

    override init(frame: CGRect) {
        coverPhotoView = UIImageView()
        coverPhotoView.contentMode = .ScaleAspectFill
        coverPhotoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverPhotoView.clipsToBounds = true

        profileImageView = UIImageView()
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 3
        
        let effect = UIBlurEffect(style: .Dark)
        imageOverlayView = UIVisualEffectView(effect: effect)
        imageOverlayView.setTranslatesAutoresizingMaskIntoConstraints(false)

        metadataView = UIView()
        metadataView.setTranslatesAutoresizingMaskIntoConstraints(false)
        metadataView.backgroundColor = UIColor.whiteColor()

        nameLabel = UILabel()
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: "Lato-Regular", size: 14)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

        keyboardCountLabel = UILabel()
        keyboardCountLabel.textAlignment = .Center
        keyboardCountLabel.font = UIFont(name: "Lato-Regular", size: 10)
        keyboardCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

        settingsButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        settingsButton.setImage(UIImage(named: "SettingsIcon"), forState: .Normal)
        settingsButton.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()

        addSubview(coverPhotoView)
        coverPhotoView.addSubview(imageOverlayView)
        addSubview(profileImageView)
        addSubview(metadataView)
        addSubview(settingsButton)

        metadataView.addSubview(nameLabel)
        metadataView.addSubview(keyboardCountLabel)

        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            coverPhotoView.al_width == al_width,
            coverPhotoView.al_height == 180,
            coverPhotoView.al_left == al_left,
            coverPhotoView.al_top == al_top,

            profileImageView.al_width == 150,
            profileImageView.al_height == profileImageView.al_width,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_bottom == al_bottom - 75,

            imageOverlayView.al_height == coverPhotoView.al_height,
            imageOverlayView.al_width == coverPhotoView.al_width,
            imageOverlayView.al_top == coverPhotoView.al_top,
            imageOverlayView.al_left == coverPhotoView.al_left,

            metadataView.al_top == profileImageView.al_bottom,
            metadataView.al_width == al_width,
            metadataView.al_height == 89,

            nameLabel.al_top == metadataView.al_top + 15,
            nameLabel.al_left == metadataView.al_left,
            nameLabel.al_width == metadataView.al_width,
            nameLabel.al_height == 20,

            keyboardCountLabel.al_top == nameLabel.al_bottom + 5,
            keyboardCountLabel.al_centerX == metadataView.al_centerX,

            settingsButton.al_top == al_top + 15,
            settingsButton.al_right == al_right - 15
        ])
    }
}
