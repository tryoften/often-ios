//
//  PackBrowseHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackBrowseHeaderView: UICollectionReusableView {
    var browsePicker: PackBrowseHeaderCollectionViewController
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var actionButton: UIButton // Download or Buy
    var underlineButton: UIButton
    var sectionHeaderView: PackBrowseSectionHeaderView
    
    override init(frame: CGRect) {
        browsePicker = PackBrowseHeaderCollectionViewController()
        browsePicker.view.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 16.0)
        titleLabel.textColor = BlackColor
        titleLabel.textAlignment = .Center
        titleLabel.text = "my voice".uppercaseString
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans", size: 10.5)
        subtitleLabel.textColor = BlackColor
        subtitleLabel.textAlignment = .Center
        subtitleLabel.text = "Share quotes from Angie Martinez's new book \"My Voice\""
        
        actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = BlackColor
        actionButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 9.0)
        actionButton.layer.cornerRadius = 15
        actionButton.setTitle("BUY $0.99", forState: .Normal)
        actionButton.setTitleColor(WhiteColor, forState: .Normal)
        
        sectionHeaderView = PackBrowseSectionHeaderView()
        sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderView.leftLabel.text = "featured packs".uppercaseString
        sectionHeaderView.rightLabel.text = "(5)"
        
        underlineButton = UIButton()
        
        if let font = UIFont(name: "OpenSans-Semibold", size: 9.0) {
            let attributes = [
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : BlackColor,
                NSUnderlineStyleAttributeName : 1,
                NSKernAttributeName: 1
            ]
            let buttonTitle = NSMutableAttributedString(string: "")
            let buttonTitleString = NSMutableAttributedString(string: "try sample".uppercaseString, attributes: attributes)
            
            underlineButton.translatesAutoresizingMaskIntoConstraints = false
            buttonTitle.appendAttributedString(buttonTitleString)
            underlineButton.setAttributedTitle(buttonTitle, forState: .Normal)
        }
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        addSubview(browsePicker.view)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionButton)
        addSubview(sectionHeaderView)
        addSubview(underlineButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            
            UIView.animateWithDuration(0.3) {
                if progressiveness <= 0.8 {
                    let val = progressiveness - 0.3
                    self.browsePicker.view.alpha = val
                } else {
                    self.browsePicker.view.alpha = 1.0
                }
            }
        }
    }
    
    func setupLayout() {
        addConstraints([
            browsePicker.view.al_top == al_top + 20,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_bottom == al_bottom - 110,
            browsePicker.view.al_height <= 370,
            
            titleLabel.al_top == browsePicker.view.al_bottom - 35,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom + 5,
            subtitleLabel.al_centerX == al_centerX,
            
            actionButton.al_top == subtitleLabel.al_bottom + 19,
            actionButton.al_centerX == al_centerX,
            actionButton.al_width == 104,
            actionButton.al_height == 30,
            
            underlineButton.al_centerX == al_centerX,
            underlineButton.al_top == actionButton.al_bottom + 10,
            
            sectionHeaderView.al_top == al_top,
            sectionHeaderView.al_right == al_right,
            sectionHeaderView.al_left == al_left,
            sectionHeaderView.al_height == 35,
        ])
    }
}
