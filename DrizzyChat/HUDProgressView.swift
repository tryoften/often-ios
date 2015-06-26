//
//  HUDProgressView.swift
//  Drizzy
//
//  Created by Luc Succes on 6/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class HUDProgressView: PKHUDImageView {
    
    class func show() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    class func hide() {
        PKHUD.sharedHUD.hide()
    }
    
    convenience init() {
        self.init(image: UIImage.animatedImageNamed("october-loader-greyscale-", duration: 1.1))
    }

    override init(image: UIImage?) {
        super.init(image: image)
        
        imageView.contentMode = .ScaleAspectFill
        imageView.alpha = 1.0
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        setupLayout()
    }

    internal required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func setupLayout() {
        addConstraints([
            imageView.al_width == 150,
            imageView.al_height == 150,
            imageView.al_centerX == al_centerX,
            imageView.al_centerY == al_centerY
        ])
    }
}
