//
//  TogglePanelButton.swift
//  Often
//
//  Created by Luc Succes on 9/30/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable nesting

import UIKit


class TogglePanelButton: UIButton {
    
    enum TogglePanelButtonMode {
        case ToggleKeyboard
        case ClosePanel
        case SwitchKeyboard
    }

    var collapsed: Bool {
        didSet {
            hidden = false
        }
    }
    
    var mode: TogglePanelButtonMode {
        didSet {
            switch(mode) {
            case .ToggleKeyboard:
                setImage(StyleKit.imageOfKeyboard(frame: CGRectMake(0, 0, 48, 30), color: UIColor(fromHexString: "#BEBEBE"), scale: 0.5), forState: .Normal)
                setImage(StyleKit.imageOfKeyboard(frame: CGRectMake(0, 0, 48, 30), color: BlackColor.colorWithAlphaComponent(0.8), scale: 0.5), forState: .Selected)
                break
            case .ClosePanel:
                setImage(StyleKit.imageOfClosebutton(frame: CGRectMake(0, 8, 50, 45), scale: 0.62), forState: .Normal)
            case .SwitchKeyboard:
                setImage(StyleKit.imageOfGlobebutton(frame: CGRectMake(0, 8, 50, 45), scale: 0.62), forState: .Normal)
            }
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
        centerBackgroundView.alpha = 0.9

        let capBgImage = UIImage(named: "collapse-keyboard-edge")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 2, 0, 2), resizingMode: .Stretch)
        
        leftBackgroundView = UIImageView(image: capBgImage)
        leftBackgroundView.contentMode = .ScaleToFill
        leftBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        leftBackgroundView.alpha = 0.9
        
        rightBackgroundView = UIImageView(image: capBgImage)
        rightBackgroundView.contentMode = .ScaleToFill
        rightBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        rightBackgroundView.alpha = 0.9
        
        mode = .ToggleKeyboard
        
        super.init(frame: frame)

        userInteractionEnabled = true
        
        guard let imageView = imageView else {
            return
        }

        insertSubview(leftBackgroundView, belowSubview: imageView)
        insertSubview(centerBackgroundView, belowSubview: imageView)
        insertSubview(rightBackgroundView, belowSubview: imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        

        
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
            rightBackgroundView.al_height == leftBackgroundView.al_height,
            
            imageView.al_top == centerBackgroundView.al_top + 10,
            imageView.al_height == al_height + 10,
            imageView.al_bottom == centerBackgroundView.al_bottom,
            imageView.al_centerX == centerBackgroundView.al_centerX
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
