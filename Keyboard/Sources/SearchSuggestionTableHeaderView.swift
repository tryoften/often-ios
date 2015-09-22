//
//  SearchSuggestionTableHeaderView.swift
//  Often
//
//  Created by Luc Succes on 9/2/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchSuggestionTableHeaderView: UIView {
    var titleLabel: UILabel
    var title: String

    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        title = "top searches"
        
        super.init(frame: frame)
        
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 8)!
        ]
        let attributedString = NSAttributedString(string: title.uppercaseString, attributes: attributes)
        titleLabel.attributedText = attributedString
        
        addSubview(titleLabel)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == al_left + 10,
            titleLabel.al_height == al_height,
            titleLabel.al_top == al_top
        ])
    }
}
