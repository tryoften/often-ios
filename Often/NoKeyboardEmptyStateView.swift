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
        
        super.init(state: .noKeyboard)
        
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFill
        imageSize = .large
        
        primaryButton.backgroundColor = TealColor
        primaryButton.setTitleColor(WhiteColor , for: UIControlState())
        primaryButton.setTitle("go to settings".uppercased(), for: UIControlState())
        primaryButton.isHidden = false
        primaryButton.isUserInteractionEnabled = true
        
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
