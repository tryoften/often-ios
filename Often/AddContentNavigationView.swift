//
//  AddQuoteNavigationView.swift
//  Often
//
//  Created by Katelyn Findlay on 7/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddContentNavigationView: UIView {

    var leftButton: UIButton
    var rightButton: UIButton
    var titleLabel: UILabel
    
    let leftAttributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 0.2),
        NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!,
        NSForegroundColorAttributeName: BlackColor
    ]
    
    let rightAttributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 0.2),
        NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!,
        NSForegroundColorAttributeName: UIColor.oftBrightLavenderColor()
    ]
    
    let rightAttributesDisabled: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 0.2),
        NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!,
        NSForegroundColorAttributeName: UIColor.lightGrayColor()
    ]
    
    override init(frame: CGRect) {
        leftButton = UIButton()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        
        rightButton = UIButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.enabled = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!, letterSpacing: 0.5, color: BlackColor, text: "Add Quote")
        
        super.init(frame: frame)
        
        setRightButtonText("Next")
        setLeftButtonText("Cancel")
        
        backgroundColor = UIColor.oftWhiteThreeColor()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.oftWhiteTwoColor().CGColor
        
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(titleLabel)
        
        setupLayout()
    }
    
    func setRightButtonText(text: String) {
        let attributedString = NSAttributedString(string: text, attributes: rightAttributes)
        let attributedStringDisabled = NSAttributedString(string: text, attributes: rightAttributesDisabled)
        rightButton.setAttributedTitle(attributedString, forState: .Normal)
        rightButton.setAttributedTitle(attributedStringDisabled, forState: .Disabled)
    }
    
    func setLeftButtonText(text: String) {
        let attributedString = NSAttributedString(string: text, attributes: leftAttributes)
        leftButton.setAttributedTitle(attributedString, forState: .Normal)
    }
    
    func setTitleText(text: String) {
        titleLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!, letterSpacing: 0.5, color: BlackColor, text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY + 10,
            
            leftButton.al_left == al_left + 19,
            leftButton.al_centerY == al_centerY + 10,
            
            rightButton.al_right == al_right - 19,
            rightButton.al_centerY == al_centerY + 10
        ])
    }
}