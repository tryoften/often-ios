//
//  VenmoRequestOrPayView.swift
//  Surf
//
//  Created by Luc Succes on 7/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoRequestOrPayView: UIView {
    var requestButton: UIButton
    var payButton: UIButton
    var seperatorView: UIView
    
    var active: Bool {
        didSet {
            UIView.animateWithDuration(0.3) {
                if self.active {
                    self.backgroundColor = UIColor(fromHexString: "#4D97D2")
                } else {
                    self.backgroundColor = DarkGrey
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        requestButton = UIButton()
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        requestButton.setTitle("Request", forState: .Normal)
        requestButton.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size: 16)

        payButton = UIButton()
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        payButton.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size: 16)
        payButton.setTitle("Pay", forState: .Normal)
        
        seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor.whiteColor()

        active = false

        super.init(frame: frame)
        
        backgroundColor = DarkGrey

        addSubview(requestButton)
        addSubview(payButton)
        addSubview(seperatorView)
        
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            requestButton.al_left == al_left,
            requestButton.al_width == al_width/2,
            requestButton.al_top == al_top,
            requestButton.al_bottom == al_bottom,
            
            payButton.al_right == al_right,
            payButton.al_width == al_width/2,
            payButton.al_top == al_top,
            payButton.al_bottom == al_bottom,
            
            seperatorView.al_width == 2,
            seperatorView.al_centerX == al_centerX,
            seperatorView.al_height == al_height - 20,
            seperatorView.al_centerY == al_centerY
        ])
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
