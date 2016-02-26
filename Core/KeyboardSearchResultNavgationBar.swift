//
//  KeyboardSearchResultNavgationBar.swift
//  Often
//
//  Created by Kervins Valcourt on 2/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardSearchResultNavgationBar: SearchResultNavigationBar {
    override func setLayout() {
        addConstraints([
            searchIcon.al_centerY == titleLabel.al_centerY,
            searchIcon.al_left == al_left + 18,
            searchIcon.al_height == 20,
            searchIcon.al_width == 20,

            titleLabel.al_top == al_top + 11,
            titleLabel.al_left == searchIcon.al_right + 10,
            titleLabel.al_bottom == al_bottom - 18,
            titleLabel.al_right == doneButton.al_left,
            titleLabel.al_height == 17,

            doneButton.al_top == al_top,
            doneButton.al_left == titleLabel.al_right,
            doneButton.al_bottom == al_bottom,
            doneButton.al_right == al_right - 18,
            
            ])
    }
}