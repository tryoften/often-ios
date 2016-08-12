//
//  FilterCollectionHeaderView.swift
//  Often
//
//  Created by Katelyn Findlay on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class FilterCollectionHeaderView: UIView {
    var dismissButton: UIButton
    var titleLabel: UILabel
    var topSeparator: UIView
    var bottomSeparator: UIView
    
    let attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.25),
        NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9.5)!,
        NSForegroundColorAttributeName: UIColor.oftBlack74Color()
    ]
    
    var titleText: String? {
        didSet {
            let attributedString = NSAttributedString(string: titleText!.uppercaseString, attributes: attributes)
            titleLabel.attributedText = attributedString
        }
    }
    
    override init(frame: CGRect) {
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(StyleKit.imageOfBackarrow(scale: 0.4), forState: .Normal)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topSeparator = UIView()
        topSeparator.backgroundColor = UIColor.oftWhiteTwoColor()
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor.oftWhiteTwoColor()
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        addSubview(dismissButton)
        addSubview(titleLabel)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        
        backgroundColor = WhiteColor
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            dismissButton.al_left == al_left,
            dismissButton.al_top == al_top - 7,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_height == 16,
            
            topSeparator.al_height == 0.5,
            topSeparator.al_left == al_left,
            topSeparator.al_right == al_right,
            topSeparator.al_top == al_top,
            
            bottomSeparator.al_height == topSeparator.al_height,
            bottomSeparator.al_left == al_left,
            bottomSeparator.al_right == al_right,
            bottomSeparator.al_bottom == al_bottom
        ])
    }
}
