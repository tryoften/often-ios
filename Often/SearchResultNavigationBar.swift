//
//  SearchResultNavigationBar.swift
//  Often
//
//  Created by Kervins Valcourt on 2/24/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SearchResultNavigationBar: UIView {
    var searchIcon: UIImageView
    var titleLabel: UILabel
    var doneButton: UIButton

    override init(frame: CGRect) {
        searchIcon = UIImageView()
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.image = StyleKit.imageOfSearchbaricon(scale: 0.90)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 12)
        titleLabel.textAlignment = .Left
        titleLabel.text = "Kendrick Lamar"

        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("done".uppercaseString, forState: .Normal)
        doneButton.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)
        doneButton.setTitleColor(BlackColor , forState: .Normal)
        doneButton.backgroundColor = WhiteColor

        super.init(frame: frame)

        backgroundColor = WhiteColor

        addSubview(searchIcon)
        addSubview(titleLabel)
        addSubview(doneButton)

        setLayout()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {
        addConstraints([
            searchIcon.al_centerY == titleLabel.al_centerY,
            searchIcon.al_left == al_left + 18,
            searchIcon.al_height == 20,
            searchIcon.al_width == 20,

            titleLabel.al_top == al_top + 35,
            titleLabel.al_left == searchIcon.al_right + 10,
            titleLabel.al_bottom == al_bottom - 18,
            titleLabel.al_right == doneButton.al_left,
            titleLabel.al_height == 17,

            doneButton.al_top == al_top + 35,
            doneButton.al_left == titleLabel.al_right,
            doneButton.al_bottom == al_bottom - 18,
            doneButton.al_right == al_right - 18,

            ])
    }

}