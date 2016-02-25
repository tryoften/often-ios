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

    func setLayout() {}

}