//
//  BrowseSectionHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/30/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    BrowseSectionHeaderView:
    
    Supplementary view of the track list that just displays "SONGS"

*/

class BrowseSectionHeaderView: UICollectionReusableView {
    
    let songsLabel: UILabel
    var lineBreak: UIView?
    
    override init(frame: CGRect) {
        songsLabel = UILabel()
        songsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        songsLabel.font = UIFont(name: "OpenSans", size: 10.0)
        songsLabel.text = "SONGS"
        
        lineBreak = UIView()
        lineBreak?.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineBreak?.backgroundColor = UIColor(fromHexString: "#d3d3d3")
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#ffffff")
        
        addSubview(songsLabel)
        addSubview(lineBreak!)
        
        setLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            songsLabel.al_top == al_top + 14,
            songsLabel.al_left == al_left + 17,
            lineBreak!.al_bottom == al_bottom,
            lineBreak!.al_width == UIScreen.mainScreen().bounds.width,
            lineBreak!.al_height == 1/2
        ])
    }
}
