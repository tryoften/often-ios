//
//  ToolTip.swift
//  Often
//
//  Created by Komran Ghahremani on 9/25/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class ToolTip: UIView {
    var tabBarIconImageView: UIImageView
    var textView: UILabel
    var currentPage: Int?
    
    override init(frame: CGRect) {
        tabBarIconImageView = UIImageView()
        tabBarIconImageView.translatesAutoresizingMaskIntoConstraints = false
        tabBarIconImageView.contentMode = .ScaleAspectFit
        tabBarIconImageView.clipsToBounds = true
        
        textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.userInteractionEnabled = false
        textView.textAlignment = .Center
        textView.numberOfLines = 2
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = WhiteColor
        textView.font = UIFont(name: "OpenSans", size: 12.0)
        
        super.init(frame: frame)
        
        backgroundColor = ClearColor
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tabBarIconImageView)
        addSubview(textView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            textView.al_centerX == al_centerX,
            textView.al_width == 270,
            textView.al_height == 55,
            textView.al_top == al_centerY + 10,
            
            tabBarIconImageView.al_centerX == al_centerX,
            tabBarIconImageView.al_bottom == textView.al_top - 5,
            tabBarIconImageView.al_width == 245,
            tabBarIconImageView.al_height == 70
        ]
        
        addConstraints(constraints)
    }
}
