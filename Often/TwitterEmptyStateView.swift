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
        let title = "Connect with Twitter or Facebook"
        let description = "Get lyric suggestions & a sweet profile pic"
        let image = UIImage(named: "twitteremptystate")!
        
        super.init(state: .NoTwitter)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        primaryButton.backgroundColor = TwitterButtonColor
        primaryButton.setTitle("connect twitter".uppercaseString, forState: .Normal)
        primaryButton.hidden = false
        
        closeButton.hidden = false
        closeButton.userInteractionEnabled = true
        
        imageView.contentMode = .ScaleAspectFill
        imageSize = .Medium
        
        addAdditionalLayouts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = -(imageViewTopPadding + 70)
        layoutIfNeeded()
    }
}
