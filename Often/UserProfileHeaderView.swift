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
    var coverPhotoView: UIImageView
    var coverPhotoTintView: UIView
    var nameLabel: UILabel
    var collapseNameLabel: UILabel
    var collapseProfileImageView: UIImageView
    var shareCountLabel: UILabel
    var offsetValue: CGFloat

    static var preferredSize: CGSize {
        return CGSizeMake(
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height / 2 - 10
        )
    }

    var sharedText: String {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.0),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9)!,
                NSForegroundColorAttributeName: UIColor.oftBlack54Color()
            ]

            shareCountLabel.attributedText = NSMutableAttributedString(string: sharedText.uppercaseString, attributes: attributes)
            shareCountLabel.textAlignment = .Center
        }
    }

    private var userProfilePlaceholder: UIImageView
    private var coverPhotoBottonMarginConstraint: NSLayoutConstraint?

    private var coverPhotoBottonMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return -15
        }
        return -30
    }

    private var nameLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 55
        }
        return 60
    }
    
    private var shareTextTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 0
        }
        return 0
    }
    


    private var profileImageViewWidth: CGFloat {
        if Diagnostics.platformString().number == 6 {
            return 80
        }
        
        return 68
    }


    private var collapseProfileImageViewWidth: CGFloat {
        return 30
    }

    override init(frame: CGRect) {
        collapseProfileImageView = UIImageView()
        collapseProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        collapseProfileImageView.contentMode = .ScaleAspectFit
        collapseProfileImageView.image = UIImage(named: "userprofileplaceholder")
        collapseProfileImageView.layer.borderColor = UserProfileHeaderViewProfileImageViewBackgroundColor
        collapseProfileImageView.layer.borderWidth = 2
        collapseProfileImageView.alpha = 0
        collapseProfileImageView.clipsToBounds = true

        userProfilePlaceholder = UIImageView()
        userProfilePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        userProfilePlaceholder.contentMode = .ScaleAspectFit
        userProfilePlaceholder.image = UIImage(named: "userprofileplaceholder")
        userProfilePlaceholder.layer.borderColor = UserProfileHeaderViewProfileImageViewBackgroundColor
        userProfilePlaceholder.layer.borderWidth = 2
        userProfilePlaceholder.clipsToBounds = true

        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.image = UIImage(named: "userprofileplaceholder")
        profileImageView.layer.borderColor = UserProfileHeaderViewProfileImageViewBackgroundColor
        profileImageView.layer.borderWidth = 2
        profileImageView.clipsToBounds = true

        coverPhotoView = UIImageView()
        coverPhotoView.contentMode = .ScaleAspectFill
        coverPhotoView.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoView.image = UIImage(named: "user-profile-bg-1")
        coverPhotoView.clipsToBounds = true

        coverPhotoTintView = UIView()
        coverPhotoTintView.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoTintView.backgroundColor = UserProfileHeaderViewCoverPhotoTintViewBackgroundColor
        coverPhotoTintView.clipsToBounds = true

        collapseNameLabel = UILabel()
        collapseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collapseNameLabel.font = UIFont(name: "Montserrat", size: 12.0)
        collapseNameLabel.textColor = WhiteColor
        collapseNameLabel.alpha = 0
        collapseNameLabel.textAlignment = .Right

        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat", size: 18.0)
        nameLabel.textAlignment = .Center
        
        shareCountLabel = UILabel()
        shareCountLabel.translatesAutoresizingMaskIntoConstraints = false
        shareCountLabel.font = UIFont(name: "OpenSans", size: 12.5)
        shareCountLabel.textAlignment = .Center
        shareCountLabel.numberOfLines = 3
        shareCountLabel.alpha = 0.54

        offsetValue = 0.0
        sharedText = "85 Lyrics Shared"
        
        super.init(frame: frame)

        profileImageView.layer.cornerRadius = profileImageViewWidth / 2
        userProfilePlaceholder.layer.cornerRadius = profileImageViewWidth / 2
        collapseProfileImageView.layer.cornerRadius = collapseProfileImageViewWidth / 2

        backgroundColor = WhiteColor
        clipsToBounds = true

        addSubview(coverPhotoView)
        addSubview(coverPhotoTintView)
        addSubview(userProfilePlaceholder)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(shareCountLabel)
        addSubview(collapseNameLabel)
        addSubview(collapseProfileImageView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness

            coverPhotoBottonMarginConstraint?.constant = (coverPhotoBottonMargin * progressiveness)

            UIView.beginAnimations("", context: nil)

            if progressiveness <= 0.58 {
                collapseProfileImageView.image = profileImageView.image
                collapseNameLabel.alpha = 1
                collapseProfileImageView.alpha = 1

                nameLabel.alpha = 0
                userProfilePlaceholder.alpha = 0
                profileImageView.alpha = 0
                shareCountLabel.alpha = 0

            } else {
                collapseNameLabel.alpha = 0
                collapseProfileImageView.alpha = 0

                nameLabel.alpha = 1
                userProfilePlaceholder.alpha = 1
                profileImageView.alpha = 1
                shareCountLabel.alpha = 0.8
            }

            UIView.commitAnimations()
        }
    }
    
    func setupLayout() {
        coverPhotoBottonMarginConstraint = coverPhotoView.al_bottom == al_centerY - coverPhotoBottonMargin

        addConstraints([
            collapseProfileImageView.al_top >= al_top + 28,
            collapseProfileImageView.al_left == al_left + 18,
            collapseProfileImageView.al_height == collapseProfileImageViewWidth,
            collapseProfileImageView.al_width == collapseProfileImageViewWidth,

            collapseNameLabel.al_top >= al_top + 28,
            collapseNameLabel.al_left == collapseProfileImageView.al_right,
            collapseNameLabel.al_right == al_right - 18,
            collapseNameLabel.al_height == 30,

            profileImageView.al_bottom == nameLabel.al_top - 9,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_width == profileImageViewWidth,
            profileImageView.al_height == profileImageView.al_width,

            userProfilePlaceholder.al_bottom == profileImageView.al_bottom,
            userProfilePlaceholder.al_centerX == profileImageView.al_centerX,
            userProfilePlaceholder.al_width == profileImageViewWidth,
            userProfilePlaceholder.al_height == profileImageView.al_width,

            coverPhotoView.al_width == al_width,
            coverPhotoBottonMarginConstraint!,
            coverPhotoView.al_left == al_left,
            coverPhotoView.al_top == al_top,
            coverPhotoView.al_height >= 64,

            coverPhotoTintView.al_width == coverPhotoView.al_width,
            coverPhotoTintView.al_bottom == coverPhotoView.al_bottom,
            coverPhotoTintView.al_left == coverPhotoView.al_left,
            coverPhotoTintView.al_top == coverPhotoView.al_top,
            
            nameLabel.al_bottom == al_bottom - nameLabelHeightTopMargin,
            nameLabel.al_centerX == al_centerX,
            nameLabel.al_height == 25,
            
            shareCountLabel.al_top == nameLabel.al_bottom + shareTextTopMargin,
            shareCountLabel.al_centerX == al_centerX,
            shareCountLabel.al_width == 250,
        ])
    }

}