//
//  HeaderButton.swift
//  Often
//
//  Created by Katelyn Findlay on 8/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class HeaderButton: UIButton {
    var textLabel: UILabel
    //    var buttonImageView: UIImageView
    
    var text: String? {
        didSet {
            textLabel.setTextWith(UIFont(name: "Montserrat", size: 10.5)!, letterSpacing: 1.0, color: WhiteColor, text: text!.uppercaseString)
        }
    }
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.textAlignment = .Left
        textLabel.backgroundColor = ClearColor
        
        super.init(frame: frame)
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

