//
//  AutocorrectSuggestionView.swift
//  Often
//
//  Created by Luc Succes on 11/10/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class AutocorrectSuggestionView: UIButton {
    var suggestion: SuggestItem
    var textLabel: UILabel
    
    init(suggestion: SuggestItem) {
        self.suggestion = suggestion
        textLabel = UILabel()
        textLabel.textAlignment = .Center
        textLabel.textColor = LightBlackColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if suggestion.isInput {
            textLabel.text = "\"\(suggestion.term)\""
            textLabel.font = UIFont(name: "OpenSans-Semibold", size: 14)
        } else {
            textLabel.text = suggestion.term
            textLabel.font = UIFont(name: "OpenSans", size: 14)
        }
        
        super.init(frame: CGRectZero)
        
        addSubview(textLabel)
        backgroundColor = WhiteColor
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.17
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowRadius = 2.0
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            textLabel.al_centerX == al_centerX,
            textLabel.al_centerY == al_centerY,
            textLabel.al_width <= al_width
        ])
    }
}
