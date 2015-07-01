//
//  ToolTip.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/29/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ToolTip: UIView {
    var imageView: UIImageView
    var textView: UITextView
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        
        textView = UITextView()
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        textView.editable = false
        textView.textAlignment = .Center
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        textView.font = UIFont(name: "OpenSans", size: 13.0)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addSubview(imageView)
        addSubview(textView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            imageView.al_bottom == textView.al_top,
            imageView.al_centerX == al_centerX,
            
            textView.al_centerX == al_centerX,
            textView.al_width == 250,
            textView.al_height == 45,
            textView.al_bottom == al_bottom - 40
        ]
        addConstraints(constraints)
    }
}
