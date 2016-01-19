//
//  SearchResultsCellOverlayView.swift
//  Often
//
//  Created by Luc Succes on 9/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit
import Spring

class SearchResultsCellOverlayView: UIView {
    
    let insertButton: SpringButton
    let favoriteButton: SpringButton
    let cancelButton: SpringButton
    let doneButton: SpringButton
    let copyButton: SpringButton
    
    let rightLabel: UILabel
    let leftLabel: UILabel
    let middleLabel: UILabel
  
    let backgroundView: UIVisualEffectView
    
    override init(frame: CGRect) {
        insertButton = SpringButton()
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        insertButton.setImage(StyleKit.imageOfInsert(scale: 0.5), forState: .Normal)
        insertButton.setImage(StyleKit.imageOfInsert(scale: 0.5, selected: true), forState: .Selected)
        
        favoriteButton = SpringButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(StyleKit.imageOfFavorite(scale: 0.5), forState: .Normal)
        favoriteButton.setImage(StyleKit.imageOfFavorite(scale: 0.5, favorited: true), forState: .Selected)
        
        cancelButton = SpringButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfCancel(scale: 0.5), forState: .Normal)
        cancelButton.setImage(StyleKit.imageOfCancel(scale: 0.5, selected: true), forState: .Selected)
        
        doneButton = SpringButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setImage(StyleKit.imageOfCheckmark(scale: 0.5), forState: .Normal)
        doneButton.hidden = true
        
        copyButton = SpringButton()
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.setImage(StyleKit.imageOfClipboard(scale: 0.5), forState: .Normal)
        copyButton.setImage(StyleKit.imageOfClipboard(scale: 0.5, selected: true), forState: .Selected)
        copyButton.hidden = true
        

        let labelFont = UIFont(name: "Montserrat-Regular", size: 10)
        
        rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.font = labelFont
        rightLabel.text = "Share".uppercaseString
        rightLabel.alpha = 0.74
        
        leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.font = labelFont
        leftLabel.text = "Favorite".uppercaseString
        leftLabel.alpha = 0.74
        
        middleLabel = UILabel()
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        middleLabel.font = labelFont
        middleLabel.text = "Cancel".uppercaseString
        middleLabel.alpha = 0.74
        
        backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(insertButton)
        addSubview(favoriteButton)
        addSubview(cancelButton)
        addSubview(doneButton)
        addSubview(copyButton)
        
        addSubview(rightLabel)
        addSubview(leftLabel)
        addSubview(middleLabel)
      
        setupLayout()
        
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showButtons(completion: () -> ()) {
        func setupAnimation(button: SpringButton) {
            button.animation = "slideUp"
            button.duration = 0.3
            button.curve = "easeIn"
        }
        
        for button in [favoriteButton, cancelButton, insertButton] {
            button.selected = false
        }

        setupAnimation(favoriteButton)
        favoriteButton.animate()
        
        setupAnimation(cancelButton)
        cancelButton.delay = 0.1
        cancelButton.animate()
        
        setupAnimation(insertButton)
        insertButton.delay = 0.2
        insertButton.animate()
        
        setupAnimation(copyButton)
        copyButton.delay = 0.2
        copyButton.animateNext(completion)
    }
    
    func hideButtons(completion: () -> ()) {
        func setupAnimation(button: SpringButton) {
            button.animation = "slideDown"
            button.duration = 0.3
            button.curve = "easeOut"
        }
        
        for button in [favoriteButton, cancelButton, insertButton] {
            button.selected = false
        }
        
        setupAnimation(favoriteButton)
        favoriteButton.animate()
        
        setupAnimation(cancelButton)
        cancelButton.delay = 0.1
        cancelButton.animate()
        
        setupAnimation(insertButton)
        insertButton.delay = 0.2
        insertButton.animate()
        
        setupAnimation(copyButton)
        copyButton.delay = 0.2
        copyButton.animateNext(completion)
    }
    
    
    func setupLayout() {
        addConstraints([
            backgroundView.al_top == al_top,
            backgroundView.al_left == al_left,
            backgroundView.al_right == al_right,
            backgroundView.al_bottom == al_bottom,
            
            insertButton.al_centerY == cancelButton.al_centerY,
            insertButton.al_width == 60,
            insertButton.al_height == insertButton.al_width,
            
            copyButton.al_centerY == cancelButton.al_centerY,
            copyButton.al_width == 60,
            copyButton.al_height == copyButton.al_width,
            
            favoriteButton.al_centerY == cancelButton.al_centerY,
            favoriteButton.al_width == 60,
            favoriteButton.al_height == favoriteButton.al_width,
            
            cancelButton.al_centerY == al_centerY - 10,
            cancelButton.al_width == 60,
            cancelButton.al_height == cancelButton.al_width,
            
            doneButton.al_centerY == cancelButton.al_centerY,
            doneButton.al_width == cancelButton.al_width,
            doneButton.al_height == cancelButton.al_width,
            
            cancelButton.al_centerX == al_centerX,
            doneButton.al_centerX == al_centerX,
            favoriteButton.al_right == cancelButton.al_left - 24,
            insertButton.al_left == cancelButton.al_right + 24,
            copyButton.al_left == cancelButton.al_right + 24,
            
            rightLabel.al_top == insertButton.al_bottom,
            rightLabel.al_centerX == insertButton.al_centerX,
            
            leftLabel.al_top == favoriteButton.al_bottom,
            leftLabel.al_centerX == favoriteButton.al_centerX,
            
            middleLabel.al_top == cancelButton.al_bottom,
            middleLabel.al_centerX == cancelButton.al_centerX,
            
        ])
    }

}
