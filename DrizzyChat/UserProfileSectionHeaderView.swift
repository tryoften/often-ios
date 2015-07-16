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
        seperatorView.backgroundColor = UserProfileSectionHeaderViewSeperatorViewBackgroundColor
        
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let headerText = "Cards".uppercaseString
        let range = NSRange(location: 0, length: count(headerText))
        let attributedString = NSMutableAttributedString(string: headerText)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.2), range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UserProfileSectionHeaderViewTitleLabelFont!, range: range)
        
        titleLabel.attributedText = attributedString
        
        editButton = UIButton()
        editButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        editButton.setTitle("Edit".uppercaseString, forState: .Normal)
        editButton.setTitleColor(UserProfileSectionHeaderViewEditButtonFontColor, forState: .Normal)
        editButton.titleLabel!.font = UserProfileSectionHeaderViewEditButtonFont
        editButton.titleLabel?.textAlignment = .Right
        
        super.init(frame: frame)

        backgroundColor = WhiteColor
        addSubview(seperatorView)
        addSubview(titleLabel)
        
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
            titleLabel.al_left == al_left + 15
        ])
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}