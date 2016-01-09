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
        
        super.init(frame: CGRectZero)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        primaryButton.backgroundColor = TwitterButtonColor
        primaryButton.setTitle("connect twitter".uppercaseString, forState: .Normal)
        primaryButton.hidden = false
        
        closeButton.hidden = false
        closeButton.userInteractionEnabled = true
        
        imageView.contentMode = .ScaleAspectFit
        imageSize = .Small
        
        addAdditionalLayouts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = imageViewTopPadding + 20
        layoutIfNeeded()
    }
}
