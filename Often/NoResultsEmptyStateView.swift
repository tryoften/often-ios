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
        
        super.init(frame: CGRectZero)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .ScaleAspectFill
        imageSize = .Large
        
        addAdditionalLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = imageViewTopPadding + 14
        layoutIfNeeded()
    }
}
