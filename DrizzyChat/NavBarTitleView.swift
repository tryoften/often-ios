//
//  NavBarTitleView.swift
//  October
//
//  Created by Kervins Valcourt on 7/6/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

class NavBarTitleView: UIView {
    var navBarTitle: UILabel
    
    override init(frame: CGRect) {
        navBarTitle = UILabel()
        navBarTitle.font = UIFont(name: "OpenSans-Semibold", size: 18)
        navBarTitle.textColor = UIColor.whiteColor()
        navBarTitle.textAlignment = .Center
        navBarTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        addSubview(navBarTitle)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            navBarTitle.al_top == al_top ,
            navBarTitle.al_left == al_left,
            navBarTitle.al_right == al_right,
            navBarTitle.al_bottom == al_bottom
            ])
    }
}