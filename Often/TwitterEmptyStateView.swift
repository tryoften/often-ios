//
//  TwitterEmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class TwitterEmptyStateView: EmptyStateView {
    init() {
        let title = "Connect with Twitter"
        let description = "Often works even better with Twitter. \n In the future, any links you like there are saved here."
        let image = UIImage(named: "twitteremptystate")!
        
        super.init(title: title, description: description, image: image)
        
        primaryButton.backgroundColor = TwitterButtonColor
        primaryButton.setTitle("connect twitter".uppercaseString, forState: .Normal)
        
        imageView.contentMode = .ScaleAspectFit
        imageSize = .Small
        
        addAdditionalLayouts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = imageViewTopPadding + 5
        layoutIfNeeded()
    }
}
