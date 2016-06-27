//
//  RecentsEmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class RecentsEmptyStateView: EmptyStateView {
    init() {
        let title = "Go hit the squad with packs"
        let description = "See all your recently shared lyrics here"
        let image = UIImage(named: "recentsemptystate")!
        
        super.init(state: .noRecents)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFill
        imageSize = .medium
        
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
