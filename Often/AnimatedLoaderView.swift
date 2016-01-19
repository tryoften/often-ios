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
    var supplementImageView: UIImageView
    
    override init(frame: CGRect) {
        loaderImageView = UIImageView(image: UIImage.animatedImageNamed("oftenloader", duration: 1.1))
        loaderImageView.translatesAutoresizingMaskIntoConstraints = false
        loaderImageView.contentMode = .ScaleAspectFill
        loaderImageView.contentScaleFactor = 2.5
        
        supplementImageView = UIImageView()
        supplementImageView.translatesAutoresizingMaskIntoConstraints = false
        supplementImageView.contentMode = .ScaleAspectFit
        supplementImageView.image = UIImage(named: "poweredbygenius")
        
        super.init(frame: frame)
        
        backgroundColor = VeryLightGray
        
        addSubview(loaderImageView)
        addSubview(supplementImageView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            loaderImageView.al_centerX == al_centerX,
            loaderImageView.al_centerY == al_centerY - 20,
            loaderImageView.al_width == 80,
            loaderImageView.al_height == 80,
            
            supplementImageView.al_centerX == al_centerX,
            supplementImageView.al_bottom == al_bottom - 60,
            supplementImageView.al_width == 50,
            supplementImageView.al_height == 35
        ])
    }
}
