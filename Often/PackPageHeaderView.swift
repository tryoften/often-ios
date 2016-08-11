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

    private var coverPhotoContainerSize: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 150
        }
        return 175
    }

    private var coverPhotoContainerOffsett: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return tabContainerViewHeight + 0
        }
        return tabContainerViewHeight + 20
    }

    private var titleLabelTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 15
        }
        return 24
    }

    
    override init(frame: CGRect) {
        tabContainerView = FilterTabView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false

        primaryButton = BrowsePackDownloadButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)

//        subtitleLabel.numberOfLines = 2

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
                subtitleLabel.alpha = 0
                primaryButton.alpha = 0
                coverPhotoContainer.alpha = 0
                coverPhoto.alpha = 0
                titleLabel.alpha = 0
                collapseTitleLabel.alpha = 1
            } else {
                titleLabel.alpha = 1
                coverPhoto.alpha = 1
                subtitleLabel.alpha = 1
                coverPhotoContainer.alpha = 1
                primaryButton.alpha = 1
                collapseTitleLabel.alpha = 0
            }

            UIView.commitAnimations()
        }
    }
    
    override func setupLayout() {
        addConstraints([
            collapseTitleLabel.al_top == al_top + 30,
            collapseTitleLabel.al_width <= al_width - 30,
            collapseTitleLabel.al_centerX == al_centerX,
            collapseTitleLabel.al_height == 22,

            packBackgroundColor.al_top == al_top,
            packBackgroundColor.al_left == al_left,
            packBackgroundColor.al_width == al_width,
            packBackgroundColor.al_height == al_height,

            coverPhotoContainer.al_centerX == al_centerX,
            coverPhotoContainer.al_centerY == al_centerY - coverPhotoContainerOffsett,
            coverPhotoContainer.al_width == coverPhotoContainerSize,
            coverPhotoContainer.al_height == coverPhotoContainerSize,

            coverPhoto.al_top == coverPhotoContainer.al_top,
            coverPhoto.al_left == coverPhotoContainer.al_left,
            coverPhoto.al_right == coverPhotoContainer.al_right,
            coverPhoto.al_bottom == coverPhotoContainer.al_bottom,

            titleLabel.al_top == coverPhotoContainer.al_bottom + titleLabelTopMargin,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_height == 22,
            titleLabel.al_width == al_width - 30,

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
            tabContainerView.al_height == tabContainerViewHeight,
        ])
    }
}