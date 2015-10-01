//
//  SearchResultsCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import Spring

class SearchResultsCollectionViewCell: UICollectionViewCell {
    weak var delegate: SearchResultsCollectionViewCellDelegate?
    
    var informationContainerView: UIView
    var sourceLogoView: UIImageView
    var headerLabel: UILabel
    var mainTextLabel: UILabel
    var leftSupplementLabel: UILabel
    var centerSupplementLabel: UILabel
    var rightSupplementLabel: UILabel
    var rightCornerImageView: UIImageView
    var overlayView: SearchResultsCellOverlayView
    
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
        }
    }
    
    var searchResult: SearchResult?

    
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
        
        contentImageViewWidthConstraint = contentImageView.al_width == 100
        
        overlayView = SearchResultsCellOverlayView()
        overlayView.hidden = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        overlayVisible = false
        itemFavorited = false
        
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
        
        overlayView.favoriteButton.addTarget(self, action: "didTapFavoriteButton", forControlEvents: .TouchUpInside)
        overlayView.cancelButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        overlayView.insertButton.addTarget(self, action: "didTapInsertButton", forControlEvents: .TouchUpInside)
        
        for button in [overlayView.favoriteButton, overlayView.cancelButton, overlayView.insertButton] {
            button.addTarget(self, action: "didTouchUpButton:", forControlEvents: .TouchUpInside)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapFavoriteButton() {
        overlayView.favoriteButton.animation = ""
        overlayView.favoriteButton.selected = !overlayView.favoriteButton.selected
        delegate?.searchResultsCollectionViewCellDidToggleFavoriteButton(self, selected: overlayView.favoriteButton.selected)
    }
    
    func didTapCancelButton() {
        overlayView.cancelButton.selected = !overlayView.cancelButton.selected
        delegate?.searchResultsCollectionViewCellDidToggleCancelButton(self, selected: overlayView.cancelButton.selected)
    }
    
    func didTapInsertButton() {
        overlayView.insertButton.selected = !overlayView.insertButton.selected
        delegate?.searchResultsCollectionViewCellDidToggleInsertButton(self, selected: overlayView.insertButton.selected)
    }
    
    func didTouchUpButton(button: SpringButton?) {
        if let button = button {
            animateButton(button)
        }
    }
    
    func animateButton(button: SpringButton) {
        button.animation = "pop"
        button.duration = 0.3
        button.curve = "easeIn"
        button.animate()
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
            
            rightCornerImageView.al_top == informationContainerView.al_top + 10,
            rightCornerImageView.al_right == contentImageView.al_left - 15,
            rightCornerImageView.al_height == 20,
            rightCornerImageView.al_width == 20,
            
            overlayView.al_top == contentView.al_top,
            overlayView.al_bottom == contentView.al_bottom,
            overlayView.al_left == contentView.al_left,
            overlayView.al_right == contentView.al_right
        ])
    }
}

protocol SearchResultsCollectionViewCellDelegate: class {
    func searchResultsCollectionViewCellDidToggleFavoriteButton(cell: SearchResultsCollectionViewCell, selected: Bool)
    func searchResultsCollectionViewCellDidToggleCancelButton(cell: SearchResultsCollectionViewCell, selected: Bool)
    func searchResultsCollectionViewCellDidToggleInsertButton(cell: SearchResultsCollectionViewCell, selected: Bool)
}
