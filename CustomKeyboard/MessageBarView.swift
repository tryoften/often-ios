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
    var closeButton: UIButton
    
    override init(frame: CGRect) {
        
        messageLabel = UILabel()
        messageLabel.font = UIFont(name: "OpenSans", size: 12)
        messageLabel.text = "For the best experience, please allow Full Access!"
        messageLabel.userInteractionEnabled = false
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), forState: .Normal)

        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#F9B341").colorWithAlphaComponent(0.95)
        addSubview(messageLabel)
        addSubview(closeButton)
    }
    
    override func layoutSubviews() {
        messageLabel.frame = CGRectInset(bounds, 10, 0)
        closeButton.frame = CGRectMake(CGRectGetMaxX(bounds) - 35, 15, 15, 15)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
