//
//  PackPageHeaderView.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackPageHeaderView : MediaItemPageHeaderView {
    
    var priceButton: UIButton
    var sampleButton: UIButton
    var backLabel: UILabel
    
    override init(frame: CGRect) {
        
        var attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 9)!,
            NSForegroundColorAttributeName: UIColor.oftWhiteColor()
        ]
        let browsePacksString = NSAttributedString(string: "browse packs".uppercaseString, attributes: attributes)
        
        backLabel = UILabel()
        backLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        backLabel.textColor = TrendingHeaderViewNameLabelTextColor
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backLabel.attributedText = browsePacksString
        
        attributes[NSFontAttributeName] = UIFont(name: "OpenSans-Bold", size: 7.0)!
        let sampleString = NSAttributedString(string: "try sample".uppercaseString, attributes: attributes)
        
        sampleButton = UIButton()
        sampleButton.translatesAutoresizingMaskIntoConstraints = false
        sampleButton.setAttributedTitle(sampleString, forState: .Normal)
        sampleButton.backgroundColor = ClearColor
        sampleButton.layer.borderWidth = 1.5
        sampleButton.layer.borderColor = WhiteColor.CGColor
        sampleButton.layer.cornerRadius = 11.25
        
        priceButton = UIButton()
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.backgroundColor = TealColor
        priceButton.layer.cornerRadius = 15
        
        super.init(frame: frame)
        
        subtitleLabel.numberOfLines = 2
        
        addSubview(backLabel)
        addSubview(sampleButton)
        addSubview(priceButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            
            UIView.beginAnimations("", context: nil)
            
            if progressiveness <= 0.58 {
                self.subtitleLabel.alpha = 0
                self.priceButton.alpha = 0
                self.backLabel.alpha = 0
                self.sampleButton.alpha = 0
                
            } else {
                self.subtitleLabel.alpha = 1
                self.priceButton.alpha = 1
                self.backLabel.alpha = 1
                self.sampleButton.alpha = 1
            }
            
            UIView.commitAnimations()
        }
    }
    
    override func setupLayout() {
        addConstraints([
            coverPhoto.al_top == al_top,
            coverPhoto.al_left == al_left,
            coverPhoto.al_width == al_width,
            coverPhoto.al_height == al_height,
            
            coverPhotoTintView.al_width == coverPhoto.al_width,
            coverPhotoTintView.al_height == coverPhoto.al_height,
            coverPhotoTintView.al_left == coverPhoto.al_left,
            coverPhotoTintView.al_top == coverPhoto.al_top,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY - 20,
            titleLabel.al_top >= al_top + 15,
            titleLabel.al_height == 22,
            titleLabel.al_width <= al_width - 30,
            
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_left == al_left + 50,
            subtitleLabel.al_right == al_right - 50,
            subtitleLabel.al_top  == titleLabel.al_bottom + 5,
            subtitleLabel.al_height == 60,

            priceButton.al_centerX == al_centerX,
            priceButton.al_top == subtitleLabel.al_bottom + 5,
            priceButton.al_width == 84,
            priceButton.al_height == 30,
            
            sampleButton.al_right == al_right - 16.5,
            sampleButton.al_height == 22.5,
            sampleButton.al_width == 78.5,
            sampleButton.al_top == al_top + 31,
            
            backLabel.al_centerY == sampleButton.al_centerY - 1,
            backLabel.al_left == al_left + 42.5
        ])
    }
}