//
//  NoResultsEmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class NoResultsEmptyStateView: EmptyStateView {
    init() {
        let title = "Oh snap, our bad"
        let description = "Something went wrong with your search"
        let image = UIImage(named: "noresultsemptystate")!
        
        super.init(state: .noResults)
        
        primaryButton.removeFromSuperview()
        
        primaryButton = UIButton()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        primaryButton.clipsToBounds = true
        primaryButton.layer.cornerRadius = 20
        primaryButton.backgroundColor = TealColor
        primaryButton.setTitle("try again".uppercased(), for: UIControlState())
        primaryButton.isHidden = false
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFill
        imageSize = .medium

        imageViewTopPadding = 30.0
        
        addSubview(primaryButton)
        
        addAdditionalLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = -(imageViewTopPadding + 14)
        
        addConstraints([
            primaryButton.al_centerX == al_centerX,
            primaryButton.al_top == descriptionLabel.al_bottom + 20,
            primaryButton.al_left == al_centerX - 90,
            primaryButton.al_right == al_centerX + 90,
            primaryButton.al_height == 40
        ])
        
        layoutIfNeeded()
    }
}
