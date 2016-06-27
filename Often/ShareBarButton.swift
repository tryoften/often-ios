//
//  ShareBarButton.swift
//  Often
//
//  Created by Komran Ghahremani on 6/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class ShareBarButton: UIButton {
    var textLabel: UILabel
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.font = UIFont(name: "Montserrat", size: 12.0)
        textLabel.textColor = WhiteColor
        textLabel.text = "SHARE"
        textLabel.textAlignment = .center
        textLabel.backgroundColor = ClearColor
        textLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        super.init(frame: frame)
        
        setImage(StyleKit.imageOfShare(color: WhiteColor), for: UIControlState())
        imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
