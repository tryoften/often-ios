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
    var shareCountLabel: UILabel
    var nameLabelHeightConstraint: NSLayoutConstraint?
    var nameLabelHorizontalConstraint: NSLayoutConstraint?
    var shareCountLabelTopConstraint: NSLayoutConstraint?
    var scoreLabelHeightConstraint: NSLayoutConstraint?
    var scoreNameLabelHeightConstraint: NSLayoutConstraint?
    var tabContainerView: FavoritesAndRecentsTabView
    var offsetValue: CGFloat

    static var preferredSize: CGSize {
        return CGSizeMake(
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height / 2 - 10
        )
    }
    
    var nameLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 55
        }
        return 60
    }
    
    var shareTextTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 0
        }
        return 0
    }
    
    var tabContainerViewHeight: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 50
        }
        return 60
    }
    
    var profileImageViewWidth: CGFloat {
        if Diagnostics.platformString().number == 6 {
            return 80
        }
        
        return 68
    }

    var sharedText: String {
        didSet {
            let subtitle = NSMutableAttributedString(string: sharedText)
            let subtitleRange = NSMakeRange(0, sharedText.characters.count)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
            subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
            shareCountLabel.attributedText = subtitle
            shareCountLabel.textAlignment = .Center
        }
    }
    
    override init(frame: CGRect) {
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

        tabContainerView = FavoritesAndRecentsTabView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false

        offsetValue = 0.0
        sharedText = "85 Lyrics Shared"
        
        super.init(frame: frame)

        profileImageView.layer.cornerRadius = profileImageViewWidth / 2

        backgroundColor = WhiteColor
        clipsToBounds = true

        addSubview(coverPhotoView)
        addSubview(coverPhotoTintView)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(shareCountLabel)
        addSubview(tabContainerView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            
            nameLabelHeightConstraint?.constant = (-nameLabelHeightTopMargin * progressiveness)
            shareCountLabelTopConstraint?.constant = (shareTextTopMargin *  progressiveness)
            shareCountLabel.alpha = progressiveness - 0.2
        }
    }
    
    func setupLayout() {
        nameLabelHeightConstraint = nameLabel.al_bottom == tabContainerView.al_top - nameLabelHeightTopMargin
        shareCountLabelTopConstraint = shareCountLabel.al_top == nameLabel.al_bottom + shareTextTopMargin
        
        addConstraints([
            profileImageView.al_bottom == nameLabel.al_top - 9,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_width == profileImageViewWidth,
            profileImageView.al_height == profileImageView.al_width,

            coverPhotoView.al_width == al_width,
            coverPhotoView.al_bottom == profileImageView.al_centerY + 5,
            coverPhotoView.al_left == al_left,
            coverPhotoView.al_top == al_top,

            coverPhotoTintView.al_width == coverPhotoView.al_width,
            coverPhotoTintView.al_bottom == coverPhotoView.al_bottom,
            coverPhotoTintView.al_left == coverPhotoView.al_left,
            coverPhotoTintView.al_top == coverPhotoView.al_top,
            
            nameLabelHeightConstraint!,
            nameLabel.al_centerX == al_centerX,
            nameLabel.al_height == 25,
            
            shareCountLabelTopConstraint!,
            shareCountLabel.al_centerX == al_centerX,
            shareCountLabel.al_width == 250,

            tabContainerView.al_bottom == al_bottom,
            tabContainerView.al_left == al_left,
            tabContainerView.al_right == al_right,
            tabContainerView.al_height == tabContainerViewHeight,
        ])
    }

}