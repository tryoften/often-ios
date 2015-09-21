//
//  VenmoContactsCollectionViewCell.swift
//  Surf
//
//  Created by Luc Succes on 7/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoContactsCollectionViewCell: UICollectionViewCell {
    var contactImageView: UIImageView
    var contactName: UILabel
    var contactNumber: UILabel
    
    override init(frame: CGRect) {
        contactImageView = UIImageView()
        contactImageView.translatesAutoresizingMaskIntoConstraints = false
        contactImageView.backgroundColor = DarkGrey
        
        contactName = UILabel()
        contactName.translatesAutoresizingMaskIntoConstraints = false
        contactName.font = UIFont(name: "OpenSans", size: 11)
        
        contactNumber = UILabel()
        contactNumber.font = UIFont(name: "OpenSans", size: 10)
        contactNumber.textColor = SystemGrayColor
        contactNumber.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 3
        layer.shadowOffset = CGSizeMake(0, 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.shadowColor = DarkGrey.CGColor
        
        addSubview(contactImageView)
        addSubview(contactName)
        addSubview(contactNumber)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            contactImageView.al_top == al_top + 10,
            contactImageView.al_left == al_left + 10,
            contactImageView.al_bottom == al_bottom - 10,
            contactImageView.al_width == contactImageView.al_height,
            
            contactName.al_left == contactImageView.al_right + 10,
            contactName.al_top == contactImageView.al_top,
            
            contactNumber.al_leading == contactName.al_leading,
            contactNumber.al_top == contactName.al_bottom + 5
        ])
    }
}