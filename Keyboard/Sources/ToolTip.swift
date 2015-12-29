//
//  ToolTip.swift
//  Often
//
//  Created by Komran Ghahremani on 9/25/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class ToolTip: UIView, ToolTipViewControllerDelegate {
    var imageView: UIImageView
    var textView: UILabel
    var currentPage: Int?
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        
        textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.userInteractionEnabled = false
        textView.textAlignment = .Center
        textView.numberOfLines = 2
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = WhiteColor
        textView.font = UIFont(name: "OpenSans", size: 14.0)
        
        super.init(frame: frame)
        
        backgroundColor = ClearColor
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(textView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func delegateCurrentPage(currentPage: Int) {
        self.currentPage = currentPage
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            textView.al_centerX == al_centerX,
            textView.al_width == 270,
            textView.al_height == 55,
            textView.al_top == al_centerY + 10,
            
            imageView.al_centerX == al_centerX,
            imageView.al_bottom == textView.al_top - 5,
            imageView.al_width == 245,
            imageView.al_height == 70
        ]
        
        addConstraints(constraints)
    }
}
