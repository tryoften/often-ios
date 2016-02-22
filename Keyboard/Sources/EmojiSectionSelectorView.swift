//
//  EmojiSectionSelectorView.swift
//  Often
//
//  Created by Komran Ghahremani on 2/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmojiSectionSelectorView: UIView {
    var natureButton: UIButton
    var objectsButton: UIButton
    var peopleButton: UIButton
    var placesButton: UIButton
    var symbolsButton: UIButton
    var selectedCircle: UIView
    var selectedCircleCenterYConstraint: NSLayoutConstraint?
    var sectionSelectionDelegate: EmojiSectionSelectable?
    
    override init(frame: CGRect) {
        natureButton = UIButton()
        natureButton.translatesAutoresizingMaskIntoConstraints = false
        natureButton.setImage(UIImage(named: "nature"), forState: .Normal)
        natureButton.tag = 0
        
        objectsButton = UIButton()
        objectsButton.translatesAutoresizingMaskIntoConstraints = false
        objectsButton.setImage(UIImage(named: "confetti"), forState: .Normal)
        objectsButton.tag = 1
        
        peopleButton = UIButton()
        peopleButton.translatesAutoresizingMaskIntoConstraints = false
        peopleButton.setImage(UIImage(named: "people"), forState: .Normal)
        peopleButton.tag = 2
        
        placesButton = UIButton()
        placesButton.translatesAutoresizingMaskIntoConstraints = false
        placesButton.setImage(UIImage(named: "building & cars"), forState: .Normal)
        placesButton.tag = 3
        
        symbolsButton = UIButton()
        symbolsButton.translatesAutoresizingMaskIntoConstraints = false
        symbolsButton.setImage(UIImage(named: "random"), forState: .Normal)
        symbolsButton.tag = 4
        
        selectedCircle = UIView()
        selectedCircle.translatesAutoresizingMaskIntoConstraints = false
        selectedCircle.backgroundColor = LightGrey
        selectedCircle.layer.cornerRadius = 12.5
        
        super.init(frame: frame)
        
        natureButton.addTarget(self, action: "sectionSelected:", forControlEvents: .TouchUpInside)
        objectsButton.addTarget(self, action: "sectionSelected:", forControlEvents: .TouchUpInside)
        peopleButton.addTarget(self, action: "sectionSelected:", forControlEvents: .TouchUpInside)
        placesButton.addTarget(self, action: "sectionSelected:", forControlEvents: .TouchUpInside)
        symbolsButton.addTarget(self, action: "sectionSelected:", forControlEvents: .TouchUpInside)
        
        backgroundColor = WhiteColor
        
        addSubview(selectedCircle)
        addSubview(natureButton)
        addSubview(objectsButton)
        addSubview(peopleButton)
        addSubview(placesButton)
        addSubview(symbolsButton)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sectionSelected(sender: UIButton) {
        let section = sender.tag
        
        switch section {
        case 0:
            selectedCircleCenterYConstraint?.constant = -80
        case 1:
            selectedCircleCenterYConstraint?.constant = -40
        case 2:
            selectedCircleCenterYConstraint?.constant = 0
        case 3:
            selectedCircleCenterYConstraint?.constant = 40
        case 4:
            selectedCircleCenterYConstraint?.constant = 80
        default:
            break
        }
        
        layoutIfNeeded()
        sectionSelectionDelegate?.scrollToEmojiSection(section)
    }
    
    func setupLayout() {
        selectedCircleCenterYConstraint = selectedCircle.al_centerY == al_centerY - 80
        
        addConstraints([
            natureButton.al_centerX == al_centerX,
            natureButton.al_centerY == al_centerY - 80,
            natureButton.al_height == 15,
            natureButton.al_width == 15,
            
            objectsButton.al_centerX == al_centerX,
            objectsButton.al_centerY == al_centerY - 40,
            objectsButton.al_height == 15,
            objectsButton.al_width == 15,
            
            peopleButton.al_centerX == al_centerX,
            peopleButton.al_centerY == al_centerY,
            peopleButton.al_height == 15,
            peopleButton.al_width == 15,
            
            placesButton.al_centerX == al_centerX,
            placesButton.al_centerY == al_centerY + 40,
            placesButton.al_height == 15,
            placesButton.al_width == 15,
            
            symbolsButton.al_centerX == al_centerX,
            symbolsButton.al_centerY == al_centerY + 80,
            symbolsButton.al_height == 15,
            symbolsButton.al_width == 15,
            
            selectedCircle.al_height == 25,
            selectedCircle.al_width == 25,
            selectedCircle.al_centerX == al_centerX,
            selectedCircleCenterYConstraint!
        ])
    }
}

protocol EmojiSectionSelectable {
    func scrollToEmojiSection(section: Int)
}
