//
//  SearchBarView.swift
//  Often
//
//  Created by Kervins Valcourt on 7/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SearchBarView: UIView {
    var textField: UITextField
    var searchButton: UIButton

    override init(frame: CGRect) {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search GIPHY…"
        textField.clearButtonMode = .WhileEditing

        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(StyleKit.imageOfSearchtab(), forState: .Normal)

        super.init(frame: frame)

        addSubview(textField)
        addSubview(searchButton)

        layer.cornerRadius = 2.5
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.2
        layer.shadowColor = MediumLightGrey.CGColor
        layer.shadowOffset = CGSizeMake(0, 1)
        backgroundColor = UIColor.oftWhiteColor()

        setupLayout()
    }

    func setupLayout() {
        addConstraints([
            textField.al_left == al_left + 17.5,
            textField.al_top == al_top,
            textField.al_bottom == al_bottom,
            textField.al_right == searchButton.al_left - 10,

            searchButton.al_bottom == al_bottom,
            searchButton.al_top == al_top,
            searchButton.al_right == al_right,
            searchButton.al_width == 44
            ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}