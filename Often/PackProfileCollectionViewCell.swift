//
//  PackProfileCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackProfileCollectionViewCell: BrowseMediaItemCollectionViewCell {
    
    var primaryButton: UIButton

    override init(frame: CGRect) {

        primaryButton = UIButton()
        super.init(frame: frame)

        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.backgroundColor = UIColor.oftWhiteThreeColor()
        primaryButton.setTitle("remove".uppercased(), for: UIControlState())
        primaryButton.titleLabel?.font = UIFont(name: "Montserrat", size: 8)
        primaryButton.setTitleColor(BlackColor, for: UIControlState())
        
        addSubview(primaryButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupLayout() {
        super.setupLayout()
        
        addConstraints([
            primaryButton.al_bottom == al_bottom,
            primaryButton.al_height == 27,
            primaryButton.al_left == al_left,
            primaryButton.al_right == al_right,
        ])
    }
}
