//
//  KeyboardMediaItemPackHeaderView.swift
//  Often
//
//  Created by Kervins Valcourt on 3/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardMediaItemPackHeaderView: UICollectionViewCell {
    var recentButton: UIButton
    var addPacks: UIButton

    override init(frame: CGRect) {

        recentButton = UIButton()
        recentButton.setTitle("recents".uppercaseString, forState: .Normal)

        addPacks = UIButton()
        addPacks.setTitle("+ add packs".uppercaseString, forState: .Normal)

        super.init(frame: frame)
        backgroundColor = ClearColor

        for button in [addPacks] {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel!.font = UIFont(name: "Montserrat", size: 12)
            button.setTitleColor(BlackColor , forState: .Normal)
            button.backgroundColor = WhiteColor
            button.layer.shadowOffset = CGSizeMake(0, 1)
            button.layer.shadowRadius = 2
            button.layer.cornerRadius = 2
            button.layer.shadowColor = UIColor.blackColor().CGColor
            button.layer.shadowOpacity = 0.14
            button.layer.shadowRadius = 1

            addSubview(button)
        }

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            addPacks.al_top == al_top,
            addPacks.al_left == al_left,
            addPacks.al_right == al_right,
            addPacks.al_bottom == al_bottom
        ])
    }

}