//
//  BrowseCollectionViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/30/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BrowseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var rankLabel: UILabel! //number rank on the left of the cell
    @IBOutlet var trackNameLabel: UILabel! //Track name label
    @IBOutlet var lyricCountLabel: UILabel! //label for lyric Count "Lyrics: n"
    // @IBOutlet var disclosureIndicator: UIImageView! // cant do an accessory view for Collection View?
    
    override init(frame: CGRect) {
        
        rankLabel = UILabel()
        rankLabel.textAlignment = .Center
        rankLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rankLabel.font = UIFont(name: "Lato-Regular", size: 16.0)
        
        trackNameLabel = UILabel()
        trackNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        trackNameLabel.font = UIFont(name: "Lato-Regular", size: 14.0)
        
        lyricCountLabel = UILabel()
        lyricCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricCountLabel.font = UIFont(name: "Lato-Regular", size: 9.0)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#ffffff")
        
        contentView.addSubview(rankLabel)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(lyricCountLabel)
        
        var viewsDict = ["rank":rankLabel, "trackName":trackNameLabel, "lyricCount": lyricCountLabel]
        
        setLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        
        let constraints: [NSLayoutConstraint] = [
            rankLabel.al_width == 30,
            rankLabel.al_height == 30,
            rankLabel.al_left == al_left + 20,
            rankLabel.al_top == al_top + 15,
            
            trackNameLabel.al_left == rankLabel.al_right + 5,
            trackNameLabel.al_top == al_top + 18,
            
            lyricCountLabel.al_top == trackNameLabel.al_bottom,
            lyricCountLabel.al_left == rankLabel.al_right + 5
        ]
        addConstraints(constraints)
    }
}
