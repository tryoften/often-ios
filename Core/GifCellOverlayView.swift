//
//  GifCellOverlayView.swift
//  Often
//
//  Created by Katelyn Findlay on 4/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Spring

class GifCellOverlayView : UIView {
    let loaderView: UIImageView
    let primaryTextLabel: UILabel
    
    override init(frame: CGRect) {
        primaryTextLabel = UILabel()
        primaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryTextLabel.textAlignment = .Center
        primaryTextLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 10.0)!,
                                     letterSpacing: 1.0,
                                     color: BlackColor,
                                     text: "Copied!".uppercaseString)

        loaderView = UIImageView(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)

        addSubview(loaderView)
        addSubview(primaryTextLabel)

        setupLayout()
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            primaryTextLabel.al_left == al_left,
            primaryTextLabel.al_right == al_right,
            primaryTextLabel.al_centerY == al_centerY,

            loaderView.al_centerY == al_centerY,
            loaderView.al_centerX == al_centerX,
            loaderView.al_width == 40,
            loaderView.al_height == 40
        ])
    }

    func reset() {
        loaderView.alpha = 0
        primaryTextLabel.alpha = 0
    }

    func startLoader() {
        reset()
        UIView.animateWithDuration(0.3) {
            self.loaderView.alpha = 1.0
        }
    }

    func showSuccessMessage() {
        UIView.animateWithDuration(0.3) {
            self.loaderView.alpha = 0
            self.primaryTextLabel.alpha = 1.0
        }
    }
}
