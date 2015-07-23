//
//  KeyboardLayoutView.swift
//  Surf
//
//  Created by Luc Succes on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardLayoutView: UIView {
    var layout: KeyboardLayout
    var pageViews: [KeyboardPageView]
    var activePageView: KeyboardPageView? {
        didSet {
            for pageView in pageViews {
                pageView.hidden = pageView == activePageView ? false : true
            }
        }
    }
    
    var allKeys: [KeyboardKeyButton] {
        var keys = [KeyboardKeyButton]()
        
        for pageView in pageViews {
           keys += pageView.keys
        }
        
        return keys
    }
    
    var activePageKeys: [KeyboardKeyButton] {
        if let activePageView = activePageView {
            return activePageView.keys
        }
        return []
    }
    
    init(layout: KeyboardLayout) {
        self.layout = layout
        pageViews = []

        super.init(frame: CGRectZero)
        
        for page in layout.pages {
            var pageView = KeyboardPageView(page: page, containerView: self)
            pageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            pageViews.append(pageView)
            addSubview(pageView)
        }
        
        setActivePageViewWithIdentifier(.Letter)
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = []
        for pageView in pageViews {
            constraints += [
                pageView.al_width == al_width,
                pageView.al_height == al_height,
                pageView.al_top == al_top,
                pageView.al_left == al_left
            ]
        }
        addConstraints(constraints)
    }
    
    func setActivePageViewWithIdentifier(id: KeyboardPageIdentifier) {
        for pageView in pageViews {
            if id == pageView.page.id {
               activePageView = pageView
            }
        }
    }
}
