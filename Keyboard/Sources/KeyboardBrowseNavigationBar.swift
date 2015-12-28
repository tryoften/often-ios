//
//  KeyboardBrowseNavigationBar.swift
//  Often
//
//  Created by Komran Ghahremani on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardBrowseNavigationBar: UIView {
    var backArrowButton: UIButton
    var thumbnailImageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var rightDetailLabel: UILabel
    var moreOptionsButton: UIButton
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
        backArrowButton = UIButton()
        backArrowButton.translatesAutoresizingMaskIntoConstraints = false
        backArrowButton.setImage(UIImage(named: "backnavigation"), forState: .Normal)
        backArrowButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)
        
        thumbnailImageView = UIImageView()
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.layer.cornerRadius = 3.0
        thumbnailImageView.contentMode = .ScaleAspectFill
        thumbnailImageView.image = UIImage(named: "weeknd")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 12.0)
        titleLabel.text = "The Weeknd"
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 11.0)
        subtitleLabel.textColor = BlackColor
        subtitleLabel.text = "35 Songs"
        subtitleLabel.alpha = 0.54
        
        rightDetailLabel = UILabel()
        rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        rightDetailLabel.font = UIFont(name: "OpenSans-Semibold", size: 10.0)
        rightDetailLabel.textColor = LightGrey
        rightDetailLabel.text = "10 RESULTS"
        rightDetailLabel.alpha = 0.0
        
        moreOptionsButton = UIButton()
        moreOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        moreOptionsButton.setImage(UIImage(named: "more"), forState: .Normal)
        moreOptionsButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        backArrowButton.addTarget(self, action: "backSelected", forControlEvents: .TouchUpInside)
        moreOptionsButton.addTarget(self, action: "showOptions", forControlEvents: .TouchUpInside)
        
        addSubview(thumbnailImageView)
        addSubview(backArrowButton)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(rightDetailLabel)
        addSubview(moreOptionsButton)
        
        setupLayout()
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
            backArrowButton.al_left == al_left + 10,
            backArrowButton.al_centerY == al_centerY,
            backArrowButton.al_width == 29,
            backArrowButton.al_height == 13,
            
            thumbnailImageView.al_left == backArrowButton.al_right - 5,
            thumbnailImageView.al_centerY == al_centerY,
            thumbnailImageView.al_top == al_top + 10,
            thumbnailImageView.al_bottom == al_bottom - 10,
            thumbnailImageView.al_width == thumbnailImageView.al_height,
            
            titleLabel.al_left == thumbnailImageView.al_right + 10,
            titleLabel.al_bottom == thumbnailImageView.al_centerY,
            
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_top == thumbnailImageView.al_centerY,
            
            rightDetailLabel.al_right == al_right - 10,
            rightDetailLabel.al_centerY == al_centerY,
            
            moreOptionsButton.al_right == al_right - 10,
            moreOptionsButton.al_centerY == al_centerY,
            moreOptionsButton.al_width == 18,
            moreOptionsButton.al_height == 19
        ])
    }
}

protocol KeyboardBrowseNavigationDelegate {
    func backButtonSelected()
}
