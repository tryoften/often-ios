//
//  FavoriteAndRecentTabView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/5/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class FavoritesAndRecentsTabView: UIView {
    let highlightBarView: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    var favoritesTabButton: UIButton
    var recentsTabButton: UIButton
    var delegate: FavoritesAndRecentsTabDelegate?
    
    override init(frame: CGRect) {
        favoritesTabButton = UIButton()
        favoritesTabButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesTabButton.setTitle("FAVORITES", forState: .Normal)
        favoritesTabButton.setTitleColor(BlackColor, forState: .Normal)
        favoritesTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        favoritesTabButton.titleLabel?.textAlignment = .Center
        
        recentsTabButton = UIButton()
        recentsTabButton.translatesAutoresizingMaskIntoConstraints = false
        recentsTabButton.setTitle("RECENTS", forState: .Normal)
        recentsTabButton.setTitleColor(BlackColor, forState: .Normal)
        recentsTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        recentsTabButton.titleLabel?.textAlignment = .Center
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = TealColor
        
        super.init(frame: frame)
        backgroundColor = WhiteColor
        
        favoritesTabButton.addTarget(self, action: "favoritesButtonDidTabTapped:", forControlEvents: .TouchUpInside)
        recentsTabButton.addTarget(self, action: "recentsButtonDidTabTapped:", forControlEvents: .TouchUpInside)
        
        addSubview(favoritesTabButton)
        addSubview(recentsTabButton)
        addSubview(highlightBarView)
        
         setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left
        
        addConstraints([
            favoritesTabButton.al_left == al_left,
            favoritesTabButton.al_bottom == al_bottom,
            favoritesTabButton.al_top == al_top,
            favoritesTabButton.al_right == al_centerX,
            
            recentsTabButton.al_bottom == al_bottom,
            recentsTabButton.al_top == al_top,
            recentsTabButton.al_right == al_right,
            recentsTabButton.al_left == al_centerX,
            
            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 4,
            highlightBarView.al_width == al_width / 2,
            highlightBarLeftConstraint!
            ])
    }
    
    func favoritesButtonDidTabTapped(sender: UIButton) {
        highlightBarLeftConstraint?.constant = 0.0
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.userFavoritesTabSelected()
    }
    
    func recentsButtonDidTabTapped(sender: UIButton) {
        highlightBarLeftConstraint?.constant =  UIScreen.mainScreen().bounds.width / 2

        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.userRecentsTabSelected()
    }
    
}

protocol FavoritesAndRecentsTabDelegate {
    func userFavoritesTabSelected()
    func userRecentsTabSelected()
}