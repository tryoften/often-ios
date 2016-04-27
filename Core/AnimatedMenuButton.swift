//
//  AnimatedMenuButton.swift
//  Often
//
//  Created by Katelyn Findlay on 4/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Material

enum AnimatedMenuItem: Int {
    case Gifs = 0
    case Quotes = 1
    case Categories = 2
    case Packs = 3
}

class AnimatedMenuButton: UIView {
    var buttonLabel: UILabel
    var button: FabButton
    var buttonSize: CGFloat
    
    var buttonImage: UIImage? {
        didSet {
            button.setImage(buttonImage, forState: .Normal)
        }
    }
    
    var selected: Bool {
        didSet {
            button.selected = self.selected
            if button.selected && (button.tag == AnimatedMenuItem.Gifs.rawValue || button.tag == AnimatedMenuItem.Quotes.rawValue)  {
                button.borderColor = TealColor
            } else {
                button.borderColor = ClearColor
            }
        }
    }
    
    var buttonLabelText: String? {
        didSet {
            buttonLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 9.0)!, letterSpacing: 1.0, color: WhiteColor, text: buttonLabelText!.uppercaseString)
        }
    }
    
    override init(frame: CGRect) {
        
        buttonLabel = UILabel()
        buttonLabelText = "Placeholder"
        buttonLabel.textAlignment = .Right
        button = FabButton()
        button.backgroundColor = WhiteColor
        button.borderWidth = 3
        button.borderColor = ClearColor
        selected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonSize = 40
        #if KEYBOARD
            buttonSize = 30
        #endif

        super.init(frame: frame)
        
        addSubview(buttonLabel)
        addSubview(button)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            button.al_right == al_right,
            button.al_centerY == al_centerY,
            button.al_width == buttonSize,
            button.al_height == button.al_width,
            
            buttonLabel.al_right == button.al_left - 12,
            buttonLabel.al_centerY == al_centerY,
            buttonLabel.al_height == 8
        ])
    }
    
}
