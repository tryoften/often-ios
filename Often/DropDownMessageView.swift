//
//  DropDownMessageView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/16/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class DropDownMessageView: UIView {
    var textLabel: UILabel
    var text: String {
        didSet {
            textLabel.text = self.text
        }
    }
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = WhiteColor
        textLabel.textAlignment = .Center
        textLabel.font = UIFont(name: "Montserrat", size: 13.0)
        
        text = ""
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#E95769")
        
        addSubview(textLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            textLabel.al_centerX == al_centerX,
            textLabel.al_centerY == al_centerY + 10
        ])
    }
}