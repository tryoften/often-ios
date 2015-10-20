//
//  TextMessageOnBoardingView.swift
//  Often
//
//  Created by Kervins Valcourt on 10/15/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class TextMessageOnBoardingView: UIView {
    var textMessageBubbleOne: UIImageView
    var textMessageBubbleTwo: UIImageView
    var instructionLabel: UILabel
    var dummyTextField: UITextField
    var instructionLabelTwo: UILabel
    var navBar: UIView
    var title: UILabel
    
    override init(frame: CGRect) {
        dummyTextField = UITextField()
        dummyTextField.translatesAutoresizingMaskIntoConstraints = false
        
        textMessageBubbleOne = UIImageView()
        textMessageBubbleOne.translatesAutoresizingMaskIntoConstraints = false
        textMessageBubbleOne.image = UIImage(named: "TextMessageBubble")!
        
        instructionLabel = UILabel()
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.font = UIFont(name: "OpenSans", size: 14)
        instructionLabel.text = "Let’s start using Often. From your keyboard, tap and hold the Globe icon to switch to Often."
        instructionLabel.backgroundColor = UIColor.clearColor()
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .Left
        instructionLabel.textColor = BlackColor
        
        textMessageBubbleTwo = UIImageView()
        textMessageBubbleTwo.translatesAutoresizingMaskIntoConstraints = false
        textMessageBubbleTwo.image = UIImage(named: "TextMessageBubble")!
        
        instructionLabelTwo = UILabel()
        instructionLabelTwo.font = UIFont(name: "OpenSans", size: 14)
        instructionLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        instructionLabelTwo.text = "Nice! Lets try sharing something. Tap on search, type “booty” and hit ENTR"
        instructionLabelTwo.backgroundColor = UIColor.clearColor()
        instructionLabelTwo.numberOfLines = 0
        instructionLabelTwo.textAlignment = .Left
        instructionLabelTwo.textColor = BlackColor
        
        navBar = UIView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = UIColor(fromHexString: "#152036")
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Bae"
        title.font = UIFont(name: "OpenSans-Semibold", size: 16)
        title.textColor = WhiteColor
        title.textAlignment = .Center
        
        super.init(frame: frame)
        backgroundColor = WhiteColor
        
        textMessageBubbleOne.addSubview(instructionLabel)
        textMessageBubbleTwo.addSubview(instructionLabelTwo)
        navBar.addSubview(title)
        
        addSubview(textMessageBubbleOne)
        addSubview(textMessageBubbleTwo)
        addSubview(dummyTextField)
        addSubview(navBar)
        
        setupLayout()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            dummyTextField.al_top == al_top - 100,
            
            navBar.al_top == al_top,
            navBar.al_left == al_left,
            navBar.al_right == al_right,
            navBar.al_height == 44,
            
            title.al_centerX == navBar.al_centerX,
            title.al_centerY == navBar.al_centerY,
            title.al_width == 60,
            
            textMessageBubbleOne.al_top == navBar.al_bottom + 20,
            textMessageBubbleOne.al_left == al_left + 20,
            textMessageBubbleOne.al_right == al_right - 40,
            textMessageBubbleOne.al_height == 100,
            
            instructionLabel.al_top == textMessageBubbleOne.al_top,
            instructionLabel.al_bottom == textMessageBubbleOne.al_bottom,
            instructionLabel.al_left == textMessageBubbleOne.al_left + 15,
            instructionLabel.al_right == textMessageBubbleOne.al_right - 10,
            
            textMessageBubbleTwo.al_top == textMessageBubbleOne.al_bottom + 10,
            textMessageBubbleTwo.al_left == al_left + 20,
            textMessageBubbleTwo.al_right == al_right - 40,
            textMessageBubbleTwo.al_height == 60,
            
            instructionLabelTwo.al_top == textMessageBubbleTwo.al_top,
            instructionLabelTwo.al_bottom == textMessageBubbleTwo.al_bottom,
            instructionLabelTwo.al_left == textMessageBubbleTwo.al_left + 15,
            instructionLabelTwo.al_right == textMessageBubbleTwo.al_right - 10
            ])
    }
    
}