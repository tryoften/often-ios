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
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(frame: frame)
        
        addSubview(facebookButton)
        addSubview(nameLabel)
        setupLayout()
    }
    
    
    func setupLayout() {
        addConstraints([
            
        ])
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
}
