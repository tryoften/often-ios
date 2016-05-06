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
        let title = "You forgot to install the keyboard"
        let description = "Remember to allow full access! Trust us fam"
        let image = UIImage(named: "installoftenemptystate")!
        
        super.init(state: .NoKeyboard)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .ScaleAspectFill
        imageSize = .Large
        
        primaryButton.backgroundColor = TealColor
        primaryButton.setTitleColor(WhiteColor , forState: .Normal)
        primaryButton.setTitle("go to settings".uppercaseString, forState: .Normal)
        primaryButton.hidden = false
        primaryButton.userInteractionEnabled = true
        
        addAdditionalLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayouts() {
        imageViewTopConstraint?.constant = -(imageViewTopPadding + 80)
        layoutIfNeeded()
    }
}
