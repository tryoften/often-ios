//
//  ToolTip.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/29/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ToolTip: UIView, ToolTipViewControllerDelegate {
    var imageView: UIImageView
    var textView: UILabel
    var currentPage: Int?
    
    var pageImages = [
        UIImage(named: "artists")!,
        UIImage(named: "categories")!,
        UIImage(named: "letters")!,
        UIImage(named: "full access")!
    ]
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        
        textView = UILabel()
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        textView.userInteractionEnabled = false
        textView.textAlignment = .Center
        textView.numberOfLines = 2
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        textView.font = UIFont(name: "OpenSans", size: 13.0)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
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
            textView.al_width == 300,
            textView.al_height == 50,
            textView.al_bottom == al_bottom - 35
        ])

        if currentPage == 0 {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top + 1,
                imageView.al_centerX == al_centerX
            ]
            addConstraints(constraints)
        } else if currentPage == 3 {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top - 15,
                imageView.al_centerX == al_centerX
            ]
            addConstraints(constraints)
        } else {
            let constraints: [NSLayoutConstraint] = [
                imageView.al_bottom == textView.al_top - 3,
                imageView.al_centerX == al_centerX
            ]
            addConstraints(constraints)
        }
    }
}
