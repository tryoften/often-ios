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
        recentButton.setTitle("recents".uppercased(), for: UIControlState())

        addPacks = UIButton()
        addPacks.setTitle("+ add packs".uppercased(), for: UIControlState())

        super.init(frame: frame)
        backgroundColor = ClearColor

        for button in [recentButton, addPacks] {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel!.font = UIFont(name: "Montserrat", size: 12)
            button.setTitleColor(BlackColor , for: UIControlState())
            button.backgroundColor = WhiteColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowRadius = 2
            button.layer.cornerRadius = 2
            button.layer.shadowColor = UIColor.black().cgColor
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
            recentButton.al_top == al_top,
            recentButton.al_left == al_left,
            recentButton.al_right == al_right,
            recentButton.al_height == 96.5,

            addPacks.al_top == recentButton.al_bottom + 6,
            addPacks.al_left == al_left,
            addPacks.al_right == al_right,
            addPacks.al_height == 96.5
            ])
    }

}
