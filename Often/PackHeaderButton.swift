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
    var text: String {
        didSet {
            textLabel.setTextWith(UIFont(name: "Montserrat", size: 9.0)!, letterSpacing: 1.0, color: WhiteColor, text: text)
        }
    }
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        text = "SHARE"
        textLabel.textAlignment = .Center
        textLabel.backgroundColor = ClearColor
        textLabel.frame = CGRectMake(0, 0, 150, 30)
        
        super.init(frame: frame)
        
        setImage(StyleKit.imageOfShare(color: WhiteColor), forState: .Normal)
        imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        self.frame = CGRectMake(0, 0, 100, 30)
        
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
