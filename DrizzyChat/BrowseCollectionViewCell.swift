//
//  BrowseCollectionViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/30/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    Cell for displaying the tracks of an artist in the Browse View

    - Track Name
    - Rank
    - Lyric count
    - Disclosure Indicator
    - Line Break
*/

class BrowseCollectionViewCell: UICollectionViewCell {
    
    var rankLabel: UILabel /// number rank on the left of the cell
    var trackNameLabel: UILabel /// Track name label
    var lyricCountLabel: UILabel /// label for lyric Count "Lyrics: n"
    var disclosureIndicator: UIImageView /// arrow image
    var lineBreakView: UIView /// line break 1 pixel high to fake a line break
    
    override init(frame: CGRect) {
        rankLabel = UILabel()
        rankLabel.textAlignment = .Center
        rankLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rankLabel.font = UIFont(name: "OpenSans", size: 16.0)
        
        trackNameLabel = UILabel()
        trackNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        trackNameLabel.font = UIFont(name: "OpenSans", size: 14.0)
        
        lyricCountLabel = UILabel()
        lyricCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricCountLabel.font = UIFont(name: "OpenSans", size: 9.0)
        
        disclosureIndicator = UIImageView()
        disclosureIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        disclosureIndicator.contentMode = .ScaleAspectFit
        
        lineBreakView = UIView()
        lineBreakView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineBreakView.backgroundColor = UIColor(fromHexString: "#d3d3d3")
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()

        contentView.addSubview(rankLabel)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(lyricCountLabel)
        contentView.addSubview(disclosureIndicator)
        contentView.addSubview(lineBreakView)
        
        var viewsDict = ["rank": rankLabel,
                        "trackName": trackNameLabel,
                        "lyricCount": lyricCountLabel,
                        "disclosureIndicator": disclosureIndicator,
                        "lineBreak": lineBreakView]
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            rankLabel.al_width == 30,
            rankLabel.al_height == 30,
            rankLabel.al_left == al_left + 20,
            rankLabel.al_top == al_top + 18,
            
            trackNameLabel.al_left == rankLabel.al_right + 20,
            trackNameLabel.al_top == al_top + 18,
            
            lyricCountLabel.al_top == trackNameLabel.al_bottom,
            lyricCountLabel.al_left == rankLabel.al_right + 21,
            
            disclosureIndicator.al_right == al_right - 13,
            disclosureIndicator.al_top == al_top + 23,
            disclosureIndicator.al_width == 19,
            disclosureIndicator.al_height == 19,
            
            lineBreakView.al_bottom == al_bottom,
            lineBreakView.al_width == 335,
            lineBreakView.al_height == 1/2,
            lineBreakView.al_left == al_left + 20
        ]
        addConstraints(constraints)
    }
}
