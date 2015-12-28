//
//  AlbumCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 12/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {
    var albumCoverThumbnail: UIImageView
    var albumTitleLabel: UILabel
    var artistLabel: UILabel
    var disclosureIndicator: UIImageView
    
    
    override init(frame: CGRect) {
        albumCoverThumbnail = UIImageView()
        albumCoverThumbnail.translatesAutoresizingMaskIntoConstraints = false
        albumCoverThumbnail.contentMode = .ScaleAspectFill
        albumCoverThumbnail.layer.cornerRadius = 3.0
        
        albumTitleLabel = UILabel()
        albumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        albumTitleLabel.font = UIFont(name: "OpenSans", size: 14.0)
        
        artistLabel = UILabel()
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.font = UIFont(name: "OpenSans", size: 11.0)
        artistLabel.textColor = BlackColor
        artistLabel.alpha = 0.54
        
        disclosureIndicator = UIImageView()
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator.contentMode = .ScaleAspectFit
        disclosureIndicator.image = UIImage(named: "next")
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.14
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowRadius = 1
        
        contentView.layer.cornerRadius = 2.0
        contentView.clipsToBounds = true
        
        addSubview(albumCoverThumbnail)
        addSubview(albumTitleLabel)
        addSubview(artistLabel)
        addSubview(disclosureIndicator)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            albumCoverThumbnail.al_left == al_left + 10,
            albumCoverThumbnail.al_centerY == al_centerY,
            albumCoverThumbnail.al_top == al_top + 12,
            albumCoverThumbnail.al_bottom == al_bottom - 12,
            albumCoverThumbnail.al_width == albumCoverThumbnail.al_height,
            
            albumTitleLabel.al_left == albumCoverThumbnail.al_right + 10,
            albumTitleLabel.al_bottom == albumCoverThumbnail.al_centerY,
        
            artistLabel.al_left == albumTitleLabel.al_left,
            artistLabel.al_top == albumCoverThumbnail.al_centerY,
            
            disclosureIndicator.al_centerY == al_centerY,
            disclosureIndicator.al_right == al_right - 15,
            disclosureIndicator.al_height == 16.5,
            disclosureIndicator.al_width == 16.5
        ])
    }
}
