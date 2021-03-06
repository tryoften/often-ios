//
//  AnimatedLoaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class AnimatedLoaderView: UIView {
    var loaderImageView: UIImageView
    var topPadding: CGFloat = -20.0

    override init(frame: CGRect) {
        loaderImageView = UIImageView(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
        loaderImageView.translatesAutoresizingMaskIntoConstraints = false
        loaderImageView.contentMode = .ScaleAspectFill
        loaderImageView.contentScaleFactor = 2.5
        
        super.init(frame: frame)
        
        backgroundColor = VeryLightGray
        
        addSubview(loaderImageView)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            loaderImageView.al_centerX == al_centerX,
            loaderImageView.al_centerY == al_centerY + topPadding,

            loaderImageView.al_width == 80,
            loaderImageView.al_height == 80
        ])
    }
}
