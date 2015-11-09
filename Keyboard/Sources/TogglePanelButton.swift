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
//            UIView.animateWithDuration(0.3) {
//                self.imageView!.transform = self.collapsed
//                    ? CGAffineTransformMakeRotation(0)
//                    : CGAffineTransformMakeRotation(CGFloat(M_PI))
//                
//                self.layoutIfNeeded()
//            }
        }
    }
    
    private var leftBackgroundView: UIImageView
    private var centerBackgroundView: UIImageView
    private var rightBackgroundView: UIImageView

    override init(frame: CGRect) {
        collapsed = false
        centerBackgroundView = UIImageView(image: UIImage(named: "collapse-keyboard"))
        centerBackgroundView.contentMode = .ScaleAspectFill
        centerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let capBgImage = UIImage(named: "collapse-keyboard-edge")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 2, 0, 2), resizingMode: .Stretch)
        
        leftBackgroundView = UIImageView(image: capBgImage)
        leftBackgroundView.contentMode = .ScaleToFill
        leftBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        rightBackgroundView = UIImageView(image: capBgImage)
        rightBackgroundView.contentMode = .ScaleToFill
        rightBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        
        super.init(frame: frame)

        insertSubview(leftBackgroundView, belowSubview: imageView!)
        insertSubview(centerBackgroundView, belowSubview: imageView!)
        insertSubview(rightBackgroundView, belowSubview: imageView!)

        contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        userInteractionEnabled = true

        
//        setImage(StyleKit.imageOfArrowheadup(frame: CGRectMake(0, 0, 40, 40), color: DefaultTheme.keyboardKeyTextColor, borderWidth: 2.0), forState: .Normal)
//        setImage(StyleKit.imageOfArrowheadup(frame: CGRectMake(0, 0, 40, 40), color: TealColor, borderWidth: 2.0), forState: .Selected)
        
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .ScaleAspectFit
        
        setImage(StyleKit.imageOfKeyboard(frame: CGRectMake(0, 0, 35, 35), color: DarkGrey, scale: 0.6), forState: .Normal)
        
        addConstraints([
            leftBackgroundView.al_left == al_left,
            leftBackgroundView.al_right == centerBackgroundView.al_left,
            leftBackgroundView.al_bottom == al_bottom,
            leftBackgroundView.al_height == al_height,
            
            centerBackgroundView.al_centerX == al_centerX,
            centerBackgroundView.al_bottom == al_bottom,
            centerBackgroundView.al_top == al_top - 18,
            centerBackgroundView.al_width == 63,

            rightBackgroundView.al_right == al_right,
            rightBackgroundView.al_left == centerBackgroundView.al_right,
            rightBackgroundView.al_bottom == al_bottom,
            rightBackgroundView.al_height == leftBackgroundView.al_height
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
