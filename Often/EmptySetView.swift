//
//  EmptySetView.swift
//  Often
//
//  Created by Komran Ghahremani on 9/30/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class EmptySetView: UIView {
    var imageView: UIImageView
    var titleLabel: UILabel
    var descriptionLabel: UILabel
    var button: UIButton
    var delegate: EmptySetDelegate?
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.textColor = UIColor(fromHexString: "#202020")
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(button)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY + 50,
            
            imageView.al_centerX == al_centerX,
            imageView.al_bottom == titleLabel.al_top - 10,
            
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_top == titleLabel.al_bottom + 5,
            
            button.al_centerX == al_centerX,
            button.al_top == descriptionLabel.al_bottom + 5
        ])
    }
}

protocol EmptySetDelegate {
    func updateEmptySetVisible(visible: Bool)
}