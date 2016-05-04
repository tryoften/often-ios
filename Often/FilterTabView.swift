//
//  FilterTabView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/5/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class FilterTabView: UIView {
    let highlightBarView: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    var leftTabButton: UIButton
    var rightTabButton: UIButton
    var delegate: FilterTabDelegate?
    
    let attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.0),
        NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
        NSForegroundColorAttributeName: BlackColor
    ]
    
    var leftTabButtonTitle: String? {
        didSet {
            let filterString = NSAttributedString(string: (leftTabButtonTitle?.uppercaseString)!, attributes: attributes)
            leftTabButton.setAttributedTitle(filterString, forState: .Normal)
        }
    }
    
    var rightTabButtonTitle: String? {
        didSet {
            let filterString = NSAttributedString(string: (rightTabButtonTitle?.uppercaseString)!, attributes: attributes)
            rightTabButton.setAttributedTitle(filterString, forState: .Normal)
        }
    }
    
    
    override init(frame: CGRect) {
        
        leftTabButton = UIButton()
        leftTabButton.translatesAutoresizingMaskIntoConstraints = false
        leftTabButton.titleLabel?.textAlignment = .Center
        
        rightTabButton = UIButton()
        rightTabButton.translatesAutoresizingMaskIntoConstraints = false
        rightTabButton.titleLabel?.textAlignment = .Center
        
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = UIColor.oftBrightLavenderColor()
        
        super.init(frame: frame)
        backgroundColor = WhiteColor

        leftTabButton.addTarget(self, action: #selector(FilterTabView.leftButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        rightTabButton.addTarget(self, action: #selector(FilterTabView.rightButtonDidTap(_:)), forControlEvents: .TouchUpInside)

        addSubview(leftTabButton)
        addSubview(rightTabButton)
        addSubview(highlightBarView)
        
         setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left
        highlightBarLeftConstraint?.constant = (UIScreen.mainScreen().bounds.width / 2)
        
        addConstraints([
            rightTabButton.al_bottom == al_bottom,
            rightTabButton.al_top == al_top,
            rightTabButton.al_left == al_left,
            rightTabButton.al_width == al_width / 2,

            leftTabButton.al_bottom == al_bottom,
            leftTabButton.al_top == al_top,
            leftTabButton.al_right == al_right,
            leftTabButton.al_left == rightTabButton.al_right,
            leftTabButton.al_width == al_width / 2,
            
            
            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 4,
            highlightBarView.al_width == al_width / 2,
            highlightBarLeftConstraint!
        ])
    }
    
    func leftButtonDidTap(sender: UIButton) {
        highlightBarLeftConstraint?.constant =  (UIScreen.mainScreen().bounds.width / 2)
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.leftTabSelected()
    }
    
    func rightButtonDidTap(sender: UIButton) {
        highlightBarLeftConstraint?.constant = 0.0

        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.rightTabSelected()
    }
    
}

protocol FilterTabDelegate {
    func leftTabSelected()
    func rightTabSelected()
}