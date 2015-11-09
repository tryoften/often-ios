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
        textView.textColor = UIColor.blackColor().colorWithAlphaComponent(0.74)
        textView.font = UIFont(name: "OpenSans", size: 12.0)
        
        super.init(frame: frame)
        
        backgroundColor = VeryLightGray
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
        var constraints: [NSLayoutConstraint] = [
            textView.al_centerX == al_centerX,
            textView.al_width == 270,
            textView.al_height == 55,
            textView.al_bottom == al_bottom - 36,
            imageView.al_centerX == al_centerX
        ]

        if currentPage == 0 || currentPage == 2 {
            constraints += [
                imageView.al_bottom == textView.al_top + 1,
                imageView.al_width == 225,
                imageView.al_height == 70
            ]
        } else if currentPage == 1 {
            constraints += [
                imageView.al_bottom == textView.al_top + 1,
                imageView.al_width == 200,
                imageView.al_height == 70
            ]
        } else if currentPage == 3 || currentPage == 4 {
            constraints += [
                imageView.al_bottom == textView.al_top + 1,
                imageView.al_width == 205,
                imageView.al_height == 70
            ]
        } else {
            constraints += [
                imageView.al_bottom == textView.al_top + 2,
                imageView.al_width == 225,
                imageView.al_height == 70
            ]
        }
        
        addConstraints(constraints)
    }
}
