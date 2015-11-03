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
    var buttons: [UIButton]
    private var buttonWidth: CGFloat
    
    init(filterMap: FilterMap) {
        highlightBar = UIView()
        highlightBar.translatesAutoresizingMaskIntoConstraints = false
        highlightBar.backgroundColor = TealColor
        buttons = [UIButton]()
        buttonWidth = 0
        
        super.init(frame: CGRectZero)
        
        backgroundColor = WhiteColor
        
        for (tag, filters) in filterMap {
            let button = FilterButton(filters: filters)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(tag.rawValue.uppercaseString, forState: .Normal)
            button.setTitleColor(BlackColor, forState: .Selected)
            button.setTitleColor(LightGrey, forState: .Normal)
            button.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
            button.addTarget(self, action: "filterDidTapButtonTapped:", forControlEvents: .TouchUpInside)
            addSubview(button)
            buttons.append(button)
        }
        buttonWidth = UIScreen.mainScreen().bounds.width / CGFloat(buttons.count)
        
        if let firstButton = buttons.first {
            firstButton.selected = true
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
            addConstraints([
                buttons[i].al_top == al_top,
                buttons[i].al_left == al_left + buttonWidth * CGFloat(i),
                buttons[i].al_bottom == al_bottom,
                buttons[i].al_width == buttonWidth,
            ])
        }
        
        addConstraints([
            highlightBarLeftConstraint!,
            highlightBar.al_bottom == al_bottom,
            highlightBar.al_height == 4.0,
            highlightBar.al_width == buttonWidth
        ])
    }
    
    //Filter Method
    func filterDidTapButtonTapped(button: FilterButton) {
        for var i = 0; i < buttons.count; i++ {
            if buttons[i] == button {
                buttons[i].selected = true
                highlightBarLeftConstraint?.constant = (buttonWidth * CGFloat(i))
                delegate?.filterDidChange(button.filterTypes)
                
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
    func filterDidChange(filters: [MediaType])
}

