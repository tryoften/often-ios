//
//  PackPageHeaderView.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackPageHeaderView: MediaItemPageHeaderView {
    var primaryButton: BrowsePackDownloadButton
    var tabContainerView: FilterTabView

    private var tabContainerViewHeight: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 50
        }
        return 45
    }
    
    override init(frame: CGRect) {
        tabContainerView = FilterTabView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false
        tabContainerView.leftTabButtonTitle = "Gifs"
        tabContainerView.rightTabButtonTitle = "Quotes"

        primaryButton = BrowsePackDownloadButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        subtitleLabel.numberOfLines = 2

        addSubview(primaryButton)
        addSubview(tabContainerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness

            UIView.beginAnimations("", context: nil)

            if progressiveness <= 0.58 {
                self.subtitleLabel.alpha = 0
                self.primaryButton.alpha = 0
            } else {
                self.subtitleLabel.alpha = 1
                self.primaryButton.alpha = 1
            }

            UIView.commitAnimations()
        }
    }
    
    override func setupLayout() {
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
            titleLabel.al_centerY == al_centerY - 40,
            titleLabel.al_top >= al_top + 30,
            titleLabel.al_height == 22,
            titleLabel.al_width <= al_width - 30,

            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_left == al_left + 50,
            subtitleLabel.al_right == al_right - 50,
            subtitleLabel.al_top  == titleLabel.al_bottom,
            subtitleLabel.al_height == 60,

            primaryButton.al_centerX == al_centerX,
            primaryButton.al_top == subtitleLabel.al_bottom + 5,
            primaryButton.al_height == 30,

            tabContainerView.al_bottom == al_bottom,
            tabContainerView.al_left == al_left,
            tabContainerView.al_right == al_right,
            tabContainerView.al_height == tabContainerViewHeight
        ])
    }
}