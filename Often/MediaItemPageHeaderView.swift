//
//  MediaItemPageHeaderView.swift
//  Often
//
//  Created by Luc Succes on 1/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class MediaItemPageHeaderView: UICollectionReusableView {
    var screenWidth: CGFloat
    var coverPhoto: UIImageView
    var coverPhotoTintView: UIView
    var titleLabel: UILabel
    var subtitleLabel: UILabel

    var imageURL: URL? {
        willSet(newValue) {
            if let url = newValue where imageURL != newValue {
                coverPhoto.nk_setImageWith(url)
            }
        }
    }

    var mediaItem: MediaItem?

    var title: String = "" {
        didSet {
            titleLabel.attributedText = AttributedString(string: title.uppercased(), attributes: [
                NSKernAttributeName: NSNumber(value: 1.7),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ])
        }
    }

    var subtitle: String = "" {
        didSet {
            subtitleLabel.attributedText = AttributedString(string: subtitle, attributes: [
                NSKernAttributeName: NSNumber(value: 0.6),
                NSFontAttributeName: UIFont(name: "OpenSans", size: 12)!,
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ])
        }
    }

    override init(frame: CGRect) {
        screenWidth = UIScreen.main().bounds.width

        coverPhoto = UIImageView()
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.contentMode = .scaleAspectFill

        coverPhotoTintView = UIView()
        coverPhotoTintView.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoTintView.backgroundColor = AddArtistModalCollectionModalMainViewBackgroundColor

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        titleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        
        subtitleLabel = UILabel()
        subtitleLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        subtitleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
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
