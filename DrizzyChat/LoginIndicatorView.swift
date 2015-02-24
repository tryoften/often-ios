//
//  LoginIndicatorView.swift
//  Drizzy
//
//  Created by Luc Success on 2/18/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class LoginIndicatorView: UIView {
    var facebookButton: FacebookButton
    var nameLabel: UILabel
    
    override init(frame: CGRect) {
        facebookButton = FacebookButton.button()
        facebookButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        facebookButton.hidden = true
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.font = UIFont(name: "Lato-Regular", size: 16)
        nameLabel.textAlignment = .Center

        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(facebookButton)
        addSubview(nameLabel)
        setupLayout()
    }
    
    
    func setupLayout() {
        addConstraints([
            nameLabel.al_width == al_width,
            nameLabel.al_height == al_height,
            nameLabel.al_top == al_top,
            nameLabel.al_left == al_left,
            
            facebookButton.al_top == al_top + 10,
            facebookButton.al_bottom == al_bottom - 10,
            facebookButton.al_left == al_left + 10,
            facebookButton.al_right == al_right - 10
        ])
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
}
