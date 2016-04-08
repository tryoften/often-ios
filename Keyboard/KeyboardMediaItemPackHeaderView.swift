//
//  KeyboardMediaItemPackHeaderView.swift
//  Often
//
//  Created by Kervins Valcourt on 3/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardMediaItemPackHeaderView: UICollectionViewCell {
    var favoriteButton: UIButton
    var recentButton: UIButton
    var addPacks: UIButton

    override init(frame: CGRect) {
        favoriteButton = UIButton()
        favoriteButton.setTitle("favorites".uppercaseString, forState: .Normal)

        recentButton = UIButton()
        recentButton.setTitle("recents".uppercaseString, forState: .Normal)

        addPacks = UIButton()
        addPacks.setTitle("add packs".uppercaseString, forState: .Normal)

        super.init(frame: frame)
        backgroundColor = ClearColor

        for button in [favoriteButton, recentButton, addPacks] {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)
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
            favoriteButton.al_top == al_top,
            favoriteButton.al_left == al_left,
            favoriteButton.al_right == al_right,
            favoriteButton.al_height == 66,

            recentButton.al_top == favoriteButton.al_bottom + 6,
            recentButton.al_left == al_left,
            recentButton.al_right == al_right,
            recentButton.al_height == 66,

            addPacks.al_top == recentButton.al_bottom + 6,
            addPacks.al_left == al_left,
            addPacks.al_right == al_right,
            addPacks.al_height == 66
            ])
    }

}