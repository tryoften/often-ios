//
//  GifCellOverlayView.swift
//  Often
//
//  Created by Katelyn Findlay on 4/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Spring

class GifCellOverlayView : UIView {
    let favoriteButton : SpringButton
    let copyButton : SpringButton
    
    override init(frame: CGRect) {
        favoriteButton = SpringButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(StyleKit.imageOfFavorite(scale: 0.5, color: WhiteColor), forState: .Normal)
        favoriteButton.setImage(StyleKit.imageOfFavorite(scale: 0.5, favorited: true), forState: .Selected)
        
        copyButton = SpringButton()
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.setImage(StyleKit.imageOfClipboard(scale: 0.5, color: WhiteColor), forState: .Normal)
        copyButton.setImage(StyleKit.imageOfClipboard(scale: 0.5, selected: true), forState: .Selected)
        
        super.init(frame: frame)
        
        addSubview(favoriteButton)
        addSubview(copyButton)
        
        setupLayout()
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showButtons(completion: () -> ()) {
        func setupAnimation(button: SpringButton) {
            button.animation = "slideUp"
            button.duration = 0.2
            button.curve = "easeIn"
        }
        
        for button in [favoriteButton, copyButton] {
            button.selected = false
        }
        
        setupAnimation(favoriteButton)
        favoriteButton.animate()
        
        setupAnimation(copyButton)
        copyButton.delay = 0.1
        copyButton.animateNext(completion)
    }
    
    func hideButtons(completion: () -> ()) {
        func setupAnimation(button: SpringButton) {
            button.animation = "slideDown"
            button.duration = 0.2
            button.curve = "easeOut"
        }
        
        for button in [favoriteButton, copyButton] {
            button.selected = false
        }
        
        setupAnimation(favoriteButton)
        favoriteButton.animate()
        
        setupAnimation(copyButton)
        copyButton.delay = 0.1
        copyButton.animateNext(completion)
    }
    
    func setupLayout() {
        addConstraints([
            
            favoriteButton.al_centerY == al_centerY,
            favoriteButton.al_width == 40,
            favoriteButton.al_height == favoriteButton.al_width,
            favoriteButton.al_right == al_centerX - 12,
            
            copyButton.al_centerY == al_centerY,
            copyButton.al_width == favoriteButton.al_width,
            copyButton.al_height == favoriteButton.al_height,
            copyButton.al_left == al_centerX + 12
        ])
    }
}
