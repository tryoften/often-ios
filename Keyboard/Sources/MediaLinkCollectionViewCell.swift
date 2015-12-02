//
//  MediaLinkCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable function_body_length

import UIKit
import Spring

class MediaLinkCollectionViewCell: UICollectionViewCell {
    weak var delegate: MediaLinksCollectionViewCellDelegate?
    
    var informationContainerView: UIView
    var sourceLogoView: UIImageView
    var headerLabel: UILabel
    var mainTextLabel: UILabel
    var leftSupplementLabel: UILabel
    var centerSupplementLabel: UILabel
    var rightSupplementLabel: UILabel
    var rightCornerImageView: UIImageView
    var overlayView: SearchResultsCellOverlayView
    var favoriteRibbon: UIImageView
    var contentPlaceholderImageView: UIImageView
    var contentImageView: UIImageView
    var contentImageViewWidthConstraint: NSLayoutConstraint?
    var contentImage: UIImage? {
        didSet(value) {
            contentImageView.alpha = 0
            if value == nil {
                contentImageView.image = nil
            } else {
                contentImageView.image = value
            }
            
            UIView.animateWithDuration(0.3) {
                self.contentImageView.alpha = 1.0
            }
        }
    }
    
    var overlayVisible: Bool {
        didSet {
            if (overlayVisible) {
                overlayView.hidden = false
                overlayView.showButtons()
                overlayView.favoriteButton.selected = itemFavorited
            } else {
                overlayView.hidden = true
                
            }
        }
    }
    
    var itemFavorited: Bool {
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
    
    var mediaLink: MediaLink?

    
    override init(frame: CGRect) {
        informationContainerView = UIView()
        informationContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        sourceLogoView = UIImageView()
        sourceLogoView.translatesAutoresizingMaskIntoConstraints = false
        sourceLogoView.contentMode = .ScaleAspectFit
        sourceLogoView.layer.cornerRadius = 2.0
        sourceLogoView.clipsToBounds = true
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        
        mainTextLabel = UILabel()
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.font = UIFont(name: "OpenSans", size: 11.0)
        mainTextLabel.numberOfLines = 2
        
        centerSupplementLabel = UILabel()
        centerSupplementLabel.translatesAutoresizingMaskIntoConstraints = false
        centerSupplementLabel.font = UIFont(name: "OpenSans", size: 10.0)
        centerSupplementLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)
        
        leftSupplementLabel = UILabel()
        leftSupplementLabel.translatesAutoresizingMaskIntoConstraints = false
        leftSupplementLabel.font = UIFont(name: "OpenSans", size: 10.0)
        leftSupplementLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)
        
        rightSupplementLabel = UILabel()
        rightSupplementLabel.translatesAutoresizingMaskIntoConstraints = false
        rightSupplementLabel.font = UIFont(name: "OpenSans", size: 10.0)
        rightSupplementLabel.textColor = BlackColor.colorWithAlphaComponent(0.54)
        rightSupplementLabel.textAlignment = .Right
        
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
        
        contentImageViewWidthConstraint = contentImageView.al_width == 100
        
        overlayView = SearchResultsCellOverlayView()
        overlayView.hidden = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        overlayVisible = false
        itemFavorited = false
        inMainApp = false
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.17
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowRadius = 2.0
        
        contentView.layer.cornerRadius = 2.0
        contentView.clipsToBounds = true
        contentView.addSubview(informationContainerView)
        contentView.addSubview(contentPlaceholderImageView)
        contentView.addSubview(contentImageView)
        contentView.addSubview(favoriteRibbon)
        contentView.addSubview(overlayView)
        
        informationContainerView.addSubview(sourceLogoView)
        informationContainerView.addSubview(headerLabel)
        informationContainerView.addSubview(mainTextLabel)
        informationContainerView.addSubview(leftSupplementLabel)
        informationContainerView.addSubview(centerSupplementLabel)
        informationContainerView.addSubview(rightSupplementLabel)
        informationContainerView.addSubview(rightCornerImageView)
        
        setupLayout()
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
    
    func reset() {
        sourceLogoView.image = nil
        headerLabel.text = ""
        mainTextLabel.text = ""
        leftSupplementLabel.text = ""
        centerSupplementLabel.text = ""
        rightSupplementLabel.text = ""
        rightCornerImageView.image = nil
    }
    
    func prepareOverlayView() {
        overlayView.middleLabel.text = "cancel".uppercaseString
        overlayView.cancelButton.hidden = false
        overlayView.doneButton.hidden = true
        overlayView.copyButton.selected = false
        overlayView.rightLabel.text = "share".uppercaseString
        overlayView.leftLabel.text = "favorite".uppercaseString
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
                overlayView.leftLabel.text = "favorite".uppercaseString
            }
        }
        
        if button == overlayView.insertButton {
            if overlayView.insertButton.selected {
                overlayView.rightLabel.text = "Remove".uppercaseString
            } else {
                overlayView.rightLabel.text = "Share".uppercaseString
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
        contentImageViewWidthConstraint = contentImageView.al_width == al_height

        addConstraints([
            informationContainerView.al_left == al_left,
            informationContainerView.al_top == al_top,
            informationContainerView.al_bottom == al_bottom,
            informationContainerView.al_right == contentImageView.al_left,
            
            contentImageView.al_right == al_right,
            contentImageView.al_top == al_top,
            contentImageView.al_bottom == al_bottom,
            contentImageViewWidthConstraint!,
            
            contentPlaceholderImageView.al_right == al_right,
            contentPlaceholderImageView.al_top == al_top,
            contentPlaceholderImageView.al_bottom == al_bottom,
            contentPlaceholderImageView.al_width == contentImageView.al_width,
            
            sourceLogoView.al_left == informationContainerView.al_left + 15,
            sourceLogoView.al_top == informationContainerView.al_top + 10,
            sourceLogoView.al_width == 18,
            sourceLogoView.al_height == 18,
            
            headerLabel.al_left == sourceLogoView.al_right + 5,
            headerLabel.al_centerY == sourceLogoView.al_centerY,
            headerLabel.al_height == 16,
            
            mainTextLabel.al_left == informationContainerView.al_left + 15,
            mainTextLabel.al_top == headerLabel.al_bottom + 8,
            mainTextLabel.al_right == contentImageView.al_left - 15,
            
            leftSupplementLabel.al_left == mainTextLabel.al_left,
            leftSupplementLabel.al_bottom == informationContainerView.al_bottom - 10,
            leftSupplementLabel.al_height == 15,
            
            centerSupplementLabel.al_left == leftSupplementLabel.al_right + 15,
            centerSupplementLabel.al_centerY == leftSupplementLabel.al_centerY,
            
            rightSupplementLabel.al_right == mainTextLabel.al_right,
            rightSupplementLabel.al_centerY == leftSupplementLabel.al_centerY,
            rightSupplementLabel.al_left == centerSupplementLabel.al_right + 5,
            
            rightCornerImageView.al_top == informationContainerView.al_top + 10,
            rightCornerImageView.al_right == contentImageView.al_left - 15,
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

protocol MediaLinksCollectionViewCellDelegate: class {
    func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaLinkCollectionViewCell, selected: Bool)
    func mediaLinkCollectionViewCellDidToggleCancelButton(cell: MediaLinkCollectionViewCell, selected: Bool)
    func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaLinkCollectionViewCell, selected: Bool)
    func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaLinkCollectionViewCell, selected: Bool)
}
