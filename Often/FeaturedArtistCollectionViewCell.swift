//
//  FeaturedArtistCollectionViewCell.swift
//  Often
//
//  Created by Kervins Valcourt on 1/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class FeaturedArtistCollectionViewCell: UICollectionViewCell {
    var featureLabel: UILabel
    var tintView: UIImageView
    var titleLabel: UILabel
    var imageView: UIImageView

    static var preferredSize: CGSize {
        return CGSizeMake(
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height / 3.33 - 10
        )
    }

    override init(frame: CGRect) {
        tintView = UIImageView()
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.userInteractionEnabled = false
        tintView.image = UIImage(named: "tintGradient")!

        featureLabel = UILabel()
        featureLabel.textAlignment = .Center
        featureLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        featureLabel.textColor = TrendingHeaderViewNameLabelTextColor
        featureLabel.translatesAutoresizingMaskIntoConstraints = false
        featureLabel.alpha = 0.74

        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        titleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView = UIImageView()
        imageView.backgroundColor = ArtistCollectionViewImageViewBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true

        super.init(frame: frame)

        backgroundColor = TrendingHeaderViewBackgroundColor
        clipsToBounds = true

        addSubview(imageView)
        addSubview(tintView)
        addSubview(featureLabel)
        addSubview(titleLabel)

        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setLayout() {
        addConstraints([
            featureLabel.al_right == al_right - 20,
            featureLabel.al_left == al_left + 20,
            featureLabel.al_top == titleLabel.al_bottom + 4,

            titleLabel.al_centerY == al_centerY - 9,
            titleLabel.al_right == al_right - 20,
            titleLabel.al_left == al_left + 20,
            titleLabel.al_height == 20,
            titleLabel.al_centerX == al_centerX,

            tintView.al_right == al_right,
            tintView.al_left == al_left,
            tintView.al_top == al_top,
            tintView.al_bottom == al_bottom,

            imageView.al_right == al_right,
            imageView.al_left == al_left,
            imageView.al_top == al_top,
            imageView.al_bottom == al_bottom
            ])
    }
}
