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
    var topLabel: UILabel
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

        titleLabel = TOMSMorphingLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        titleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        titleLabel.textAlignment = .Center

        subtitleLabel = TOMSMorphingLabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        subtitleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        subtitleLabel.textAlignment = .Center

        topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .Center
        topLabel.font = AddArtistModalCollectionTopLabelFont
        topLabel.textColor = AddArtistModalCollectionBackgroundColor
        topLabel.alpha = 0

        super.init(frame: frame)

        backgroundColor = AddArtistModalHeaderViewBackgroundColor

        addSubview(coverPhoto)
        addSubview(coverPhotoTintView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(topLabel)

        clipsToBounds = true
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            topLabel.al_top == al_top + 10,
            topLabel.al_centerX == al_centerX,

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

            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top  == titleLabel.al_bottom
        ])
    }
}
