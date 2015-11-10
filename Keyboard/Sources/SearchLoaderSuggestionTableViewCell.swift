//
//  SearchLoaderSuggestionTableViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 11/10/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchLoaderSuggestionTableViewCell: UITableViewCell {
    var loadBar: UIView
    var loadBarLengthConstraint: NSLayoutConstraint?
    var short: Bool {
        didSet(value) {
            if value == false {
                loadBarLengthConstraint?.constant = 20
            } else {
                loadBarLengthConstraint?.constant = -20
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        loadBar = UIView()
        loadBar.translatesAutoresizingMaskIntoConstraints = false
        loadBar.backgroundColor = LightGrey
        
        short = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ClearColor
        
        addSubview(loadBar)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupLayout() {
        loadBarLengthConstraint = loadBar.al_right == al_centerX - 20
        
        addConstraints([
            loadBarLengthConstraint!,
            loadBar.al_left == al_left + 20,
            loadBar.al_centerY == al_centerY,
            loadBar.al_height == 4
        ])
    }
}

