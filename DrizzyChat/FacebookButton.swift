//
//  FacebookButton.swift
//  Drizzy
//
//  Created by Luc Success on 2/7/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class FacebookButton: UIButton {
    
    override var selected: Bool {
        didSet {
            setHighlightedColor(selected)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            setHighlightedColor(highlighted)
        }
    }
    
    class func button() -> FacebookButton {
        var fbButton = FacebookButton.buttonWithType(UIButtonType.Custom) as! UIButton

        fbButton.backgroundColor = FacebookButtonNormalBackgroundColor
        fbButton.addTarget(fbButton, action: "didTapButton", forControlEvents: .TouchUpInside)
        
        fbButton.setImage(UIImage(named: "FacebookButton"), forState: .Normal)
        fbButton.setTitle("Sign Up with Facebook".uppercaseString, forState: .Normal)
        fbButton.imageView?.contentMode = .ScaleAspectFit
        fbButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        fbButton.titleLabel?.textColor = FacebookButtonTitleTextColor
        fbButton.titleLabel?.font = FacebookButtonTitleFont
        
        return fbButton as! FacebookButton
    }
    
    func didTapButton() {
        var animationClass: CSAnimation.Type = CSAnimation.classForAnimationType("pop") as! CSAnimation.Type
        animationClass.performAnimationOnView(self, duration: 0.2, delay: 0.0)
    }
    
    func setHighlightedColor(highlighted: Bool) {
        if highlighted {
            backgroundColor = FacebookButtonHighlightedBackgroundColor
        } else {
            backgroundColor = FacebookButtonNormalBackgroundColor
        }
    }
}