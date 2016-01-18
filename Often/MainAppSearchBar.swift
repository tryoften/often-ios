//
//  MainAppSearchBar.swift
//  Often
//
//  Created by Kervins Valcourt on 12/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class MainAppSearchBar: UISearchBar, SearchBar {
    var selected: Bool
    
    required override init(frame: CGRect) {
        selected = false
        super.init(frame: frame)

        styleSearchBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        clear()
        placeholder = SearchBarPlaceholderText
    }

    func clear() {
        text = ""
    }

    func styleSearchBar() {
        let attributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "Montserrat", size: 11)!,
            NSForegroundColorAttributeName: BlackColor
        ]

        searchBarStyle = .Minimal
        backgroundColor = UIColor.clearColor()
        tintColor = UIColor(fromHexString: "#14E09E")
        placeholder = SearchBarPlaceholderText
        setValue("cancel".uppercaseString, forKey:"_cancelButtonText")

        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
    }

}