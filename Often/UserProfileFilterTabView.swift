//
//  UserProfileFilterTabView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileFilterTabView: UIView {
    
    let allFilterButton: UIButton
    let songsFilterButton: UIButton
    let videosFilterButton: UIButton
    let linksFilterButton: UIButton
    let gifsFilterButton: UIButton
    let highlightBar: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    
    var buttons: [UIButton]
    
    override init(frame: CGRect) {
        allFilterButton = UIButton()
        allFilterButton.translatesAutoresizingMaskIntoConstraints = false
        allFilterButton.setTitle("ALL", forState: .Normal)
        allFilterButton.setTitleColor(BlackColor, forState: .Selected)
        allFilterButton.setTitleColor(LightGrey, forState: .Normal)
        allFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        allFilterButton.selected = true
        
        songsFilterButton = UIButton()
        songsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        songsFilterButton.setTitle("SONGS", forState: .Normal)
        songsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        songsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        songsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        videosFilterButton = UIButton()
        videosFilterButton.translatesAutoresizingMaskIntoConstraints = false
        videosFilterButton.setTitle("VIDEOS", forState: .Normal)
        videosFilterButton.setTitleColor(BlackColor, forState: .Selected)
        videosFilterButton.setTitleColor(LightGrey, forState: .Normal)
        videosFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        linksFilterButton = UIButton()
        linksFilterButton.translatesAutoresizingMaskIntoConstraints = false
        linksFilterButton.setTitle("LINKS", forState: .Normal)
        linksFilterButton.setTitleColor(BlackColor, forState: .Selected)
        linksFilterButton.setTitleColor(LightGrey, forState: .Normal)
        linksFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        gifsFilterButton = UIButton()
        gifsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        gifsFilterButton.setTitle("GIFS", forState: .Normal)
        gifsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        gifsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        gifsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        highlightBar = UIView()
        highlightBar.translatesAutoresizingMaskIntoConstraints = false
        highlightBar.backgroundColor = TealColor
        
        buttons = [allFilterButton, songsFilterButton, videosFilterButton, linksFilterButton, gifsFilterButton]
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        allFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        songsFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        videosFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        linksFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        gifsFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        
        addSubview(allFilterButton)
        addSubview(songsFilterButton)
        addSubview(videosFilterButton)
        addSubview(linksFilterButton)
        addSubview(gifsFilterButton)
        addSubview(highlightBar)
        
        setupLayout()

        layer.shadowOffset = CGSizeMake(0, -1)
        layer.shadowOpacity = 0.8
        layer.shadowColor = DarkGrey.CGColor
        layer.shadowRadius = 4
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        highlightBarLeftConstraint = highlightBar.al_left == allFilterButton.al_left
        
        addConstraints([
            allFilterButton.al_top == al_top,
            allFilterButton.al_left == al_left,
            allFilterButton.al_bottom == al_bottom,
            allFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            songsFilterButton.al_left == allFilterButton.al_right,
            songsFilterButton.al_top == al_top,
            songsFilterButton.al_bottom == al_bottom,
            songsFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            videosFilterButton.al_left == songsFilterButton.al_right,
            videosFilterButton.al_top == al_top,
            videosFilterButton.al_bottom == al_bottom,
            videosFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            linksFilterButton.al_left == videosFilterButton.al_right,
            linksFilterButton.al_top == al_top,
            linksFilterButton.al_bottom == al_bottom,
            linksFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            gifsFilterButton.al_left == linksFilterButton.al_right,
            gifsFilterButton.al_top == al_top,
            gifsFilterButton.al_bottom == al_bottom,
            gifsFilterButton.al_right == al_right,
            
            highlightBarLeftConstraint!,
            highlightBar.al_bottom == al_bottom,
            highlightBar.al_height == 4.0,
            highlightBar.al_width == UIScreen.mainScreen().bounds.width / 5
        ])
    }
    
    //Filter Method
    func filterButtonTapped(button: UIButton) {
        let buttonWidth = UIScreen.mainScreen().bounds.width / 5
        
        for var i = 0; i < buttons.count; i++ {
            if buttons[i] == button {
                buttons[i].selected = true
                highlightBarLeftConstraint?.constant = (buttonWidth * CGFloat(i))
            } else {
                buttons[i].selected = false
            }
        }
    }
}

