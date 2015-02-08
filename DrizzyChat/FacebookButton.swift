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
    
    class func button() -> UIButton {
        var fbButton = FacebookButton.buttonWithType(UIButtonType.Custom) as UIButton

        fbButton.backgroundColor = UIColor(fromHexString: "#3b5998")
        fbButton.layer.cornerRadius = 5
        
        var title = NSMutableAttributedString(string: "\u{f610}   Sign in with Facebook")
        
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "SSSocialRegular", size: 24)!, range: NSMakeRange(0, 1))
        title.addAttribute(NSBaselineOffsetAttributeName, value: -5.0, range: NSMakeRange(0, 1))
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 18)!, range: NSMakeRange(1, title.length - 1))
        
        fbButton.titleLabel?.textColor = UIColor.whiteColor()
        fbButton.setAttributedTitle(title, forState: .Normal)
        
        return fbButton
    }
    
    func setHighlightedColor(highlighted: Bool) {
        if highlighted {
            backgroundColor = UIColor(fromHexString: "#4d75c7")
        } else {
            backgroundColor = UIColor(fromHexString: "#3b5998")
        }
    }
}