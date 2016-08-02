//
//  UserProfileSectionHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileSectionHeaderView: UICollectionReusableView {
    var titleLabel: UILabel
    var editButton: UIButton
    var borderView: UIView
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        titleLabel.textColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 0.74)
        
        editButton = UIButton()
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        editButton.setTitleColor(UIColor(red: 159.0/255.0, green: 74.0/255.0, blue: 255.0/255.0, alpha: 1.0), forState: .Normal)
        editButton.setTitle("edit".uppercaseString, forState: .Normal)
        editButton.setTitle("done".uppercaseString, forState: .Selected)
        
        borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = MediumGrey
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        addSubview(titleLabel)
        addSubview(editButton)
        addSubview(borderView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == al_left + 12,
            titleLabel.al_centerY == al_centerY,
            
            editButton.al_right == al_right - 12,
            editButton.al_centerY == al_centerY,
            
            borderView.al_left == al_left,
            borderView.al_right == al_right,
            borderView.al_top == al_top,
            borderView.al_height == 0.5
        ])
    }
}