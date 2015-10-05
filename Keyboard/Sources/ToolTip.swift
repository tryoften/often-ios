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
        textView.textColor = UIColor.blackColor()
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
        addConstraints([
            textView.al_centerX == al_centerX,
            textView.al_width == 270,
            textView.al_height == 50,
            textView.al_bottom == al_bottom - 35
        ])
        
        if currentPage == 0 {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top + 1,
                imageView.al_centerX == al_centerX,
                imageView.al_width == 270,
                imageView.al_height == 80
            ]
            addConstraints(constraints)
        } else if currentPage == 1 {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top + 8,
                imageView.al_centerX == al_centerX,
                imageView.al_width == 250,
                imageView.al_height == 75
            ]
            addConstraints(constraints)
        } else if currentPage == 2 {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top + 8,
                imageView.al_centerX == al_centerX,
                imageView.al_width == 275,
                imageView.al_height == 75
            ]
            addConstraints(constraints)
        } else if currentPage == 3 {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top + 8,
                imageView.al_centerX == al_centerX,
                imageView.al_width == 265,
                imageView.al_height == 65
            ]
            addConstraints(constraints)
        } else {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top + 8,
                imageView.al_centerX == al_centerX,
                imageView.al_width == 275,
                imageView.al_height == 75
            ]
            addConstraints(constraints)
        }
    }
}
