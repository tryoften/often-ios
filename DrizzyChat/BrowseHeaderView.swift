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
    - coverPhoto -> Background that contains the current artist art image as blurred
    - nameLabel -> displays the name of the current artist
    - addArtistButton -> button that adds the current artist's keyboard to the user's list of keyboards

    Sizes:
    - full header: 447
    - inter-card spacing: 40
    - cards:

 */

let BrowseHeaderViewCellIdentifier = "headerCell"

class BrowseHeaderView: UICollectionReusableView, HeaderUpdateDelegate {
    var screenWidth: CGFloat
    var browsePicker: BrowseHeaderCollectionViewController
    var coverPhoto: UIImageView
    var coverPhotoTintView: UIView
    var artistNameLabel: UILabel
    var addArtistButton: UIButton
    var topLabel: UILabel
    
    override init(frame: CGRect) {
        browsePicker = BrowseHeaderCollectionViewController()
        browsePicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        screenWidth = UIScreen.mainScreen().bounds.width
        
        coverPhoto = UIImageView()
        coverPhoto.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverPhoto.contentMode = .ScaleAspectFill
        
        coverPhotoTintView = UIView()
        coverPhotoTintView.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverPhotoTintView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        artistNameLabel = TOMSMorphingLabel()
        artistNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistNameLabel.font = UIFont(name: "Oswald-Light", size: 22.0)
        artistNameLabel.textColor = UIColor(fromHexString: "#d3d3d3")
        artistNameLabel.textAlignment = .Center
        artistNameLabel.text = ""
        
        addArtistButton = UIButton()
        addArtistButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        addArtistButton.backgroundColor = UIColor(fromHexString: "#F9B341")
        addArtistButton.titleLabel?.font = UIFont(name: "OpenSans", size: 9.0)
        addArtistButton.setTitle("ADD ARTIST", forState: UIControlState.Normal)
        addArtistButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        topLabel = UILabel()
        topLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        topLabel.textAlignment = .Center
        topLabel.font = UIFont(name: "OpenSans", size: 18.0)
        topLabel.text = "ADD ARTIST"
        topLabel.textColor = UIColor.whiteColor()
        topLabel.alpha = 0
        
        super.init(frame: frame)
        
        addArtistButton.addTarget(self, action: "addArtistTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        backgroundColor = UIColor(fromHexString: "#f7f7f7")

        addSubview(coverPhoto)
        addSubview(coverPhotoTintView)
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
            UIView.animateWithDuration(0.4, animations: {
                if attributes.progressiveness <= 0.15 {
                    self.topLabel.alpha = 1
                    
                } else if attributes.progressiveness <= 0.90 {
                    self.artistNameLabel.alpha = 0
                    self.addArtistButton.alpha = 0
                    
                } else {
                    self.topLabel.alpha = 0
                    self.artistNameLabel.alpha = 1
                    self.addArtistButton.alpha = 1
                }
            })
        }
    }
    
    /**
        Add the artist and present an alert view
    */
    func addArtistTapped(sender: UIButton) {
        println("Add Artist Tapped.")
    }
    
    func headerDidChange(artist: Artist) {
        artistNameLabel.text = artist.name.uppercaseString
        coverPhoto.setImageWithURL(NSURL(string: artist.imageURLLarge))
        coverPhoto.image?.blurredImageWithRadius(30, iterations: 9, tintColor: UIColor.blackColor())
    }
    
    func setupLayout() {
        addConstraints([
            topLabel.al_top == al_top + 10,
            topLabel.al_centerX == al_centerX,
            
            browsePicker.view.al_top == al_top + 20,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_bottom == al_bottom - 100,
            
            coverPhoto.al_top == al_top,
            coverPhoto.al_left == al_left,
            coverPhoto.al_width == al_width,
            coverPhoto.al_height == al_height,
            
            coverPhotoTintView.al_width == coverPhoto.al_width,
            coverPhotoTintView.al_height == coverPhoto.al_height,
            coverPhotoTintView.al_left == coverPhoto.al_left,
            coverPhotoTintView.al_top == coverPhoto.al_top,
            
            artistNameLabel.al_top == browsePicker.view.al_bottom - 30,
            artistNameLabel.al_centerX == al_centerX,
            
            addArtistButton.al_top == artistNameLabel.al_bottom + 10,
            addArtistButton.al_centerX == al_centerX,
            addArtistButton.al_width == 70,
            addArtistButton.al_height == 20
        ])
    }
}

protocol AddArtistButtonModalDelegate {
    func addArtistButtonDidTap()
}

