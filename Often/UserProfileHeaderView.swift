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
    var nameLabel: UILabel
    var leftHeaderLabel: UILabel
    var leftBoldLabel: UILabel
    var rightBoldLabel: UILabel
    var leftDescriptorLabel: UILabel
    var rightDescriptorLabel: UILabel
    var collapseNameLabel: UILabel
    var collapseProfileImageView: UIImageView
    var rightHeaderLabel: UILabel
    var rightHeaderButton: UIButton
    var leftHeaderLabelConstraint: NSLayoutConstraint?
    var offsetValue: CGFloat

    var isCurrentUser: Bool {
        didSet {
            leftHeaderLabel.hidden = !isCurrentUser
        }
    }

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

            rightHeaderLabel.attributedText = NSMutableAttributedString(string: sharedText.uppercaseString, attributes: attributes)
            rightHeaderLabel.textAlignment = .Center
        }
    }

    private var userProfilePlaceholder: UIImageView
    private var coverPhotoBottonMarginConstraint: NSLayoutConstraint?

    private var coverPhotoBottonMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            return 0
        }
        return -12
    }

    private var nameLabelHeightTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
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
        profileImageView.clipsToBounds = true

        collapseNameLabel = UILabel()
        collapseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collapseNameLabel.font = UIFont(name: "Montserrat", size: 12.0)
        collapseNameLabel.textColor = UIColor.oftBlack74Color()
        collapseNameLabel.textAlignment = .Right

        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat", size: 27.0)
        nameLabel.textAlignment = .Left
        nameLabel.numberOfLines = 2
        
        rightHeaderLabel = UILabel()
        rightHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderLabel.textAlignment = .Center
        rightHeaderLabel.backgroundColor = ClearColor

        leftHeaderLabel = UILabel()
        leftHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHeaderLabel.font = UIFont(name: "Montserrat", size: 12.0)
        leftHeaderLabel.textColor = UIColor.lightGrayColor()
        
        leftBoldLabel = UILabel()
        leftBoldLabel.translatesAutoresizingMaskIntoConstraints = false
        leftBoldLabel.font = UIFont(name: "Montserrat", size: 18.0)
        leftBoldLabel.textColor = UIColor.oftBlack74Color()
        leftBoldLabel.textAlignment = .Center
        leftBoldLabel.text = "0"
        
        rightBoldLabel = UILabel()
        rightBoldLabel.translatesAutoresizingMaskIntoConstraints = false
        rightBoldLabel.font = UIFont(name: "Montserrat", size: 18.0)
        rightBoldLabel.textColor = UIColor.oftBlack74Color()
        rightBoldLabel.textAlignment = .Center
        rightBoldLabel.text = "0"
        
        leftDescriptorLabel = UILabel()
        leftDescriptorLabel.translatesAutoresizingMaskIntoConstraints = false
        leftDescriptorLabel.setTextWith(UIFont(name: "OpenSans", size: 10.5),
                                        letterSpacing: 0.5,
                                        color: UIColor.lightGrayColor(),
                                        text: "Followers".uppercaseString)

        rightDescriptorLabel = UILabel()
        rightDescriptorLabel.translatesAutoresizingMaskIntoConstraints = false
        rightDescriptorLabel.setTextWith(UIFont(name: "OpenSans", size: 10.5),
                                         letterSpacing: 0.5,
                                         color: UIColor.lightGrayColor(),
                                         text: "Following".uppercaseString)
        
        rightHeaderButton = UIButton()
        rightHeaderButton.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderButton.setImage(StyleKit.imageOfSettingsDiamond(color: UIColor.lightGrayColor()), forState: .Normal)
        rightHeaderButton.imageEdgeInsets = UIEdgeInsetsMake(13.0, 13.0, 13.0, 13.0)
        rightHeaderButton.hidden = true

        isCurrentUser = true
        offsetValue = 0.0
        sharedText = ""
        
        super.init(frame: frame)
        
        profileImageView.layer.cornerRadius = profileImageViewWidth / 2
        userProfilePlaceholder.layer.cornerRadius = profileImageViewWidth / 2
        collapseProfileImageView.layer.cornerRadius = collapseProfileImageViewWidth / 2
        
        backgroundColor = WhiteColor
        clipsToBounds = true

        addSubview(userProfilePlaceholder)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(leftHeaderLabel)
        addSubview(leftBoldLabel)
        addSubview(rightBoldLabel)
        addSubview(leftDescriptorLabel)
        addSubview(rightDescriptorLabel)
        addSubview(rightHeaderLabel)
        addSubview(rightHeaderButton)
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
                leftHeaderLabel.alpha = 1
                
                nameLabel.alpha = 0
                userProfilePlaceholder.alpha = 0
                leftBoldLabel.alpha = 0
                leftDescriptorLabel.alpha = 0
                rightBoldLabel.alpha = 0
                rightDescriptorLabel.alpha = 0
                profileImageView.alpha = 0
                rightHeaderLabel.alpha = 0

            } else {
                collapseProfileImageView.alpha = 0
                leftHeaderLabel.alpha = 0

                nameLabel.alpha = 1
                userProfilePlaceholder.alpha = 1
                leftBoldLabel.alpha = 1
                leftDescriptorLabel.alpha = 1
                rightBoldLabel.alpha = 1
                rightDescriptorLabel.alpha = 1
                profileImageView.alpha = 1
                rightHeaderLabel.alpha = 0.8
            }

            UIView.commitAnimations()
        }
    }
    
    func setupLayout() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        leftHeaderLabelConstraint = leftHeaderLabel.al_top == al_top + 34.5
        
        addConstraints([
            collapseProfileImageView.al_top >= al_top + 28,
            collapseProfileImageView.al_left == al_left + 18,
            collapseProfileImageView.al_height == collapseProfileImageViewWidth,
            collapseProfileImageView.al_width == collapseProfileImageViewWidth,

            collapseNameLabel.al_top >= al_top + 28,
            collapseNameLabel.al_centerX == al_centerX,
            collapseNameLabel.al_centerY == leftHeaderLabel.al_centerY,

            profileImageView.al_centerY == nameLabel.al_centerY,
            profileImageView.al_right == al_right - (screenWidth * 0.06),
            profileImageView.al_width == profileImageViewWidth,
            profileImageView.al_height == profileImageView.al_width,

            userProfilePlaceholder.al_bottom == profileImageView.al_bottom,
            userProfilePlaceholder.al_centerX == profileImageView.al_centerX,
            userProfilePlaceholder.al_width == profileImageViewWidth,
            userProfilePlaceholder.al_height == profileImageView.al_width,
            
            nameLabel.al_bottom == leftBoldLabel.al_top - 10,
            nameLabel.al_left == al_left + (screenWidth * 0.06),
            nameLabel.al_right == profileImageView.al_left - 10,
            nameLabel.al_height == screenWidth * 0.19,
            
            leftHeaderLabel.al_left == nameLabel.al_left + 5,
            leftHeaderLabelConstraint!,
            
            leftBoldLabel.al_left == leftDescriptorLabel.al_left,
            leftBoldLabel.al_bottom == leftDescriptorLabel.al_top,
            
            rightBoldLabel.al_left == rightDescriptorLabel.al_left,
            rightBoldLabel.al_bottom == leftDescriptorLabel.al_top,
            
            leftDescriptorLabel.al_left == nameLabel.al_left,
            leftDescriptorLabel.al_bottom == al_bottom - (bounds.height * 0.10),
            
            rightDescriptorLabel.al_left == leftDescriptorLabel.al_right + 38,
            rightDescriptorLabel.al_bottom == leftDescriptorLabel.al_bottom,
            
            rightHeaderLabel.al_right == rightHeaderButton.al_left + 13.0,
            rightHeaderLabel.al_centerY == leftHeaderLabel.al_centerY,
            rightHeaderLabel.al_height == rightHeaderButton.al_height,
            
            rightHeaderButton.al_left == rightHeaderLabel.al_right - 50,
            rightHeaderButton.al_right == al_right - 3.0,
            rightHeaderButton.al_centerY == leftHeaderLabel.al_centerY
        ])
    }
}