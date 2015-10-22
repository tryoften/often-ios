//
//  UserProfileFilterTabView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileFilterTabView: UIView {
    
    enum FilterType {
        case All
        case Songs
        case Videos
        case Links
        case Gifs
    }
    
    var currentFilter: FilterType = .All
    
    let allFilterButton: UIButton
    let songsFilterButton: UIButton
    let videosFilterButton: UIButton
    let linksFilterButton: UIButton
    let gifsFilterButton: UIButton
    let highlightBar: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    
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
        var type = currentFilter
        if button.titleLabel?.text == "ALL" {
            type = .All
        } else if button.titleLabel?.text == "SONGS" {
            type = .Songs
        } else if  button.titleLabel?.text == "VIDEOS" {
            type = .Videos
        } else if  button.titleLabel?.text == "LINKS" {
            type = .Links
        } else if  button.titleLabel?.text == "GIFS" {
            type = .Gifs
        }
        
        
        switch type {
        case .All:
            if allFilterButton.selected == true {
                //do nothing
            } else {
                allFilterButton.selected = true
                songsFilterButton.selected = false
                videosFilterButton.selected = false
                linksFilterButton.selected = false
                gifsFilterButton.selected = false
                highlightBarLeftConstraint?.constant = 0.0
                currentFilter = .All
            }
            break
        case .Songs:
            if songsFilterButton.selected == true {
                //do nothing
            } else {
                allFilterButton.selected = false
                songsFilterButton.selected = true
                videosFilterButton.selected = false
                linksFilterButton.selected = false
                gifsFilterButton.selected = false
                highlightBarLeftConstraint?.constant = buttonWidth
                currentFilter = .Songs
            }
            break
        case .Videos:
            if videosFilterButton.selected == true {
                //do nothing
            } else {
                allFilterButton.selected = false
                songsFilterButton.selected = false
                videosFilterButton.selected = true
                linksFilterButton.selected = false
                gifsFilterButton.selected = false
                highlightBarLeftConstraint?.constant = buttonWidth * 2
                currentFilter = .Videos
            }
            break
        case .Links:
            if linksFilterButton.selected == true {
                //do nothing
            } else {
                allFilterButton.selected = false
                songsFilterButton.selected = false
                videosFilterButton.selected = false
                linksFilterButton.selected = true
                gifsFilterButton.selected = false
                highlightBarLeftConstraint?.constant = buttonWidth * 3
                currentFilter = .Links
            }
            break
        case .Gifs:
            if gifsFilterButton.selected == true {
                //do nothing
            } else {
                allFilterButton.selected = false
                songsFilterButton.selected = false
                videosFilterButton.selected = false
                linksFilterButton.selected = false
                gifsFilterButton.selected = true
                highlightBarLeftConstraint?.constant = buttonWidth * 4
                currentFilter = .Gifs
            }
            break
        }
    }
}

