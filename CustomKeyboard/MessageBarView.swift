//
//  MessageBarView.swift
//  Drizzy
//
//  Created by Luc Succes on 7/1/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class MessageBarView: UIView {
    
    var messageLabel: UILabel
    
    override init(frame: CGRect) {
        
        messageLabel = UILabel()
        messageLabel.font = UIFont(name: "Lato-Regular", size: 12)
        messageLabel.text = "For the latest content, enable Full Access please"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#f19720")
        addSubview(messageLabel)
        
    }
    
    override func layoutSubviews() {
        messageLabel.frame = CGRectInset(bounds, -10, 0)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
