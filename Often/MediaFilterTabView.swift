//
//  UserProfileFilterTabView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class MediaFilterTabView: UIView {
    weak var delegate: FilterTabDelegate?

    let highlightBar: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    let buttons: [UIButton]
    
    
    init(filterMap: [FilterTag: FilterButton]) {
        let allFilterButton = filterMap[.All]!
        allFilterButton.translatesAutoresizingMaskIntoConstraints = false
        allFilterButton.setTitle("all".uppercaseString, forState: .Normal)
        allFilterButton.setTitleColor(BlackColor, forState: .Selected)
        allFilterButton.setTitleColor(LightGrey, forState: .Normal)
        allFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        allFilterButton.selected = true
    
        
        let songsFilterButton = filterMap[.Music]!
        songsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        songsFilterButton.setTitle("songs".uppercaseString, forState: .Normal)
        songsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        songsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        songsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        
        let videosFilterButton = filterMap[.Video]!
        videosFilterButton.translatesAutoresizingMaskIntoConstraints = false
        videosFilterButton.setTitle("videos".uppercaseString, forState: .Normal)
        videosFilterButton.setTitleColor(BlackColor, forState: .Selected)
        videosFilterButton.setTitleColor(LightGrey, forState: .Normal)
        videosFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        
        let newsFilterButton = filterMap[.News]!
        newsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        newsFilterButton.setTitle("news".uppercaseString, forState: .Normal)
        newsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        newsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        newsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        
        let gifsFilterButton = filterMap[.Gifs]!
        gifsFilterButton.translatesAutoresizingMaskIntoConstraints = false
        gifsFilterButton.setTitle("gifs".uppercaseString, forState: .Normal)
        gifsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        gifsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        gifsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
       
        highlightBar = UIView()
        highlightBar.translatesAutoresizingMaskIntoConstraints = false
        highlightBar.backgroundColor = TealColor
        
        buttons = [allFilterButton, songsFilterButton, videosFilterButton, newsFilterButton, gifsFilterButton]
        
        
        super.init(frame: CGRectZero)
        
        backgroundColor = WhiteColor
        
    
        for button in buttons {
            button.addTarget(self, action: "filterDidTapButtonTapped:", forControlEvents: .TouchUpInside)
            addSubview(button)
        }
        
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
        highlightBarLeftConstraint = highlightBar.al_left == al_left
        
        for var i = 0; i < buttons.count; i++  {
            let buttonWidth = UIScreen.mainScreen().bounds.width / 5
            
            addConstraints([
                buttons[i].al_top == al_top,
                buttons[i].al_left == al_left + buttonWidth * CGFloat(i),
                buttons[i].al_bottom == al_bottom,
                buttons[i].al_width == UIScreen.mainScreen().bounds.width / 5,
            ])
        }
        
        addConstraints([
            highlightBarLeftConstraint!,
            highlightBar.al_bottom == al_bottom,
            highlightBar.al_height == 4.0,
            highlightBar.al_width == UIScreen.mainScreen().bounds.width / 5
            ])
    }
    
    //Filter Method
    func filterDidTapButtonTapped(button: FilterButton) {
        let buttonWidth = UIScreen.mainScreen().bounds.width / 5
        
        for var i = 0; i < buttons.count; i++ {
            if buttons[i] == button {
                buttons[i].selected = true
                highlightBarLeftConstraint?.constant = (buttonWidth * CGFloat(i))
                delegate?.filterDidChange(button.filterType)
                
                UIView.animateWithDuration(0.3) {
                    self.layoutIfNeeded()
                }
                
            } else {
                buttons[i].selected = false
            }
        }
    }
}

protocol FilterTabDelegate: class {
    func filterDidChange(filter:  [MediaType])
}

