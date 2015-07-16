//
//  BrowseHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/27/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    Views:
    - currentBackgroundView -> Background that contains the current artist art image as blurred
    - nameLabel -> displays the name of the current artist
    - addArtistButton -> button that adds the current artist's keyboard to the user's list of keyboards

    Sizes:
    - full header: 447
    - inter-card spacing: 40
    - cards:

 */

let BrowseHeaderViewCellIdentifier = "headerCell"

class BrowseHeaderView: UICollectionReusableView, HeaderUpdateDelegate {
    weak var delegate: BrowseHeaderViewDelegate?
    var browsePicker: BrowseHeaderCollectionViewController
    var previousBackgroundView: UIImageView
    var currentBackgroundView: UIImageView
    var nextBackgroundView: UIImageView
    var tintView: UIView
    var artistNameLabel: UILabel
    var addArtistButton: AddArtistButton
    var topLabel: UILabel
    var currentImageURLs: [String: String]?
    
    override init(frame: CGRect) {
        browsePicker = BrowseHeaderCollectionViewController()
        browsePicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)

        previousBackgroundView = UIImageView()
        previousBackgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        previousBackgroundView.contentMode = .ScaleAspectFill
        previousBackgroundView.accessibilityLabel = "previous background"
        
        currentBackgroundView = UIImageView()
        currentBackgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentBackgroundView.contentMode = .ScaleAspectFill
        currentBackgroundView.accessibilityLabel = "current background"

        nextBackgroundView = UIImageView()
        nextBackgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextBackgroundView.contentMode = .ScaleAspectFill
        nextBackgroundView.accessibilityLabel = "next background"
        
        tintView = UIView()
        tintView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tintView.backgroundColor = BrowseHeaderViewTintViewColor
        
        let model = UIDevice.currentDevice().modelName
        if model.hasPrefix("iPhone 6") || model.hasPrefix("Simulator") {
            artistNameLabel = TOMSMorphingLabel()
        } else {
            artistNameLabel = UILabel()
        }
        artistNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistNameLabel.font = BrowseHeaderViewArtistNameLabelFont
        artistNameLabel.textColor = WhiteColor
        artistNameLabel.textAlignment = .Center
        
        addArtistButton = AddArtistButton()
        addArtistButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        topLabel = UILabel()
        topLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        topLabel.textAlignment = .Center
        topLabel.font = BrowseHeaderViewArtistTopLabelFont
        topLabel.text = "ADD ARTIST"
        topLabel.textColor = WhiteColor
        topLabel.alpha = 0
        
        super.init(frame: frame)

        browsePicker.headerDelegate = self
        addArtistButton.addTarget(self, action: "addArtistTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        backgroundColor = VeryLightGray

        addSubview(previousBackgroundView)
        addSubview(nextBackgroundView)
        addSubview(currentBackgroundView)
        addSubview(tintView)
        addSubview(browsePicker.view)
        addSubview(artistNameLabel)
        addSubview(addArtistButton)
        addSubview(topLabel)
        
        clipsToBounds = true

        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            
            UIView.animateWithDuration(0.3) {
                if progressiveness <= 0.8 {
                    var val = progressiveness - 0.3
                    self.browsePicker.view.alpha = val
                } else {
                    self.browsePicker.view.alpha = 1.0
                }
            }
        }
    }
    
    /**
        Add the artist and present an alert view
    */
    func addArtistTapped(sender: UIButton) {
        addArtistButton.selected = !addArtistButton.selected
        addArtistButton.enabled = false
        addArtistButton.userInteractionEnabled = false
        delegate?.browseHeaderViewDidTapAddArtistButton(self, selected: addArtistButton.selected)
    }
    
    // MARK: HeaderUpdateDelegate
    
    func headerDidChange(artist: Artist, previousArtist: Artist?, nextArtist: Artist?) {
        var URLs = [String: String]()
        
        if let previousArtist = previousArtist {
            URLs["previous"] = previousArtist.imageURLLarge
        }
        
        if let nextArtist = nextArtist {
            URLs["next"] = nextArtist.imageURLLarge
        }
        
        URLs["current"] = artist.imageURLLarge
        
        setBackgroundImages(URLs)
    }
    
    func headerDidPan(browseHeader: BrowseHeaderCollectionViewController, displayedArtist: Artist?, delta: CGFloat) {
        if let artist = displayedArtist {
            artistNameLabel.text = artist.displayName
        }

        var absDelta = abs(delta)
        
        if delta < 0 {
            previousBackgroundView.alpha = absDelta
            nextBackgroundView.alpha = 0
        } else if delta > 0 {
            nextBackgroundView.alpha = absDelta
            previousBackgroundView.alpha = 0
        }

        currentBackgroundView.alpha = 1 - absDelta
    }

    func setBackgroundImages(imageURLs: [String: String]) {
        
        let currentImagesIsSet = !(currentImageURLs == nil)
        
        // if swiping to the right
        if currentImagesIsSet && currentImageURLs!["next"] == imageURLs["current"] {
            previousBackgroundView.image = currentBackgroundView.image
            currentBackgroundView.image = nextBackgroundView.image
        }
        
        // if swiping to the left
        else if currentImagesIsSet && currentImageURLs!["previous"] == imageURLs["current"] {
            nextBackgroundView.image = currentBackgroundView.image
            currentBackgroundView.image = previousBackgroundView.image
        }
        
        // if view just loaded
        else {
            let currentImageURL = NSURL(string: imageURLs["current"]!)
            currentBackgroundView.setImageWithAnimation(currentImageURL!, blurRadius: 30)
        
        }
        
        if let previousURLString = imageURLs["previous"] {
            let previousImageURL = NSURL(string: previousURLString)
            previousBackgroundView.setImageWithAnimation(previousImageURL!, blurRadius: 30)
        }
        
        if let nextURLString = imageURLs["next"] {
            let nextImageURL = NSURL(string: nextURLString)
            nextBackgroundView.setImageWithAnimation(nextImageURL!, blurRadius: 30)
        }

        currentImageURLs = imageURLs
        
        previousBackgroundView.alpha = 0
        currentBackgroundView.alpha = 1
        nextBackgroundView.alpha = 0
    }
    
    func setupLayout() {
        let device = UIDevice.currentDevice()
        let artistNameLabelTopConstraintValue: CGFloat
        
        if device.modelName == "iPhone 6 Plus" {
            artistNameLabelTopConstraintValue = 10.0
        } else if device.modelName.hasPrefix("iPhone 5") { // iPhone 5 & 5s
            artistNameLabelTopConstraintValue = 30.0
        } else {
            artistNameLabelTopConstraintValue = 30.0
        }
        
        addConstraints([
            al_height <= 450,

            topLabel.al_top == al_top + 10,
            topLabel.al_centerX == al_centerX,
            
            browsePicker.view.al_top == al_top + 20,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_bottom == al_bottom - 100,
            browsePicker.view.al_height <= 370,

            previousBackgroundView.al_top == al_top,
            previousBackgroundView.al_left == al_left,
            previousBackgroundView.al_width == al_width,
            previousBackgroundView.al_height == al_height,

            currentBackgroundView.al_top == al_top,
            currentBackgroundView.al_left == al_left,
            currentBackgroundView.al_width == al_width,
            currentBackgroundView.al_height == al_height,

            nextBackgroundView.al_top == al_top,
            nextBackgroundView.al_left == al_left,
            nextBackgroundView.al_width == al_width,
            nextBackgroundView.al_height == al_height,
            
            tintView.al_width == currentBackgroundView.al_width,
            tintView.al_height == currentBackgroundView.al_height,
            tintView.al_left == currentBackgroundView.al_left,
            tintView.al_top == currentBackgroundView.al_top,
            
            artistNameLabel.al_top == browsePicker.view.al_bottom - artistNameLabelTopConstraintValue,
            artistNameLabel.al_top >= al_top + 20,
            artistNameLabel.al_centerX == al_centerX,
            artistNameLabel.al_width == al_width - 40,
            
            addArtistButton.al_top == artistNameLabel.al_bottom + 10,
            addArtistButton.al_centerX == al_centerX
        ])
    }
}

protocol BrowseHeaderViewDelegate: class {
    func browseHeaderViewDidTapAddArtistButton(browseHeaderView: BrowseHeaderView, selected: Bool)
}

