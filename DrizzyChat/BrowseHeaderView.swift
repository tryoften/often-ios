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

class BrowseHeaderView: UICollectionReusableView {
    var screenWidth: CGFloat
    var browsePicker: BrowseHeaderCollectionViewController
    var coverPhoto: UIImageView
    var artistNameLabel: UILabel
    
    override init(frame: CGRect) {
        browsePicker = BrowseHeaderCollectionViewController(collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout())
        browsePicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        screenWidth = UIScreen.mainScreen().bounds.width
        
        coverPhoto = UIImageView()
        coverPhoto.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverPhoto.image = UIImage(named: "blurred-header")
        
        artistNameLabel = UILabel()
        artistNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistNameLabel.font = UIFont(name: "Oswald-Light", size: 18.0)
        artistNameLabel.textColor = UIColor(fromHexString: "#d3d3d3")
        artistNameLabel.textAlignment = .Center
        artistNameLabel.text = "FRANK OCEAN"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#f7f7f7")

        addSubview(coverPhoto)
        addSubview(browsePicker.view)
        addSubview(artistNameLabel)
        
        clipsToBounds = true

        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            browsePicker.view.al_top == al_top,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_height == al_height,
            
            coverPhoto.al_top == al_top,
            coverPhoto.al_left == al_left,
            coverPhoto.al_width == al_width,
            coverPhoto.al_height == al_height,
            
            artistNameLabel.al_bottom == al_bottom - 10,
            artistNameLabel.al_centerX == al_centerX
        ])
    }
}

