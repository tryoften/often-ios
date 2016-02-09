//
//  EmojiSectionHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 2/5/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmojiSectionHeaderView: UITableViewHeaderFooterView {
    var titleLabel: UILabel
    
    override init(reuseIdentifier: String?) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Nature"
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        titleLabel.textColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 0.54)
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = WhiteColor
        
        addSubview(titleLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == al_left + 15,
            titleLabel.al_right == al_right,
            titleLabel.al_top == al_top,
            titleLabel.al_bottom == al_bottom
        ])
    }
}


