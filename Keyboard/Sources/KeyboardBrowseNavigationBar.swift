//
//  KeyboardBrowseNavigationBar.swift
//  Often
//
//  Created by Komran Ghahremani on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit
import Nuke

class KeyboardBrowseNavigationBar: UIView {
    var backArrowView: UIImageView
    var thumbnailImageButton: UIButton
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var rightDetailLabel: UILabel
    var moreOptionsButton: UIButton
    var bottomSeperator: UIView
    var imageURL: URL? {
        willSet(newValue) {
            if let url = newValue where imageURL != newValue {
                thumbnailImageButton.imageView?.nk_setImageWith(url)
            }
        }
    }
    var shouldDisplayOptions: Bool? {
        didSet(value) {
            if self.shouldDisplayOptions == false {
                rightDetailLabel.alpha = 1
                moreOptionsButton.alpha = 0
                moreOptionsButton.isUserInteractionEnabled = false
            } else {
                rightDetailLabel.alpha = 0
                moreOptionsButton.alpha = 1
                moreOptionsButton.isUserInteractionEnabled = true
            }
        }
    }

    override init(frame: CGRect) {
        backArrowView = UIImageView()
        backArrowView.translatesAutoresizingMaskIntoConstraints = false
        backArrowView.image = UIImage(named: "backnavigation")
        
        thumbnailImageButton = UIButton()
        thumbnailImageButton.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageButton.layer.cornerRadius = 3.0
        thumbnailImageButton.contentMode = .scaleAspectFill
        thumbnailImageButton.clipsToBounds = true
        thumbnailImageButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 36.0, 0.0, 0.0)
        thumbnailImageButton.setImage(UIImage(named: "placeholder"), for: UIControlState())
        thumbnailImageButton.imageView?.layer.cornerRadius = 3.0
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 12.0)
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 10.5)
        subtitleLabel.textColor = BlackColor
        subtitleLabel.alpha = 0.54
        
        rightDetailLabel = UILabel()
        rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        rightDetailLabel.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        rightDetailLabel.textColor = BlackColor
        rightDetailLabel.alpha = 0.0

        moreOptionsButton = UIButton()
        moreOptionsButton.isHidden = true
        moreOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        moreOptionsButton.setImage(UIImage(named: "more"), for: UIControlState())
        moreOptionsButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)
        
        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        thumbnailImageButton.addTarget(self, action: #selector(KeyboardBrowseNavigationBar.backSelected), for: .touchUpInside)
        moreOptionsButton.addTarget(self, action: #selector(KeyboardBrowseNavigationBar.showOptions), for: .touchUpInside)
        
        addSubview(backArrowView)
        addSubview(thumbnailImageButton)
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
        
        bottomSeperator.frame = CGRect(x: 0, y: frame.height - 0.6, width: frame.width, height: 0.6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backSelected() {
        
    }
    
    func showOptions() {
        print("Show the Options")
    }
    
    func setupLayout() {
        var constraints = [
            backArrowView.al_left == al_left + 12,
            backArrowView.al_centerY == al_centerY,
            backArrowView.al_width == 9,
            backArrowView.al_height == 12
        ]

        constraints += [
            thumbnailImageButton.al_left == al_left,
            thumbnailImageButton.al_centerY == al_centerY,
            thumbnailImageButton.al_top == al_top + 10,
            thumbnailImageButton.al_bottom == al_bottom - 10,
            thumbnailImageButton.al_width == thumbnailImageButton.al_height + 36
        ]

        constraints += [
            titleLabel.al_left == thumbnailImageButton.al_right + 12,
            titleLabel.al_bottom == thumbnailImageButton.al_centerY
        ]

        constraints += [
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_top == thumbnailImageButton.al_centerY
        ]

        constraints += [
            rightDetailLabel.al_right == al_right - 10,
            rightDetailLabel.al_centerY == al_centerY
        ]

        constraints += [
            moreOptionsButton.al_right == al_right - 12,
            moreOptionsButton.al_centerY == al_centerY,
            moreOptionsButton.al_width == 18,
            moreOptionsButton.al_height == 18
        ]

        addConstraints(constraints)
    }
}
