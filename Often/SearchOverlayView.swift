//
//  SearchOverlayView.swift
//  Often
//
//  Created by Kervins Valcourt on 7/21/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SearchOverlayView: UIView {
    let overlayView: UIImageView

    override init(frame: CGRect) {
        overlayView = UIImageView(image: StyleKit.imageOfCheckicon(color: UIColor.oftWhiteColor()))
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        addSubview(overlayView)

        setupLayout()
        backgroundColor = UIColor.oftGreenblueColor().colorWithAlphaComponent(0.8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            overlayView.al_centerY == al_centerY,
            overlayView.al_centerX == al_centerX,
            overlayView.al_width == 60,
            overlayView.al_height == 60
            ])
    }
}