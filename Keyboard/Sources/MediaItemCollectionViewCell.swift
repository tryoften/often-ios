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
    var overlayView: SearchResultsCellOverlayView
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
    
    override var overlayVisible: Bool {
        didSet {
            if overlayVisible {
                overlayView.hidden = false
                overlayView.showButtons {}
                overlayView.favoriteButton.selected = itemFavorited
            } else {
                UIView.animateWithDuration(0.2, animations: {
                    self.overlayView.alpha = 0.0
                }, completion: { done in
                    self.overlayView.hidden = true
                    self.overlayView.alpha = 1.0
                })
            }
        }
    }
    
    override var itemFavorited: Bool {
        didSet {
            overlayView.favoriteButton.selected = itemFavorited
            favoriteRibbon.hidden = !itemFavorited
        }
    }
    
    var inMainApp: Bool {
        didSet {
            showCopyButton()
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
        leftHeaderLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.5)
        leftHeaderLabel.textColor = BlackColor.colorWithAlphaComponent(0.74)

        rightHeaderLabel = UILabel()
        rightHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        rightHeaderLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)

        mainTextLabel = UILabel()
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.font = UIFont(name: "OpenSans", size: 12.5)
        mainTextLabel.textColor = BlackColor.colorWithAlphaComponent(0.90)
        mainTextLabel.numberOfLines = 3
        
        centerMetadataLabel = UILabel()
        centerMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        centerMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
        centerMetadataLabel.textColor = BlackColor.colorWithAlphaComponent(0.90)
        
        leftMetadataLabel = UILabel()
        leftMetadataLabel.translatesAutoresizingMaskIntoConstraints = false
        leftMetadataLabel.font = UIFont(name: "OpenSans", size: 10.0)
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
        
        overlayView = SearchResultsCellOverlayView()
        overlayView.hidden = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        inMainApp = false
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
        contentView.addSubview(overlayView)
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
        
        overlayView.favoriteButton.addTarget(self, action: "didTapFavoriteButton:", forControlEvents: .TouchUpInside)
        overlayView.cancelButton.addTarget(self, action: "didTapCancelButton:", forControlEvents: .TouchUpInside)
        overlayView.doneButton.addTarget(self, action: "didTapCancelButton:", forControlEvents: .TouchUpInside)
        overlayView.insertButton.addTarget(self, action: "didTapInsertButton:", forControlEvents: .TouchUpInside)
        overlayView.copyButton.addTarget(self, action: "didTapCopyButton:", forControlEvents: .TouchUpInside)
        
        for button in [overlayView.favoriteButton, overlayView.insertButton, overlayView.copyButton, overlayView.doneButton] {
            button.addTarget(self, action: "didTouchUpButton:", forControlEvents: .TouchUpInside)
        }
        
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
        mainTextLabel.textAlignment = .Left
        leftMetadataLabel.text = ""
        centerMetadataLabel.text = ""
        rightMetadataLabel.text = ""
        rightCornerImageView.image = nil
        showImageView = true
        overlayView.hidden = true
    }

    func setupCellType() {
        let hasNoMetadata = type == .NoMetadata

        leftMetadataLabel.hidden = hasNoMetadata
        rightMetadataLabel.hidden = hasNoMetadata
        contentImageView.hidden = hasNoMetadata
        sourceLogoView.hidden = hasNoMetadata
        leftHeaderLabel.hidden = hasNoMetadata
        rightHeaderLabel.hidden = hasNoMetadata
        mainTextLabelCenterConstraint?.constant = hasNoMetadata ? 0 : 5
    }

    func setupCellStyle() {
        switch style {
        case .Cell:
            contentView.layer.cornerRadius = 0.0
            layer.cornerRadius = 0.0
            backgroundColor = VeryLightGray
            layer.shadowOpacity = 0.0
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

    func prepareOverlayView() {
        overlayView.middleLabel.text = "cancel".uppercaseString
        overlayView.rightLabel.text = "send".uppercaseString
        overlayView.leftLabel.text = "favorite".uppercaseString
        overlayView.cancelButton.hidden = false
        overlayView.doneButton.hidden = true
        overlayView.copyButton.selected = false
        showCopyButton()
    }
   
    func didTapFavoriteButton(button: SpringButton) {
        overlayView.favoriteButton.selected = !overlayView.favoriteButton.selected
        updatedButtonLabels(button)
        
        delegate?.mediaLinkCollectionViewCellDidToggleFavoriteButton(self, selected: overlayView.favoriteButton.selected)
    }
    
    
    func didTapCancelButton(button: SpringButton) {
        overlayView.cancelButton.selected = !overlayView.cancelButton.selected
        delegate?.mediaLinkCollectionViewCellDidToggleCancelButton(self, selected: overlayView.cancelButton.selected)
    }
    
    func didTapInsertButton(button: SpringButton) {
        overlayView.insertButton.selected = !overlayView.insertButton.selected
        updatedButtonLabels(button)
        delegate?.mediaLinkCollectionViewCellDidToggleInsertButton(self, selected: overlayView.insertButton.selected)
    }
    
    func didTapCopyButton(button: SpringButton) {
        overlayView.copyButton.selected = !overlayView.copyButton.selected
        updatedButtonLabels(button)
        delegate?.mediaLinkCollectionViewCellDidToggleCopyButton(self, selected: overlayView.copyButton.selected)
    }
    
    func didTouchUpButton(button: SpringButton?) {
        if let button = button {
            animateButton(button)
        }
    }
    
    //MARK: Button Animation
    func animateButton(button: SpringButton) {
        if !(button == overlayView.insertButton || button == overlayView.copyButton) {
            button.animation = "pop"
            button.duration = 0.3
            button.curve = "easeIn"
        }
        
        button.animate()
        
        if button == overlayView.insertButton {
            if overlayView.insertButton.selected {
                UIView.animateWithDuration(0.3, animations: {
                    button.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                })
            }
        }
        
        if button == overlayView.copyButton {
            if overlayView.copyButton.selected {
                UIView.animateWithDuration(0.3, animations: {
                    button.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 180.0)
                })
            }
        }
    }
    
    //MARK: Show Buttons
    func showCopyButton() {
        if inMainApp {
            self.overlayView.copyButton.hidden = !self.inMainApp
            self.overlayView.rightLabel.text = "copy".uppercaseString
            self.overlayView.insertButton.hidden = self.inMainApp
        }
    }

    func updatedButtonLabels(button: SpringButton) {
        if button == overlayView.favoriteButton {
            if overlayView.favoriteButton.selected {
                overlayView.leftLabel.text = "saved!".uppercaseString
            } else {
                overlayView.leftLabel.text = "Favorite".uppercaseString
            }
        }
        
        if button == overlayView.insertButton {
            if overlayView.insertButton.selected {
                overlayView.rightLabel.text = "Remove".uppercaseString
            } else {
                overlayView.rightLabel.text = "send".uppercaseString
            }
        }

        if button == overlayView.copyButton {
            if overlayView.copyButton.selected {
                overlayView.rightLabel.text = "Copied".uppercaseString
            } else {
                overlayView.rightLabel.text = "Copy".uppercaseString
            }

        }

        overlayView.cancelButton.hidden = true
        overlayView.middleLabel.text = "Done".uppercaseString
        overlayView.doneButton.hidden = false
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
            leftHeaderLabelLeftPaddingConstraint!,
            leftHeaderLabel.al_centerY == sourceLogoView.al_centerY,
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

            mainTextLabel.al_right == metadataContentView.al_right - 24,
            mainTextLabel.al_left == metadataContentView.al_left + 24,
            mainTextLabelCenterConstraint!,

            rightMetadataLabel.al_right == metadataContentView.al_right - contentEdgeInsets.right,
            rightMetadataLabel.al_centerY == leftMetadataLabel.al_centerY,
            rightMetadataLabel.al_left == centerMetadataLabel.al_right + 6,
            
            rightCornerImageView.al_top == metadataContentView.al_top + 10,
            rightCornerImageView.al_right == contentImageView.al_left - 12,
            rightCornerImageView.al_height == 20,
            rightCornerImageView.al_width == 20,
            
            favoriteRibbon.al_right == al_right,
            favoriteRibbon.al_bottom == al_bottom,
            
            overlayView.al_top == contentView.al_top,
            overlayView.al_bottom == contentView.al_bottom,
            overlayView.al_left == contentView.al_left,
            overlayView.al_right == contentView.al_right
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


