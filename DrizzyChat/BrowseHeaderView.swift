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
    var coverPhoto: UIImageView
    var nameLabel: UILabel
    var addArtistButton: UIButton
    var screenWidth: CGFloat
    var artistBrowseCollectionView: UICollectionView?
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        artistBrowseCollectionView = UICollectionView(frame: CGRectMake(0, 100, screenWidth, 250), collectionViewLayout: ArtistBrowseCollectionViewFlowLayout().provideCollectionFlowLayout())
        artistBrowseCollectionView!.backgroundColor = UIColor.whiteColor()
        artistBrowseCollectionView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistBrowseCollectionView!.registerClass(BrowseHeaderCollectionViewCell.self, forCellWithReuseIdentifier: BrowseHeaderViewCellIdentifier)
        
        coverPhoto = UIImageView()
        coverPhoto.frame = CGRectMake(0, 0, screenWidth, 450)
        coverPhoto.contentMode = .ScaleAspectFill
        coverPhoto.translatesAutoresizingMaskIntoConstraints()
        coverPhoto.clipsToBounds = true
        coverPhoto.image = UIImage(named: "blurred-header")
        
        nameLabel = UILabel()
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: "OpenSans", size: 24.0)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        /// may create own class for this button
        addArtistButton = UIButton()
        addArtistButton.backgroundColor = UIColor.yellowColor()
        addArtistButton.titleLabel?.textAlignment = .Center
        addArtistButton.titleLabel?.text = "Add Artist"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        addSubview(coverPhoto)
        addSubview(nameLabel)
        addSubview(artistBrowseCollectionView!)
        
        setLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            coverPhoto.al_left == al_left
            
        ])
    }
}

