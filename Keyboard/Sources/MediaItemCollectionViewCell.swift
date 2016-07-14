//
//  MediaItemCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable function_body_length

import UIKit
import Spring

class MediaItemCollectionViewCell: BaseMediaItemCollectionViewCell {
    var metadataContentView: UIView
    var sourceLogoView: UIImageView
    var hotnessLogoView: UIImageView
    var leftHeaderLabel: UILabel
    var rightHeaderLabel: UILabel
    var mainTextLabel: UILabel
    var leftMetadataLabel: UILabel
    var centerMetadataLabel: UILabel
    var rightMetadataLabel: UILabel
    var rightCornerImageView: UIImageView
    var favoriteRibbon: UIImageView
    var contentEdgeInsets: UIEdgeInsets
    var contentPlaceholderImageView: UIImageView
    var contentImageView: UIImageView
    var bottomSeperator: UIView

    private var contentImageViewWidthConstraint: NSLayoutConstraint
    private var mainTextLabelCenterConstraint: NSLayoutConstraint?
    private var avatarImageViewWidthConstraint: NSLayoutConstraint
    private var leftHeaderLabelLeftPaddingConstraint: NSLayoutConstraint?

    var type: MediaItemCollectionViewCellType = .Metadata {
        didSet {
            setupCellType()
        }
    }

    var style: MediaItemCollectionViewCellStyle = .Card {
        didSet {
            setupCellStyle()
        }
    }

    var contentImage: UIImage? {
        didSet(value) {
            contentImageView.alpha = 0
            if value == nil {
                contentImageView.image = nil
            } else {
                contentImageView.image = value
            }
        }
    }

    var avatarImageURL: NSURL? {
        didSet {
            if let imageURL = avatarImageURL {
                print("Avatar image URL", imageURL)
                sourceLogoView.nk_setImageWith(imageURL)
                avatarImageViewWidthConstraint.constant = 18
                leftHeaderLabelLeftPaddingConstraint?.constant = contentEdgeInsets.left + 24
            } else {
                avatarImageViewWidthConstraint.constant = 0
                leftHeaderLabelLeftPaddingConstraint?.constant = contentEdgeInsets.left
            }
        }
    }

    var showImageView: Bool {
        didSet {
            contentImageViewWidthConstraint.constant = showImageView ? 105 : 0
        }
    }
    


    override init(frame: CGRect) {
        metadataContentView = UIView()
        metadataContentView.translatesAutoresizingMaskIntoConstraints = false

        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey

        contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        
        sourceLogoView = UIImageView()
        sourceLogoView.translatesAutoresizingMaskIntoConstraints = false
        sourceLogoView.contentMode = .ScaleAspectFill
        sourceLogoView.layer.cornerRadius = 2.0
        sourceLogoView.clipsToBounds = true
        sourceLogoView.backgroundColor = LightGrey

        hotnessLogoView = UIImageView()
        hotnessLogoView.translatesAutoresizingMaskIntoConstraints = false
        hotnessLogoView.contentMode = .ScaleAspectFill
        hotnessLogoView.image = StyleKit.imageOfHotness(scale: 0.5)
        hotnessLogoView.layer.cornerRadius = 2.0
        hotnessLogoView.clipsToBounds = true
        hotnessLogoView.hidden = true
        
        leftHeaderLabel = UILabel()
        leftHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHeaderLabel.font = UIFont(name: "OpenSans-Semibold", size: 12.0)
        leftHeaderLabel.textColor = BlackColor.colorWithAlphaComponent(0.74)

        rightHeaderLabel = UILabel()
        rightHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        rightHeaderLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)

        mainTextLabel = UILabel()
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.font = UIFont(name: "Montserrat", size: 14.0)
        mainTextLabel.textColor = BlackColor.colorWithAlphaComponent(0.90)
        mainTextLabel.numberOfLines = 5
        
        centerMetadataLabel = UILabel()
        centerMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        centerMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
        centerMetadataLabel.textColor = BlackColor.colorWithAlphaComponent(0.90)
        
        leftMetadataLabel = UILabel()
        leftMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        leftMetadataLabel.font = UIFont(name: "OpenSans", size: 10.5)
        leftMetadataLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)
        
        rightMetadataLabel = UILabel()
        rightMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        rightMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
        rightMetadataLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)
        rightMetadataLabel.textAlignment = .Right
        
        rightCornerImageView = UIImageView()
        rightCornerImageView.translatesAutoresizingMaskIntoConstraints = false
        rightCornerImageView.contentMode = .ScaleAspectFit
        
        contentPlaceholderImageView = UIImageView(image: UIImage(named: "placeholder"))
        contentPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        contentPlaceholderImageView.contentMode = .ScaleAspectFill
        contentPlaceholderImageView.clipsToBounds = true
        
        contentImageView = UIImageView()
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.contentMode = .ScaleAspectFill
        contentImageView.clipsToBounds = true
        
        favoriteRibbon = UIImageView()
        favoriteRibbon.translatesAutoresizingMaskIntoConstraints = false
        favoriteRibbon.image = StyleKit.imageOfFavoritedstate(frame: CGRectMake(0, 0, 62, 62), scale: 0.5)
        favoriteRibbon.hidden = true
        
        contentImageViewWidthConstraint = contentImageView.al_width == 105
        avatarImageViewWidthConstraint = sourceLogoView.al_width == 0

        showImageView = true
        
        super.init(frame: frame)
        
        itemFavorited = false
        overlayVisible = false
        
        leftHeaderLabelLeftPaddingConstraint = leftHeaderLabel.al_left == al_left + contentEdgeInsets.left

        avatarImageURL = nil

        contentView.clipsToBounds = false
        contentView.addSubview(metadataContentView)
        contentView.addSubview(contentPlaceholderImageView)
        contentView.addSubview(contentImageView)
        contentView.addSubview(favoriteRibbon)
        contentView.addSubview(bottomSeperator)
        
        metadataContentView.addSubview(sourceLogoView)
        metadataContentView.addSubview(leftHeaderLabel)
        metadataContentView.addSubview(rightHeaderLabel)
        metadataContentView.addSubview(mainTextLabel)
        metadataContentView.addSubview(leftMetadataLabel)
        metadataContentView.addSubview(centerMetadataLabel)
        metadataContentView.addSubview(rightMetadataLabel)
        metadataContentView.addSubview(rightCornerImageView)
        metadataContentView.addSubview(hotnessLogoView)
        
        setupLayout()
        setupCellStyle()
        layoutIfNeeded()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        bottomSeperator.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.6, CGRectGetWidth(frame), 0.6)
    }
    
    func reset() {
        sourceLogoView.image = nil
        leftHeaderLabel.text = ""
        rightHeaderLabel.text = ""
        mainTextLabel.text = ""
        mainTextLabel.textAlignment = .Right
        leftMetadataLabel.text = ""
        centerMetadataLabel.text = ""
        rightMetadataLabel.text = ""
        rightCornerImageView.image = nil
        showImageView = true
    }

    func setupCellType() {
        let hasNoMetadata = type == .NoMetadata

        leftMetadataLabel.hidden = hasNoMetadata
        rightMetadataLabel.hidden = hasNoMetadata
        contentImageView.hidden = hasNoMetadata
        sourceLogoView.hidden = hasNoMetadata
        leftHeaderLabel.hidden = hasNoMetadata
        rightHeaderLabel.hidden = true
        mainTextLabelCenterConstraint?.constant = hasNoMetadata ? 0 : 5
    }

    func setupCellStyle() {
        switch style {
        case .Cell:
            contentView.layer.cornerRadius = 2.0
            layer.cornerRadius = 2.0
            layer.shadowOffset = CGSizeMake(0, 1)
            backgroundColor = WhiteColor
            layer.shadowOpacity = 0.14
            layer.shadowRadius = 1
            bottomSeperator.hidden = true
        case .Card:
            contentView.layer.cornerRadius = 2.0
            backgroundColor = WhiteColor
            layer.cornerRadius = 2.0
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOpacity = 0.14
            layer.shadowOffset = CGSizeMake(0, 1)
            layer.shadowRadius = 1
            bottomSeperator.hidden = true
        }
    }

    func setupLayout() {
        mainTextLabelCenterConstraint = mainTextLabel.al_centerY == al_centerY

        addConstraints([
            metadataContentView.al_left == al_left,
            metadataContentView.al_top == al_top,
            metadataContentView.al_bottom == al_bottom,
            metadataContentView.al_right == contentImageView.al_left,
            
            contentImageView.al_right == al_right,
            contentImageView.al_top == al_top,
            contentImageView.al_bottom == al_bottom,
            contentImageViewWidthConstraint,
            
            contentPlaceholderImageView.al_right == al_right,
            contentPlaceholderImageView.al_top == al_top,
            contentPlaceholderImageView.al_bottom == al_bottom,
            contentPlaceholderImageView.al_width == contentImageView.al_width,
            
            sourceLogoView.al_left == metadataContentView.al_left + contentEdgeInsets.left,
            sourceLogoView.al_top == metadataContentView.al_top + contentEdgeInsets.top,
            avatarImageViewWidthConstraint,
            sourceLogoView.al_height == 18,
            
            leftHeaderLabel.al_left == leftMetadataLabel.al_left,
            leftHeaderLabel.al_bottom == leftMetadataLabel.al_top,
            leftHeaderLabel.al_height == 16,
            leftHeaderLabel.al_right <= metadataContentView.al_centerX,

            rightHeaderLabel.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            rightHeaderLabel.al_centerY == sourceLogoView.al_centerY,
            rightHeaderLabel.al_height == 16,
            leftHeaderLabel.al_left <= metadataContentView.al_centerX,

            hotnessLogoView.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            hotnessLogoView.al_centerY == metadataContentView.al_top + contentEdgeInsets.top,
            hotnessLogoView.al_top == metadataContentView.al_top + contentEdgeInsets.top,
            hotnessLogoView.al_width == 18,
            hotnessLogoView.al_height == 18,

            leftMetadataLabel.al_left == metadataContentView.al_left + contentEdgeInsets.left,
            leftMetadataLabel.al_bottom == metadataContentView.al_bottom - contentEdgeInsets.bottom,
            leftMetadataLabel.al_height == 12,
            
            centerMetadataLabel.al_left == leftMetadataLabel.al_right + 12,
            centerMetadataLabel.al_centerY == leftMetadataLabel.al_centerY,

            mainTextLabel.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            mainTextLabel.al_left == metadataContentView.al_left + 24,
            mainTextLabel.al_top == al_top + contentEdgeInsets.top,
            mainTextLabel.al_bottom <= leftMetadataLabel.al_bottom,

            rightMetadataLabel.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            rightMetadataLabel.al_centerY == leftMetadataLabel.al_centerY,
            rightMetadataLabel.al_left == centerMetadataLabel.al_right + 6,
            
            rightCornerImageView.al_top == metadataContentView.al_top + 10,
            rightCornerImageView.al_right == contentImageView.al_left - 12,
            rightCornerImageView.al_height == 20,
            rightCornerImageView.al_width == 20,
            
            favoriteRibbon.al_right == al_right,
            favoriteRibbon.al_bottom == al_bottom,
            
        ])
    }
}

enum MediaItemCollectionViewCellType: ErrorType {
    case Metadata
    case NoMetadata
}

enum MediaItemCollectionViewCellStyle {
    case Cell
    case Card
}


