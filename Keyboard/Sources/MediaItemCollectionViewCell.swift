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

    var type: MediaItemCollectionViewCellType = .metadata {
        didSet {
            setupCellType()
        }
    }

    var style: MediaItemCollectionViewCellStyle = .card {
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

    var avatarImageURL: URL? {
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

        contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        sourceLogoView = UIImageView()
        sourceLogoView.translatesAutoresizingMaskIntoConstraints = false
        sourceLogoView.contentMode = .scaleAspectFill
        sourceLogoView.layer.cornerRadius = 2.0
        sourceLogoView.clipsToBounds = true
        sourceLogoView.backgroundColor = LightGrey

        hotnessLogoView = UIImageView()
        hotnessLogoView.translatesAutoresizingMaskIntoConstraints = false
        hotnessLogoView.contentMode = .scaleAspectFill
        hotnessLogoView.image = StyleKit.imageOfHotness(scale: 0.5)
        hotnessLogoView.layer.cornerRadius = 2.0
        hotnessLogoView.clipsToBounds = true
        hotnessLogoView.isHidden = true
        
        leftHeaderLabel = UILabel()
        leftHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHeaderLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.5)
        leftHeaderLabel.textColor = BlackColor?.withAlphaComponent(0.74)

        rightHeaderLabel = UILabel()
        rightHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        rightHeaderLabel.textColor = BlackColor?.withAlphaComponent(0.54)

        mainTextLabel = UILabel()
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.font = UIFont(name: "OpenSans", size: 12.5)
        mainTextLabel.textColor = BlackColor?.withAlphaComponent(0.90)
        mainTextLabel.numberOfLines = 3
        
        centerMetadataLabel = UILabel()
        centerMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        centerMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
        centerMetadataLabel.textColor = BlackColor?.withAlphaComponent(0.90)
        
        leftMetadataLabel = UILabel()
        leftMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        leftMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
        leftMetadataLabel.textColor = BlackColor?.withAlphaComponent(0.54)
        
        rightMetadataLabel = UILabel()
        rightMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        rightMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
        rightMetadataLabel.textColor = BlackColor?.withAlphaComponent(0.54)
        rightMetadataLabel.textAlignment = .right
        
        rightCornerImageView = UIImageView()
        rightCornerImageView.translatesAutoresizingMaskIntoConstraints = false
        rightCornerImageView.contentMode = .scaleAspectFit
        
        contentPlaceholderImageView = UIImageView(image: UIImage(named: "placeholder"))
        contentPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        contentPlaceholderImageView.contentMode = .scaleAspectFill
        contentPlaceholderImageView.clipsToBounds = true
        
        contentImageView = UIImageView()
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.clipsToBounds = true
        
        favoriteRibbon = UIImageView()
        favoriteRibbon.translatesAutoresizingMaskIntoConstraints = false
        favoriteRibbon.image = StyleKit.imageOfFavoritedstate(frame: CGRect(x: 0, y: 0, width: 62, height: 62), scale: 0.5)
        favoriteRibbon.isHidden = true
        
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
        bottomSeperator.frame = CGRect(x: 0, y: frame.height - 0.6, width: frame.width, height: 0.6)
    }
    
    func reset() {
        sourceLogoView.image = nil
        leftHeaderLabel.text = ""
        rightHeaderLabel.text = ""
        mainTextLabel.text = ""
        mainTextLabel.textAlignment = .left
        leftMetadataLabel.text = ""
        centerMetadataLabel.text = ""
        rightMetadataLabel.text = ""
        rightCornerImageView.image = nil
        showImageView = true
    }

    func setupCellType() {
        let hasNoMetadata = type == .noMetadata

        leftMetadataLabel.isHidden = hasNoMetadata
        rightMetadataLabel.isHidden = hasNoMetadata
        contentImageView.isHidden = hasNoMetadata
        sourceLogoView.isHidden = hasNoMetadata
        leftHeaderLabel.isHidden = hasNoMetadata
        rightHeaderLabel.isHidden = hasNoMetadata
        mainTextLabelCenterConstraint?.constant = hasNoMetadata ? 0 : 5
    }

    func setupCellStyle() {
        switch style {
        case .cell:
            contentView.layer.cornerRadius = 0.0
            layer.cornerRadius = 0.0
            backgroundColor = VeryLightGray
            layer.shadowOpacity = 0.0
        case .card:
            contentView.layer.cornerRadius = 2.0
            backgroundColor = WhiteColor
            layer.cornerRadius = 2.0
            layer.shadowColor = UIColor.black().cgColor
            layer.shadowOpacity = 0.14
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowRadius = 1
            bottomSeperator.isHidden = true
        }
    }

    func setupLayout() {
        mainTextLabelCenterConstraint = mainTextLabel.al_centerY == al_centerY

        var constraints = [
            metadataContentView.al_left == al_left,
            metadataContentView.al_top == al_top,
            metadataContentView.al_bottom == al_bottom,
            metadataContentView.al_right == contentImageView.al_left
        ]

        constraints += [
            contentImageView.al_right == al_right,
            contentImageView.al_top == al_top,
            contentImageView.al_bottom == al_bottom,
            contentImageViewWidthConstraint
        ]

        constraints += [
            contentPlaceholderImageView.al_right == al_right,
            contentPlaceholderImageView.al_top == al_top,
            contentPlaceholderImageView.al_bottom == al_bottom,
            contentPlaceholderImageView.al_width == contentImageView.al_width
        ]

        constraints += [
            sourceLogoView.al_left == metadataContentView.al_left + contentEdgeInsets.left,
            sourceLogoView.al_top == metadataContentView.al_top + contentEdgeInsets.top,
            avatarImageViewWidthConstraint,
            sourceLogoView.al_height == 18,
            leftHeaderLabelLeftPaddingConstraint!,
            leftHeaderLabel.al_centerY == sourceLogoView.al_centerY,
            leftHeaderLabel.al_height == 16,
            leftHeaderLabel.al_right <= metadataContentView.al_centerX
        ]

        constraints += [
            rightHeaderLabel.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            rightHeaderLabel.al_centerY == sourceLogoView.al_centerY,
            rightHeaderLabel.al_height == 16,
            leftHeaderLabel.al_left <= metadataContentView.al_centerX
        ]

        constraints += [
            hotnessLogoView.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            hotnessLogoView.al_centerY == metadataContentView.al_top + contentEdgeInsets.top,
            hotnessLogoView.al_top == metadataContentView.al_top + contentEdgeInsets.top,
            hotnessLogoView.al_width == 18,
            hotnessLogoView.al_height == 18
        ]

        constraints += [
            leftMetadataLabel.al_left == metadataContentView.al_left + contentEdgeInsets.left,
            leftMetadataLabel.al_bottom == metadataContentView.al_bottom - contentEdgeInsets.bottom,
            leftMetadataLabel.al_height == 12
        ]

        constraints += [
            centerMetadataLabel.al_left == leftMetadataLabel.al_right + 12,
            centerMetadataLabel.al_centerY == leftMetadataLabel.al_centerY
        ]

        constraints += [
            mainTextLabel.al_right == metadataContentView.al_right - 24,
            mainTextLabel.al_left == metadataContentView.al_left + 24,
            mainTextLabelCenterConstraint!
        ]

        constraints += [
            rightMetadataLabel.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            rightMetadataLabel.al_centerY == leftMetadataLabel.al_centerY,
            rightMetadataLabel.al_left == centerMetadataLabel.al_right + 6,
            
            rightCornerImageView.al_top == metadataContentView.al_top + 10,
            rightCornerImageView.al_right == contentImageView.al_left - 12,
            rightCornerImageView.al_height == 20,
            rightCornerImageView.al_width == 20,
            
            favoriteRibbon.al_right == al_right,
            favoriteRibbon.al_bottom == al_bottom,
            
        ]

        addConstraints(constraints)
    }
}

enum MediaItemCollectionViewCellType: ErrorProtocol {
    case metadata
    case noMetadata
}

enum MediaItemCollectionViewCellStyle {
    case cell
    case card
}


