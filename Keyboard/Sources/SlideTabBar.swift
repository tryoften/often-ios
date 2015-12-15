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
                width = UIScreen.mainScreen().bounds.width
            }

            return width / CGFloat(count)
        }
        return 0.0
    }

    var highlightBarEnabled: Bool {
        didSet {
            highlightBarView.hidden = highlightBarEnabled
        }
    }

    override var items: [UITabBarItem]? {
        didSet {
            if let constraint = highlightBarWidthConstraint {
                constraint.constant = highlightBarWidth
            } else {
                highlightBarWidthConstraint = highlightBarView.al_width == highlightBarWidth
                addConstraint(highlightBarWidthConstraint!)
            }

            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    override var selectedItem: UITabBarItem? {
        didSet {
            guard let items = items else {
                return
            }
            if let item = selectedItem, let index = items.indexOf(item) {
                highlightBarLeftConstraint?.constant = highlightBarWidth * CGFloat(index)
                UIView.animateWithDuration(0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }

    init(highlightBarEnabled enabled: Bool) {
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = TealColor

        self.highlightBarEnabled = enabled

        super.init(frame: CGRectZero)

        addSubview(highlightBarView)
        setupHighlightBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHighlightBar() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left

        addConstraints([
            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 4,
            
            highlightBarLeftConstraint!
        ])
    }
}