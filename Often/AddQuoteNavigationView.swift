//
//  AddQuoteNavigationView.swift
//  Often
//
//  Created by Katelyn Findlay on 7/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddQuoteNavigationView: UIView {

    var cancelButton: UIButton
    var addButton: UIButton
    var titleLabel: UILabel
    
    let cancelAttributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 0.2),
        NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!,
        NSForegroundColorAttributeName: BlackColor
    ]
    
    let addAttributesEnabled: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 0.2),
        NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!,
        NSForegroundColorAttributeName: UIColor.oftBrightLavenderColor()
    ]
    
    let addAttributesDisabled: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 0.2),
        NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!,
        NSForegroundColorAttributeName: UIColor.lightGrayColor()
    ]
    
    override init(frame: CGRect) {
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        let cancelString = NSAttributedString(string: "Cancel", attributes: cancelAttributes)
        cancelButton.setAttributedTitle(cancelString, forState: .Normal)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let addString = NSAttributedString(string: "Add", attributes: addAttributesEnabled)
        let addStringDisabled = NSAttributedString(string: "Add", attributes: addAttributesDisabled)
        addButton.setAttributedTitle(addString, forState: .Normal)
        addButton.setAttributedTitle(addStringDisabled, forState: .Disabled)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!, letterSpacing: 0.5, color: BlackColor, text: "Add Quote")
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.oftWhiteThreeColor()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.oftWhiteTwoColor().CGColor
        
        addSubview(cancelButton)
        addSubview(addButton)
        addSubview(titleLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY + 10,
            
            cancelButton.al_left == al_left + 19,
            cancelButton.al_centerY == al_centerY + 10,
            
            addButton.al_right == al_right - 19,
            addButton.al_centerY == al_centerY + 10
        ])
    }
}