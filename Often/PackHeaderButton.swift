//
//  ShareBarButton.swift
//  Often
//
//  Created by Komran Ghahremani on 6/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackHeaderButton: UIButton {
    var textLabel: UILabel
//    var buttonImageView: UIImageView
    
    var text: String? {
        didSet {
            textLabel.setTextWith(UIFont(name: "Montserrat", size: 10.5)!, letterSpacing: 1.0, color: WhiteColor, text: text!.uppercaseString)
        }
    }
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.textAlignment = .Center
        textLabel.backgroundColor = ClearColor
        textLabel.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        buttonImageView = UIImageView()
//        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 2, right: 0)
        self.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        
//        addSubview(buttonImageView)
        addSubview(textLabel)
    }
//    
//    override func layoutSubviews() {
//        addConstraints([
//            textLabel.al_left == al_left,
//            textLabel.al_centerY == al_centerY,
////            textLabel.al_height == 25,
//            
//            buttonImageView.al_right == al_right,
//            buttonImageView.al_centerY == al_centerY,
//            buttonImageView.al_left == textLabel.al_right + 3,
//            buttonImageView.al_width == 25,
//            buttonImageView.al_height == buttonImageView.al_width
//            
//        ])
//        
//        
//        
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
