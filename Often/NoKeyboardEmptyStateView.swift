//
//  NoKeyboardEmptyStateView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class NoKeyboardEmptyStateView: EmptyStateView {
    init() {
        let title = "Install Often"
        let description = "Remember to install Often in your \nkeyboards settings and allow full-access."
        let image = UIImage(named: "installoftenemptystate")!
        
        super.init(frame: CGRectZero)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .ScaleAspectFill
        imageSize = .Small
        
        primaryButton.backgroundColor = TealColor
        primaryButton.setTitle("go to settings".uppercaseString, forState: .Normal)
        primaryButton.hidden = false
        
        addAdditionalLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = imageViewTopPadding + 7
        layoutIfNeeded()
    }
}
