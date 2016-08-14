//
//  OnboardingProgressBar.swift
//  Often
//
//  Created by Katelyn Findlay on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class OnboardingProgressBar: UIView {
    
    var totalBar: UIView
    var progressBar: UIView
    var progressIndex: CGFloat
    var totalIndex: CGFloat
    
    init(progressIndex: CGFloat, endIndex: CGFloat, frame: CGRect) {
        totalBar = UIView()
        totalBar.translatesAutoresizingMaskIntoConstraints = false
        totalBar.backgroundColor = UIColor.oftWhiteFiveColor()
        
        progressBar = UIView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = TealColor
        
        self.progressIndex = progressIndex
        self.totalIndex = endIndex
        
        super.init(frame: frame)
        
        addSubview(totalBar)
        addSubview(progressBar)
        
        setupLayout()
    }
    
    func setupLayout() {
        let width = UIScreen.mainScreen().bounds.width * (progressIndex/totalIndex)
        
        addConstraints([
            totalBar.al_left == al_left,
            totalBar.al_right == al_right,
            totalBar.al_bottom == al_bottom,
            totalBar.al_top == al_top,
            
            progressBar.al_left == al_left,
            progressBar.al_top == al_top,
            progressBar.al_bottom == al_bottom,
            progressBar.al_width == width
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}