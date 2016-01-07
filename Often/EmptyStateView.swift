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
    var primaryButton: UIButton
    var secondaryButton: UIButton?
    var closeButton: UIButton
    var imageSize: EmptyStateImageSize {
        didSet {
            switch self.imageSize {
            case .Small:
                imageViewHeightConstraint = imageView.al_height == 70
                imageViewWidthConstraint = imageView.al_width == 70
                layoutIfNeeded()
            case .Medium:
                imageViewHeightConstraint = imageView.al_height == 100
                imageViewWidthConstraint = imageView.al_width == 100
                layoutIfNeeded()
            case .Large:
                imageViewHeightConstraint = imageView.al_height == 120
                imageViewWidthConstraint = imageView.al_width == 120
                layoutIfNeeded()
            }
        }
    }
    
    var imageViewTopConstraint: NSLayoutConstraint?
    var imageViewHeightConstraint: NSLayoutConstraint?
    var imageViewWidthConstraint: NSLayoutConstraint?
    var imageViewTopPadding: CGFloat = 30
    
    enum EmptyStateImageSize {
        case Small
        case Medium
        case Large
    }
    
    static func emptyStateViewForUserState(state: UserState) -> EmptyStateView? {
        switch (state) {
        case .NoTwitter:
            return TwitterEmptyStateView()
        case .NoKeyboard:
            return NoKeyboardEmptyStateView()
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
    
    init(title: String, description: String, image: UIImage) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        titleLabel.text = title
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.textColor = UIColor(fromHexString: "#202020")
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.alpha = 0.54
        descriptionLabel.text = description
        
        // Defaults - typically should set for each individual empty states
        imageSize = .Medium
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
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
        
        super.init(frame: CGRectZero)
        
        userInteractionEnabled = false
        backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: .TouchUpInside)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(primaryButton)
        addSubview(closeButton)
        
        setupLayout()
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
        
        // Defaults - typically should set for each individual empty states
        imageSize = .Medium
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        userInteractionEnabled = false
        backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: .TouchUpInside)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(primaryButton)
        addSubview(closeButton)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeButtonTapped() {
        UIView.animateWithDuration(0.4, animations: {
            self.alpha = 0
            self.removeFromSuperview()
        })
    }
    
    func setupLayout() {
        imageViewTopConstraint = imageView.al_top == al_top + 50
        imageViewHeightConstraint = imageView.al_height == 100
        imageViewWidthConstraint = imageView.al_width == 100
        
        addConstraints([
            imageView.al_centerX == al_centerX,
            imageViewTopConstraint!,
            imageViewHeightConstraint!,
            imageViewWidthConstraint!,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == imageView.al_bottom + 20,
            
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_top == titleLabel.al_bottom + 5,
            
            primaryButton.al_centerX == al_centerX,
            primaryButton.al_top == descriptionLabel.al_bottom + 30,
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

protocol EmptyStateDelegate {
    func updateEmptySetVisible(visible: Bool)
}
