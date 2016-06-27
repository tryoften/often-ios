//
//  EmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/3/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

enum EmptyStateImageSize {
    case small
    case medium
    case large
}

class EmptyStateView: UIView {
    var state: UserState
    var titleLabel: UILabel
    var descriptionLabel: UILabel
    var imageView: UIImageView
    var imageViewContainerView: UIView
    var primaryButton: UIButton
    var secondaryButton: UIButton?
    var closeButton: UIButton
    var imageEdgeInsets: UIEdgeInsets
    var imageSize: EmptyStateImageSize {
        didSet {
            switch self.imageSize {
            case .small:
                imageView.removeFromSuperview()
                imageEdgeInsets = UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)
                imageViewContainerView.addSubview(imageView)
                updateImageSize(imageEdgeInsets)
            case .medium:
                imageView.removeFromSuperview()
                imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
                imageViewContainerView.addSubview(imageView)
                updateImageSize(imageEdgeInsets)
            case .large:
                imageView.removeFromSuperview()
                imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                imageViewContainerView.addSubview(imageView)
                updateImageSize(imageEdgeInsets)
            }
        }
    }
    
    var imageViewTopInsetConstraint: NSLayoutConstraint?
    var imageViewLeftInsetConstraint: NSLayoutConstraint?
    var imageViewRightInsetConstraint: NSLayoutConstraint?
    var imageViewBottomInsetConstraint: NSLayoutConstraint?
    
    var imageViewTopConstraint: NSLayoutConstraint?
    var imageViewTopPadding: CGFloat = 0

    static func emptyStateViewForUserState(_ state: UserState) -> EmptyStateView? {
        switch state {
        case .noKeyboard:
            return NoKeyboardEmptyStateView()
        case .noTwitter:
            return TwitterEmptyStateView()
        case .noFavorites:
            return FavoritesEmptyStateView()
        case .noRecents:
            return RecentsEmptyStateView()
        case .noResults:
            return NoResultsEmptyStateView()
        default:
            return nil
        }
    }
    
    init(state: UserState) {
        self.state = state
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.textColor = UIColor(fromHexString: "#202020")
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.alpha = 0.54
        
        imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        imageSize = .medium
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageViewContainerView = UIView()
        imageViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        primaryButton = UIButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        primaryButton.layer.cornerRadius = 20.0
        primaryButton.clipsToBounds = true
        primaryButton.isHidden = true
        primaryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(StyleKit.imageOfButtonclose(scale: 0.75), for: UIControlState())
        closeButton.alpha = 0.54
        closeButton.isHidden = true
        closeButton.isUserInteractionEnabled = false
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        imageViewContainerView.addSubview(imageView)
        addSubview(imageViewContainerView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(primaryButton)
        addSubview(closeButton)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImageSize(_ insets: UIEdgeInsets) {
        addConstraints([
            imageView.al_top == imageViewContainerView.al_top + insets.top,
            imageView.al_left == imageViewContainerView.al_left + insets.left,
            imageView.al_right == imageViewContainerView.al_right - insets.right,
            imageView.al_bottom == imageViewContainerView.al_bottom - insets.bottom
        ])
        layoutSubviews()
    }
    
    func setupLayout() {
        imageViewTopConstraint = imageViewContainerView.al_centerY == al_centerY - 60

        var constraints = [
            imageViewContainerView.al_centerX == al_centerX,
            imageViewTopConstraint!,
            imageViewContainerView.al_height == 120,
            imageViewContainerView.al_width == 120
        ]

        constraints += [
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == imageViewContainerView.al_bottom + 15
        ]

        constraints += [
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_top == titleLabel.al_bottom + 5
        ]

        constraints += [
            primaryButton.al_centerX == al_centerX,
            primaryButton.al_top == descriptionLabel.al_bottom + 20,
            primaryButton.al_height == 40
        ]

        constraints += [
            closeButton.al_height == 40,
            closeButton.al_width == 40,
            closeButton.al_top == al_top + 10,
            closeButton.al_right == al_right - 10
        ]

        addConstraints(constraints)
        
        updateImageSize(imageEdgeInsets)
    }
}
