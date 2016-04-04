//
//  PackProfileCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackProfileCollectionViewCell: BrowsePackCollectionViewCell {
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        primaryButton.backgroundColor = WhiteColor
        primaryButton.setTitle("remove".uppercaseString, forState: .Normal)
        primaryButton.titleLabel?.font = UIFont(name: "OpenSans", size: 8)
        primaryButton.setTitleColor(BlackColor, forState: .Normal)
        primaryButton.layer.shadowRadius = 2
        primaryButton.layer.shadowOpacity = 0.2
        primaryButton.layer.shadowColor = MediumLightGrey.CGColor
        primaryButton.layer.shadowOffset = CGSizeMake(0, 2)
        
        imageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        titleLabel.font = UIFont(name: "OpenSans", size: 14)
        subtitleLabel.text = ""
        subtitleLabel.font = UIFont(name: "OpenSans", size: 9)
        subtitleLabel.alpha = 0.54
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func primaryButtonSelected() {
        // animation
        // remove pack
    }

}