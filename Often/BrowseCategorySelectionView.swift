//
//  BrowseCategorySelectionView.swift
//  Often
//
//  Created by Komran Ghahremani on 6/15/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCategorySelectionView: UIView {
    var categoryTableViewController: BrowseCategorySelectionTableViewController
    
    override init(frame: CGRect) {
        categoryTableViewController = BrowseCategorySelectionTableViewController(style: .Plain)
        categoryTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.80)
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.backgroundColor = ClearColor
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            
            addSubview(blurEffectView)
        }
        
        addSubview(categoryTableViewController.view)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            categoryTableViewController.view.al_top == al_top,
            categoryTableViewController.view.al_left == al_left,
            categoryTableViewController.view.al_bottom == al_bottom,
            categoryTableViewController.view.al_right == al_right
        ])
    }
}
