//
//  SearchResultsCellOverlayView.swift
//  Often
//
//  Created by Luc Succes on 9/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchResultsCellOverlayView: UIView {
    
    let insertButton: SpringButton
    let favoriteButton: SpringButton
    let cancelButton: SpringButton
    
    let insertLabel: UILabel
    let favoriteLabel: UILabel
    let cancelLabel: UILabel
    
    let backgroundView: UIVisualEffectView
    
    override init(frame: CGRect) {
        insertButton = SpringButton()
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        insertButton.setImage(StyleKit.imageOfInsert(scale: 0.5), forState: .Normal)
        insertButton.setImage(StyleKit.imageOfInsert(scale: 0.5, selected: true), forState: .Selected)
        
        favoriteButton = SpringButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(StyleKit.imageOfFavorite(scale: 0.5), forState: .Normal)
        favoriteButton.setImage(StyleKit.imageOfFavorite(scale: 0.5, selected: true), forState: .Selected)
        
        cancelButton = SpringButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfCancel(scale: 0.5), forState: .Normal)
        cancelButton.setImage(StyleKit.imageOfCancel(scale: 0.5, selected: true), forState: .Selected)

        let labelFont = UIFont(name: "Montserrat-Regular", size: 12)
        
        insertLabel = UILabel()
        insertLabel.translatesAutoresizingMaskIntoConstraints = false
        insertLabel.font = labelFont
        insertLabel.text = "Insert".uppercaseString
        
        favoriteLabel = UILabel()
        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteLabel.font = labelFont
        favoriteLabel.text = "Favorite".uppercaseString
        
        cancelLabel = UILabel()
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.font = labelFont
        cancelLabel.text = "Cancel".uppercaseString
        
        backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(insertButton)
        addSubview(favoriteButton)
        addSubview(cancelButton)
        
        addSubview(insertLabel)
        addSubview(favoriteLabel)
        addSubview(cancelLabel)
        
        setupLayout()
        
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showButtons() {
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
            
            favoriteButton.al_centerY == cancelButton.al_centerY,
            favoriteButton.al_width == 60,
            favoriteButton.al_height == favoriteButton.al_width,
            
            cancelButton.al_centerY == al_centerY - 15,
            cancelButton.al_width == 60,
            cancelButton.al_height == cancelButton.al_width,
            
            cancelButton.al_centerX == al_centerX,
            favoriteButton.al_right == cancelButton.al_left - 40,
            insertButton.al_left == cancelButton.al_right + 40,
            
            insertLabel.al_top == insertButton.al_bottom,
            insertLabel.al_centerX == insertButton.al_centerX,
            
            favoriteLabel.al_top == favoriteButton.al_bottom,
            favoriteLabel.al_centerX == favoriteButton.al_centerX,
            
            cancelLabel.al_top == cancelButton.al_bottom,
            cancelLabel.al_centerX == cancelButton.al_centerX
        ])
    }

}
