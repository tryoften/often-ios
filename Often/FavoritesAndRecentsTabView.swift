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
    var recentsTabButton: UIButton
    var packsTabButton: UIButton
    var delegate: FavoritesAndRecentsTabDelegate?
    
    override init(frame: CGRect) {
        
        recentsTabButton = UIButton()
        recentsTabButton.translatesAutoresizingMaskIntoConstraints = false
        recentsTabButton.setTitle("RECENTS", forState: .Normal)
        recentsTabButton.setTitleColor(BlackColor, forState: .Normal)
        recentsTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        recentsTabButton.titleLabel?.textAlignment = .Center
        
        packsTabButton = UIButton()
        packsTabButton.translatesAutoresizingMaskIntoConstraints = false
        packsTabButton.setTitle("PACKS", forState: .Normal)
        packsTabButton.setTitleColor(BlackColor, forState: .Normal)
        packsTabButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
        packsTabButton.titleLabel?.textAlignment = .Center
        
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = TealColor
        
        super.init(frame: frame)
        backgroundColor = WhiteColor

        recentsTabButton.addTarget(self, action: #selector(FavoritesAndRecentsTabView.recentsButtonDidTabTapped(_:)), forControlEvents: .TouchUpInside)
        packsTabButton.addTarget(self, action: #selector(FavoritesAndRecentsTabView.packsButtonDidTabTapped(_:)), forControlEvents: .TouchUpInside)

        addSubview(recentsTabButton)
        addSubview(packsTabButton)
        addSubview(highlightBarView)
        
         setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left
        
        addConstraints([
            packsTabButton.al_bottom == al_bottom,
            packsTabButton.al_top == al_top,
            packsTabButton.al_left == al_left,
            packsTabButton.al_width == al_width / 2,

            recentsTabButton.al_bottom == al_bottom,
            recentsTabButton.al_top == al_top,
            recentsTabButton.al_right == al_right,
            recentsTabButton.al_left == packsTabButton.al_right,
            recentsTabButton.al_width == al_width / 2,
            
            
            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 4,
            highlightBarView.al_width == al_width / 2,
            highlightBarLeftConstraint!
        ])
    }
    
    func packsButtonDidTabTapped(sender: UIButton) {
        highlightBarLeftConstraint?.constant = 0.0
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.userPacksTabSelected()
    }
    
    func recentsButtonDidTabTapped(sender: UIButton) {
        highlightBarLeftConstraint?.constant =  (UIScreen.mainScreen().bounds.width / 2) * 2

        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.userRecentsTabSelected()
    }
    
}

protocol FavoritesAndRecentsTabDelegate {
    func userRecentsTabSelected()
    func userPacksTabSelected()
}