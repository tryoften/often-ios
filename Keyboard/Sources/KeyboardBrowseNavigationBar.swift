//
//  KeyboardBrowseNavigationBar.swift
//  Often
//
//  Created by Komran Ghahremani on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardBrowseNavigationBar: UIView {
    var backArrowView: UIImageView
    var thumbnailImageButton: UIButton
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var rightDetailLabel: UILabel
    var moreOptionsButton: UIButton
    var bottomSeperator: UIView
    var shouldDisplayOptions: Bool? {
        didSet(value) {
            if self.shouldDisplayOptions == false {
                rightDetailLabel.alpha = 1
                moreOptionsButton.alpha = 0
                moreOptionsButton.userInteractionEnabled = false
            } else {
                rightDetailLabel.alpha = 0
                moreOptionsButton.alpha = 1
                moreOptionsButton.userInteractionEnabled = true
            }
        }
    }
    
    var browseDelegate: KeyboardBrowseNavigationDelegate?
    
    override init(frame: CGRect) {
        backArrowView = UIImageView()
        backArrowView.translatesAutoresizingMaskIntoConstraints = false
        backArrowView.image = UIImage(named: "backnavigation")
        
        thumbnailImageButton = UIButton()
        thumbnailImageButton.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageButton.layer.cornerRadius = 3.0
        thumbnailImageButton.contentMode = .ScaleAspectFill
        thumbnailImageButton.setImage(UIImage(named: "weeknd"), forState: .Normal)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 12.0)
        titleLabel.text = "The Weeknd"
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 10.5)
        subtitleLabel.textColor = BlackColor
        subtitleLabel.text = "35 Songs"
        subtitleLabel.alpha = 0.54
        
        rightDetailLabel = UILabel()
        rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        rightDetailLabel.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        rightDetailLabel.textColor = BlackColor
        rightDetailLabel.text = "10 LYRICS"
        rightDetailLabel.alpha = 0.0
        
        moreOptionsButton = UIButton()
        moreOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        moreOptionsButton.setImage(UIImage(named: "more"), forState: .Normal)
        moreOptionsButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)
        
        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        thumbnailImageButton.addTarget(self, action: "backSelected", forControlEvents: .TouchUpInside)
        moreOptionsButton.addTarget(self, action: "showOptions", forControlEvents: .TouchUpInside)
        
        addSubview(thumbnailImageButton)
        addSubview(backArrowView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(rightDetailLabel)
        addSubview(moreOptionsButton)
        addSubview(bottomSeperator)
        
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
        
        bottomSeperator.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.6, CGRectGetWidth(frame), 0.6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backSelected() {
        browseDelegate?.backButtonSelected()
    }
    
    func showOptions() {
        print("Show the Options")
    }
    
    func setupLayout() {
        addConstraints([
            backArrowView.al_left == al_left + 12,
            backArrowView.al_centerY == al_centerY,
            backArrowView.al_width == 29,
            backArrowView.al_height == 14,
            
            thumbnailImageButton.al_left == backArrowView.al_right - 5,
            thumbnailImageButton.al_centerY == al_centerY,
            thumbnailImageButton.al_top == al_top + 10,
            thumbnailImageButton.al_bottom == al_bottom - 10,
            thumbnailImageButton.al_width == thumbnailImageButton.al_height,
            
            titleLabel.al_left == thumbnailImageButton.al_right + 12,
            titleLabel.al_bottom == thumbnailImageButton.al_centerY,
            
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_top == thumbnailImageButton.al_centerY,
            
            rightDetailLabel.al_right == al_right - 10,
            rightDetailLabel.al_centerY == al_centerY,
            
            moreOptionsButton.al_right == al_right - 12,
            moreOptionsButton.al_centerY == al_centerY,
            moreOptionsButton.al_width == 18,
            moreOptionsButton.al_height == 18
        ])
    }
}

protocol KeyboardBrowseNavigationDelegate {
    func backButtonSelected()
}
