//
//  UserProfileFilterTabView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileFilterTabView: UIView {
    let allFilterButton: FilterButton
    let songsFilterButton: FilterButton
    let videosFilterButton: FilterButton
    let newsFilterButton: FilterButton
    let gifsFilterButton: FilterButton
    let highlightBar: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    
    let buttons: [FilterButton]
   
    
    override init(frame: CGRect) {
        allFilterButton = FilterButton()
        allFilterButton.translatesAutoresizingMaskIntoConstraints = false
        allFilterButton.setTitle("all".uppercaseString, forState: .Normal)
        allFilterButton.setTitleColor(BlackColor, forState: .Selected)
        allFilterButton.setTitleColor(LightGrey, forState: .Normal)
        allFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        allFilterButton.selected = true
        allFilterButton.filterType = DefaultFilterMode
        
        songsFilterButton = FilterButton()
        songsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        songsFilterButton.setTitle("songs".uppercaseString, forState: .Normal)
        songsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        songsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        songsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        songsFilterButton.filterType = MusicFilterMode
        
        videosFilterButton = FilterButton()
        videosFilterButton.translatesAutoresizingMaskIntoConstraints = false
        videosFilterButton.setTitle("videos".uppercaseString, forState: .Normal)
        videosFilterButton.setTitleColor(BlackColor, forState: .Selected)
        videosFilterButton.setTitleColor(LightGrey, forState: .Normal)
        videosFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        videosFilterButton.filterType = VideoFilterMode
        
        newsFilterButton = FilterButton()
        newsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        newsFilterButton.setTitle("news".uppercaseString, forState: .Normal)
        newsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        newsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        newsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        newsFilterButton.filterType = NewsFilterMode
        
        gifsFilterButton = FilterButton()
        gifsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        gifsFilterButton.setTitle("gifs".uppercaseString, forState: .Normal)
        gifsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        gifsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        gifsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        gifsFilterButton.filterType = GifsFilterMode
        
        highlightBar = UIView()
        highlightBar.translatesAutoresizingMaskIntoConstraints = false
        highlightBar.backgroundColor = TealColor
        
        buttons = [allFilterButton, songsFilterButton, videosFilterButton, newsFilterButton, gifsFilterButton]
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        for button in buttons {
            button.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        }
        
        addSubview(allFilterButton)
        addSubview(songsFilterButton)
        addSubview(videosFilterButton)
        addSubview(newsFilterButton)
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
            
            newsFilterButton.al_left == videosFilterButton.al_right,
            newsFilterButton.al_top == al_top,
            newsFilterButton.al_bottom == al_bottom,
            newsFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            gifsFilterButton.al_left == newsFilterButton.al_right,
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
    func filterButtonTapped(button: FilterButton) {
        let buttonWidth = UIScreen.mainScreen().bounds.width / 5
        
        for var i = 0; i < buttons.count; i++ {
            if buttons[i] == button {
                buttons[i].selected = true
                highlightBarLeftConstraint?.constant = (buttonWidth * CGFloat(i))
                
                UIView.animateWithDuration(0.3) {
                    self.layoutIfNeeded()
                }
                
            } else {
                buttons[i].selected = false
            }
        }
    }
}


