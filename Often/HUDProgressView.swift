//
//  HUDProgressView.swift
//  Often
//
//  Created by Kervins Valcourt on 10/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class HUDProgressView: PKHUDImageView {
    
    class func show() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    class func hide() {
        PKHUD.sharedHUD.hide()
    }
    
    convenience init() {
        self.init(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        imageView.contentMode = .ScaleAspectFill
        imageView.alpha = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }
    
    internal required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func setupLayout() {
        addConstraints([
            imageView.al_width == 85,
            imageView.al_height == 85,
            imageView.al_centerX == al_centerX,
            imageView.al_centerY == al_centerY
            ])
    }
}
