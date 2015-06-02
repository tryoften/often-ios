//
//  BrowseSectionHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/30/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BrowseSectionHeaderView: UICollectionReusableView {
    
    let songsLabel: UILabel
    
    override init(frame: CGRect) {
        songsLabel = UILabel()
        songsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        songsLabel.font = UIFont(name: "Lato-Regular", size: 10.0)
        songsLabel.text = "SONGS"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#ffffff")
        
        addSubview(songsLabel)
        
        setLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            songsLabel.al_top == al_top + 14,
            songsLabel.al_left == al_left + 17
        ])
    }
}
