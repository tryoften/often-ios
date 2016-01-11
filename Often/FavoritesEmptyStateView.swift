//
//  FavoritesEmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class FavoritesEmptyStateView: EmptyStateView {
    init() {
        let title = "Show these lyrics some love"
        let description = "Tap any lyric to start adding favorites"
        let image = UIImage(named: "favoritesemptystate")!
        
        super.init(frame: CGRectZero)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .ScaleAspectFill
        imageSize = .Medium
        
        addAdditionalLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = -(imageViewTopPadding + 35)
        layoutIfNeeded()
    }
}
