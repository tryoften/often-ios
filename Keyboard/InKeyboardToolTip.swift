//
//  InKeyboardToolTip.swift
//  Often
//
//  Created by Komran Ghahremani on 11/4/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class InKeyboardToolTip: UIView {
    var tipView: UIView
    var messageLabel: UILabel
    var closeButton: UIButton
    var caretView: UIImageView
    var whiteOvalView: UIView
    var blackOutlineOvalView: UIView
    weak var closeButtonDelegate: ToolTipCloseButtonDelegate?
    
    override init(frame: CGRect) {
        tipView = UIView()
        tipView.translatesAutoresizingMaskIntoConstraints = false
        tipView.layer.cornerRadius = 3
        tipView.backgroundColor = WhiteColor
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.userInteractionEnabled = false
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 2
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.font = UIFont(name: "OpenSans", size: 12.0)
        messageLabel.text = "Tap to open and close the keyboard whenever \n you need to type or edit your message!"
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.userInteractionEnabled = true
        
        caretView = UIImageView()
        caretView.translatesAutoresizingMaskIntoConstraints = false
        caretView.image = UIImage(named: "caret")
        caretView.contentMode = .ScaleAspectFit
        
        whiteOvalView = UIView()
        whiteOvalView.translatesAutoresizingMaskIntoConstraints = false
        whiteOvalView.backgroundColor = WhiteColor
        whiteOvalView.layer.cornerRadius = 40
        
        blackOutlineOvalView = UIView()
        blackOutlineOvalView.translatesAutoresizingMaskIntoConstraints = false
        blackOutlineOvalView.backgroundColor = ClearColor
        blackOutlineOvalView.layer.borderColor = BlackColor.CGColor
        blackOutlineOvalView.layer.borderWidth = 2.0
        blackOutlineOvalView.layer.cornerRadius = 30
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        
        tipView.addSubview(messageLabel)
        tipView.addSubview(closeButton)
        addSubview(caretView)
        addSubview(tipView)
        addSubview(whiteOvalView)
        whiteOvalView.addSubview(blackOutlineOvalView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeTapped() {
        closeButtonDelegate?.toolTipCloseButtonDidTap()
    }

    
    func setupLayout() {
        addConstraints([
            tipView.al_width == UIScreen.mainScreen().bounds.width - 20,
            tipView.al_centerX == al_centerX,
            tipView.al_height == 100,
            tipView.al_bottom == al_bottom - 70,
            
            messageLabel.al_centerX == tipView.al_centerX,
            messageLabel.al_height == 50,
            messageLabel.al_centerY == tipView.al_centerY,
            messageLabel.al_left == tipView.al_left + 40,
            messageLabel.al_right == tipView.al_right - 40,
            
            closeButton.al_top == tipView.al_top + 12,
            closeButton.al_right == tipView.al_right - 12,
            closeButton.al_height == 11,
            closeButton.al_width == 11,
            
            caretView.al_height == 30,
            caretView.al_width == 30,
            caretView.al_top == tipView.al_bottom - 15,
            caretView.al_centerX == tipView.al_centerX,
            
            whiteOvalView.al_width == 80,
            whiteOvalView.al_height == 80,
            whiteOvalView.al_centerX == al_centerX,
            whiteOvalView.al_top == tipView.al_bottom + 20,
            
            blackOutlineOvalView.al_width == 60,
            blackOutlineOvalView.al_height == 60,
            blackOutlineOvalView.al_centerX == whiteOvalView.al_centerX,
            blackOutlineOvalView.al_centerY == whiteOvalView.al_centerY
        ])
    }
}
