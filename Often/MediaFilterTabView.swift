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

    let highlightPill: UIView
    var highlightPillCenterConstraint: NSLayoutConstraint?
    var highlightPillWidthConstraint: NSLayoutConstraint?
    var buttons: [UIButton]
    private var buttonWidth: CGFloat
    
    init(filterMap: FilterMap) {
        highlightPill = UIView()
        highlightPill.translatesAutoresizingMaskIntoConstraints = false
        highlightPill.backgroundColor = TealColor
        highlightPill.layer.cornerRadius = 11.0
        highlightPill.clipsToBounds = true
        
        buttons = [UIButton]()
        buttonWidth = 0
        
        super.init(frame: CGRectZero)
        
        backgroundColor = WhiteColor
        
        addSubview(highlightPill)
        
        for (tag, filters) in filterMap {
            let button = FilterButton(filters: filters)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(tag.rawValue.uppercaseString, forState: .Normal)
            button.setTitleColor(WhiteColor, forState: .Selected)
            button.setTitleColor(UnactiveTextColor, forState: .Normal)
            button.titleLabel?.font = UIFont(name: "Montserrat", size: 10.5)
            button.addTarget(self, action: "filterDidTapButtonTapped:", forControlEvents: .TouchUpInside)
            addSubview(button)
            buttons.append(button)
        }
        
        buttonWidth = UIScreen.mainScreen().bounds.width / CGFloat(buttons.count)
        
        if let firstButton = buttons.first {
            firstButton.selected = true
        }
        
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
        guard let firstButton = buttons.first else {
            return
        }
        
        highlightPillCenterConstraint = highlightPill.al_centerX == firstButton.al_centerX

        for var i = 0; i < buttons.count; i++  {
            addConstraints([
                buttons[i].al_top == al_top,
                buttons[i].al_left == al_left + buttonWidth * CGFloat(i),
                buttons[i].al_bottom == al_bottom,
                buttons[i].al_width == buttonWidth,
            ])
        }
        
        layoutIfNeeded()
        firstButton.sizeToFit()
        highlightPillWidthConstraint = highlightPill.al_width == CGRectGetWidth(firstButton.titleLabel!.frame) + 30
        
        addConstraints([
            highlightPillCenterConstraint!,
            highlightPill.al_centerY == al_centerY,
            highlightPill.al_height == 22,
            highlightPillWidthConstraint!
        ])
    }
    
    //Filter Method
    func filterDidTapButtonTapped(button: FilterButton) {
        for var i = 0; i < buttons.count; i++ {
            if buttons[i] == button {
                buttons[i].selected = true
                highlightPillCenterConstraint?.constant = (buttonWidth * CGFloat(i))
                highlightPillWidthConstraint?.constant = CGRectGetWidth(button.titleLabel!.frame) + 30
                delegate?.mediaFilterDidChange(button.filterTypes)
                
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
    func mediaFilterDidChange(filters: [MediaType])
}

