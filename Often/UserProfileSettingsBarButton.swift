//
//  UserProfileSettingsBarButton.swift
//  Often
//
//  Created by Komran Ghahremani on 8/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileSettingsBarButton: UIButton {
    var textLabel: UILabel
    var buttonImage: UIImageView
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .Center
        textLabel.backgroundColor = ClearColor
        
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 11.0)!,
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
        ]
        
        textLabel.attributedText = NSMutableAttributedString(string: "settings".uppercaseString, attributes: attributes)
        
        buttonImage = UIImageView()
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        buttonImage.image = StyleKit.imageOfSettingsDiamond(color: UIColor.lightGrayColor())
        
        super.init(frame: frame)
        
        addSubview(textLabel)
        addSubview(buttonImage)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            textLabel.al_left == al_left,
            textLabel.al_top == al_top,
            textLabel.al_bottom == al_bottom,
            textLabel.al_right == buttonImage.al_left - 2,
            
            buttonImage.al_right == al_right,
            buttonImage.al_centerY == textLabel.al_centerY,
            buttonImage.al_width == 22,
            buttonImage.al_height == buttonImage.al_width
        ])
    }
}
