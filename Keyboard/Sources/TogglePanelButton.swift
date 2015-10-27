//
//  TogglePanelButton.swift
//  Often
//
//  Created by Luc Succes on 9/30/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class TogglePanelButton: UIButton {

    var collapsed: Bool {
        didSet {
            hidden = false
            UIView.animateWithDuration(0.3) {
                self.imageView!.transform = self.collapsed
                    ? CGAffineTransformMakeRotation(0)
                    : CGAffineTransformMakeRotation(CGFloat(M_PI))
                
                self.layoutIfNeeded()
            }
        }
    }

    override init(frame: CGRect) {
        collapsed = false
        
        super.init(frame: frame)

        imageView?.contentMode = .ScaleAspectFit
        contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.90)
        userInteractionEnabled = true
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.19).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowRadius = 2.0
        
        
        setImage(StyleKit.imageOfArrowheadup(frame: CGRectMake(0, 0, 40, 40), color: DefaultTheme.keyboardKeyTextColor, borderWidth: 2.0), forState: .Normal)
        setImage(StyleKit.imageOfArrowheadup(frame: CGRectMake(0, 0, 40, 40), color: TealColor, borderWidth: 2.0), forState: .Selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
