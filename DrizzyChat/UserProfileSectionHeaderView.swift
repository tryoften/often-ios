//
//  UserProfileSectionHeaderView.swift
//  Drizzy
//
//  Created by Luc Success on 5/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileSectionHeaderView: UICollectionReusableView {
    var seperatorView: UIView
    var titleLabel: UILabel
    var editButton: UIButton
    
    override init(frame: CGRect) {
        seperatorView = UIView()
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        seperatorView.backgroundColor = UIColor(fromHexString: "#f1f1f1")
        
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = "Keyboards".uppercaseString
        titleLabel.font = MediumRegularFont
        
        editButton = UIButton()
        editButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        editButton.setTitle("Edit".uppercaseString, forState: .Normal)
        editButton.setTitleColor(UIColor(fromHexString: "#868686"), forState: .Normal)
        editButton.titleLabel!.font = MediumRegularFont
        editButton.titleLabel?.textAlignment = .Right
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(seperatorView)
        addSubview(titleLabel)
        addSubview(editButton)
        
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            seperatorView.al_height == 1,
            seperatorView.al_width == al_width,
            seperatorView.al_left == al_left,
            seperatorView.al_top == al_top,
            
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_width == al_width / 2,
            titleLabel.al_left == al_left + 10,
            
            editButton.al_right == al_right - 10,
            editButton.al_centerY == al_centerY
            ])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}