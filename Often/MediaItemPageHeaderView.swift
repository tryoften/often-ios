//
//  MediaItemPageHeaderView.swift
//  Often
//
//  Created by Luc Succes on 1/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

//
//  AddArtistModalHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class MediaItemPageHeaderView: UICollectionReusableView {
    var screenWidth: CGFloat
    var coverPhoto: UIImageView
    var coverPhotoTintView: UIView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var imageURL: NSURL? {
        willSet(newValue) {
            if let url = newValue where imageURL != newValue {
                coverPhoto.setImageWithAnimation(url)
            }
        }
    }
    var mediaItem: MediaItem? {
        didSet {

        }
    }

    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width

        coverPhoto = UIImageView()
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.contentMode = .ScaleAspectFill

        coverPhotoTintView = UIView()
        coverPhotoTintView.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoTintView.backgroundColor = AddArtistModalCollectionModalMainViewBackgroundColor

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        titleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        titleLabel.lineBreakMode = .ByTruncatingTail
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        subtitleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.74

        super.init(frame: frame)
        
        subtitleLabel.numberOfLines = 2

        backgroundColor = AddArtistModalHeaderViewBackgroundColor

        addSubview(coverPhoto)
        addSubview(coverPhotoTintView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        clipsToBounds = true
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {

        addConstraints([
            coverPhoto.al_top == al_top,
            coverPhoto.al_left == al_left,
            coverPhoto.al_width == al_width,
            coverPhoto.al_height == al_height,

            coverPhotoTintView.al_width == coverPhoto.al_width,
            coverPhotoTintView.al_height == coverPhoto.al_height,
            coverPhotoTintView.al_left == coverPhoto.al_left,
            coverPhotoTintView.al_top == coverPhoto.al_top,

            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_top >= al_top + 30,
            titleLabel.al_height == 22,
            titleLabel.al_width <= al_width - 30,

            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top  == titleLabel.al_bottom + 5
        ])
    }
}
