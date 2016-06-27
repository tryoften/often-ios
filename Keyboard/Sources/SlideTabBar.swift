//
//  SlideTabBar.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation


class SlideTabBar: UITabBar {
    private var highlightBarView: UIView
    private var highlightBarLeftConstraint: NSLayoutConstraint?
    private var highlightBarWidthConstraint: NSLayoutConstraint?

    private var highlightBarWidth: CGFloat {
        if let count = items?.count where count > 0 {
            var width: CGFloat = bounds.size.width

            if width == 0 {
                width = UIScreen.main().bounds.width
            }

            return width / CGFloat(count)
        }
        return 0.0
    }
    
    var topSeperator: UIView
    var bottomSeperator: UIView

    var highlightBarEnabled: Bool {
        didSet {
            highlightBarView.isHidden = highlightBarEnabled
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
        
        repositionSlideBar()
        topSeperator.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0.6)
        bottomSeperator.frame = CGRect(x: 0, y: frame.height - 0.6, width: frame.width, height: 0.6)
    }

    override var items: [UITabBarItem]? {
        didSet {
            if let constraint = highlightBarWidthConstraint {
                removeConstraint(constraint)
            }
            let count = items?.count ?? 1
            highlightBarWidthConstraint = highlightBarView.al_width == al_width / CGFloat(count)
            addConstraint(highlightBarWidthConstraint!)

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    override var selectedItem: UITabBarItem? {
        didSet {
            repositionSlideBar()
        }
    }
    
    func repositionSlideBar() {
        guard let items = items else {
            return
        }
        if let item = selectedItem, let index = items.index(of: item) {
            highlightBarLeftConstraint?.constant = highlightBarWidth * CGFloat(index)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    init(highlightBarEnabled enabled: Bool) {
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = UIColor.oftBrightLavenderColor()
        
        topSeperator = UIView()
        topSeperator.backgroundColor = LightGrey
        
        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = LightGrey

        self.highlightBarEnabled = enabled

        super.init(frame: CGRect.zero)

        addSubview(highlightBarView)
        setupHighlightBar()
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        backgroundColor = UIColor.white()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHighlightBar() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left

        addConstraints([
            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 3,
            
            highlightBarLeftConstraint!
        ])
    }
}
