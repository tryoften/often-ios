//
//  LocalNotificationsAlertView.swift
//  Often
//
//  Created by Kervins Valcourt on 10/13/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Spring

class LocalNotificationsAlertView: SpringView {
    var iconImageView: UIImageView
    var alertViewLabel: UILabel
    var noButton: UIButton
    var yesButton: UIButton
    var labelBackgroundColor: UIView
    var spaceOne: UIView
    var spaceTwo: UIView
    var spaceThree: UIView
    
    override init(frame: CGRect) {
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .ScaleAspectFit
        iconImageView.image = UIImage(named: "NotificationIcon")
        
        alertViewLabel = UILabel()
        alertViewLabel.translatesAutoresizingMaskIntoConstraints = false
        alertViewLabel.font = UIFont(name: "OpenSans", size: 14)
        alertViewLabel.text = "Would you like help setting up your keyboard? We can give you step by step instructions :)"
        alertViewLabel.numberOfLines = 0
        alertViewLabel.textAlignment = .Center
        
        labelBackgroundColor = UIView()
        labelBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        labelBackgroundColor.backgroundColor = WhiteColor
        labelBackgroundColor.layer.cornerRadius = 5.0
        
        spaceOne = UIView()
        spaceOne.translatesAutoresizingMaskIntoConstraints = false
        spaceOne.backgroundColor = WhiteColor
        
        spaceTwo = UIView()
        spaceTwo.translatesAutoresizingMaskIntoConstraints = false
        spaceTwo.backgroundColor = DarkGrey
        
        spaceThree = UIView()
        spaceThree.translatesAutoresizingMaskIntoConstraints = false
        spaceThree.backgroundColor = DarkGrey
        
        noButton = UIButton()
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.setTitle("No Thanks", forState: .Normal)
        noButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 14.0)
        noButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        noButton.backgroundColor = UIColor.clearColor()
        noButton.titleLabel?.textAlignment = .Center
        noButton.layer.cornerRadius = 5.0
    
        yesButton = UIButton()
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.setTitle("Yes Please!", forState: .Normal)
        yesButton.setTitleColor(UIColor(fromHexString: "#2786EE"), forState: .Normal)
        yesButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 14.0)
        yesButton.backgroundColor = UIColor.clearColor()
        yesButton.titleLabel?.textAlignment = .Center
        yesButton.layer.cornerRadius = 5.0
        
        super.init(frame: frame)
        
        backgroundColor = VeryLightGray
        
        animation = "slideUp"
        curve = "easeOut"
        duration = 0.7
        force = 2.0
        
        addSubview(labelBackgroundColor)
        addSubview(iconImageView)
        addSubview(spaceThree)
        addSubview(noButton)
        addSubview(yesButton)
        addSubview(spaceOne)
        addSubview(spaceTwo)
        
        labelBackgroundColor.addSubview(alertViewLabel)
        
        setupLayout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            iconImageView.al_width == 90,
            iconImageView.al_height == 90,
            iconImageView.al_top == al_top - 45,
            iconImageView.al_centerX == al_centerX,
            
            labelBackgroundColor.al_top == al_top ,
            labelBackgroundColor.al_left == al_left,
            labelBackgroundColor.al_right == al_right,
            labelBackgroundColor.al_height == 150,
            
            spaceOne.al_top == labelBackgroundColor.al_bottom - 10,
            spaceOne.al_left == al_left,
            spaceOne.al_right == al_right,
            spaceOne.al_height == 12,
            
            spaceTwo.al_top == spaceOne.al_bottom ,
            spaceTwo.al_left == al_left,
            spaceTwo.al_right == al_right,
            spaceTwo.al_height == 0.5,
            
            spaceOne.al_top == labelBackgroundColor.al_bottom - 10,
            spaceOne.al_left == al_left,
            spaceOne.al_right == al_right,
            spaceOne.al_height == 12,
            
            alertViewLabel.al_top == iconImageView.al_bottom + 20,
            alertViewLabel.al_left == al_left + 40,
            alertViewLabel.al_right == al_right - 40,
            alertViewLabel.al_height == 60,
            
            noButton.al_height == 50,
            noButton.al_width == al_width/2,
            noButton.al_left == al_left,
            noButton.al_right == yesButton.al_left,
            noButton.al_bottom == al_bottom,
            
            spaceThree.al_bottom == al_bottom,
            spaceThree.al_left == noButton.al_right,
            spaceThree.al_right == yesButton.al_left,
            spaceThree.al_height == yesButton.al_height,
            spaceThree.al_width == 0.5,
            
            yesButton.al_height == 50,
            yesButton.al_width == al_width/2,
            yesButton.al_right == al_right,
            yesButton.al_left == noButton.al_right,
            yesButton.al_bottom == al_bottom,
            
            ])
    }
}
