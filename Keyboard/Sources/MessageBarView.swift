//
//  MessageBarView.swift
//  Often
//
//  Created by Komran Ghahremani on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class MessageBarView: UIView {

    var messageLabel: UILabel
    var closeButton: UIButton
    var delegate: MessageBarDelegate?
    
    override init(frame: CGRect) {
        
        messageLabel = UILabel()
        messageLabel.font = UIFont(name: "OpenSans", size: 12)
        messageLabel.text = "To see search results. please allow Full-Access!"
        messageLabel.userInteractionEnabled = false
        messageLabel.textColor = WhiteColor
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close-white"), forState: .Normal)
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#152036")
        translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        
        addSubview(messageLabel)
        addSubview(closeButton)
    }
    
    override func layoutSubviews() {
        messageLabel.frame = CGRectInset(bounds, 15, 0)
        closeButton.frame = CGRectMake(CGRectGetMaxX(bounds) - 35, 13, 15, 15)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeTapped() {
        delegate?.hideMessageBar()
    }
}

protocol MessageBarDelegate {
    func showMessageBar()
    func hideMessageBar()
}
