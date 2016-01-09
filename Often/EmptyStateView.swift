//
//  EmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/3/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    var titleLabel: UILabel
    var descriptionLabel: UILabel
    var imageView: UIImageView
    var imageViewContainerView: UIView
    var primaryButton: UIButton
    var secondaryButton: UIButton?
    var closeButton: UIButton
    var imageEdgeInsets: EdgeInsets
    var imageSize: EmptyStateImageSize {
        didSet {
            switch self.imageSize {
            case .Small:
                imageView.removeFromSuperview()
                imageEdgeInsets = EdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)
                imageViewContainerView.addSubview(imageView)
                updateImageSize(imageEdgeInsets)
            case .Medium:
                imageView.removeFromSuperview()
                imageEdgeInsets = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
                imageViewContainerView.addSubview(imageView)
                updateImageSize(imageEdgeInsets)
            case .Large:
                imageView.removeFromSuperview()
                imageEdgeInsets = EdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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
    
    enum EmptyStateImageSize {
        case Small
        case Medium
        case Large
    }
    
    struct EdgeInsets {
        var top: CGFloat
        var left: CGFloat
        var bottom: CGFloat
        var right: CGFloat
        
        init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
            self.top = top
            self.left = left
            self.bottom = bottom
            self.right = right
        }
        
        init() {
            self.top = 0
            self.left = 0
            self.bottom = 0
            self.right = 0
        }
    }
    
    static func emptyStateViewForUserState(state: UserState) -> EmptyStateView? {
        switch (state) {
        case .NoKeyboard:
            return NoKeyboardEmptyStateView()
        case .NoTwitter:
            return TwitterEmptyStateView()
        case .NoFavorites:
            return FavoritesEmptyStateView()
        case .NoRecents:
            return RecentsEmptyStateView()
        case .NoResults:
            return NoResultsEmptyStateView()
        default:
            return nil
        }
    }
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.textColor = UIColor(fromHexString: "#202020")
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.alpha = 0.54
        
        imageEdgeInsets = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        imageSize = .Medium
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        
        imageViewContainerView = UIView()
        imageViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        primaryButton = UIButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        primaryButton.layer.cornerRadius = 4.0
        primaryButton.clipsToBounds = true
        primaryButton.hidden = true
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(StyleKit.imageOfButtonclose(scale: 0.75), forState: .Normal)
        closeButton.alpha = 0.54
        closeButton.hidden = true
        closeButton.userInteractionEnabled = false
        
        super.init(frame: frame)
        
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
    
    func updateImageSize(insets: EdgeInsets) {
        addConstraints([
            imageView.al_top == imageViewContainerView.al_top + imageEdgeInsets.top,
            imageView.al_left == imageViewContainerView.al_left + imageEdgeInsets.left,
            imageView.al_right == imageViewContainerView.al_right - imageEdgeInsets.right,
            imageView.al_bottom == imageViewContainerView.al_bottom - imageEdgeInsets.bottom
        ])
        layoutSubviews()
    }
    
    func setupLayout() {
        imageViewTopConstraint = imageView.al_centerY == al_centerY - 50

        addConstraints([
            imageViewContainerView.al_centerX == al_centerX,
            imageViewTopConstraint!,
            imageViewContainerView.al_height == 120,
            imageViewContainerView.al_width == 120,
            
            imageView.al_top == imageViewContainerView.al_top + imageEdgeInsets.top,
            imageView.al_left == imageViewContainerView.al_left + imageEdgeInsets.left,
            imageView.al_right == imageViewContainerView.al_right - imageEdgeInsets.right,
            imageView.al_bottom == imageViewContainerView.al_bottom - imageEdgeInsets.bottom,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == imageViewContainerView.al_bottom + 15,
            
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_top == titleLabel.al_bottom + 5,
            
            primaryButton.al_centerX == al_centerX,
            primaryButton.al_top == descriptionLabel.al_bottom + 20,
            primaryButton.al_left == al_left + 30,
            primaryButton.al_right == al_right - 30,
            primaryButton.al_height == 50,
            
            closeButton.al_height == 40,
            closeButton.al_width == 40,
            closeButton.al_top == al_top + 10,
            closeButton.al_right == al_right - 10
        ])
    }
}
