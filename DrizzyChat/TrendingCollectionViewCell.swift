//
//  TrendingCollectionViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    TrendingCollectionViewCell:

    Cell that will either display info about the tracks or name of songs when looking at
    the Trending collection view controller

    - Rank of the artist or track
    - Name of the track or the artist
    - Subtitle contains the number of songs + lyrics for that artist and number of lyrics for track
    - Disclosure Indicator
    - Line Break

*/

class TrendingCollectionViewCell: UICollectionViewCell {
    
    enum TrendBehavior {
        case Up
        case Down
        case Neutral
    }
    
    var rankLabel: UILabel /// number rank on the left of the cell
    var nameLabel: UILabel /// Track name label
    var subLabel: UILabel /// label for lyric Count "Lyrics: n"
    var disclosureIndicator: UIImageView /// arrow image
    var lineBreakView: UIView /// line break 1 pixel high to fake a line break
    var trendIndicator: UIImageView /// green or red arrow depending on performance
    
    
    override init(frame: CGRect) {
        rankLabel = UILabel()
        rankLabel.textAlignment = .Right
        rankLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rankLabel.font = TrendingCollectionViewCellRankLabelFont
        
        trendIndicator = UIImageView()
        trendIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        trendIndicator.contentMode = .ScaleAspectFit
        
        nameLabel = UILabel()
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.font = TrendingCollectionViewCellNameLabelFont
        
        subLabel = UILabel()
        subLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subLabel.font = TrendingCollectionViewCellSubLabelFont
        
        disclosureIndicator = UIImageView()
        disclosureIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        disclosureIndicator.contentMode = .ScaleAspectFit
        
        lineBreakView = UIView()
        lineBreakView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineBreakView.backgroundColor = TrendingCollectionViewCellLineBreakColor
        
        super.init(frame: frame)
        
        backgroundColor = TrendingCollectionViewCellBackgroundColor

        addSubview(rankLabel)
        addSubview(trendIndicator)
        addSubview(nameLabel)
        addSubview(subLabel)
        addSubview(disclosureIndicator)
        addSubview(lineBreakView)
        
        var viewsDict = ["rank":rankLabel,
            "trendIndicator":trendIndicator,
            "trackName":nameLabel,
            "lyricCount": subLabel,
            "disclosureIndicator":disclosureIndicator,
            "lineBreak":lineBreakView]
        
        setLayout()
        
    }
    
    func setLayout() {
        let constraints: [NSLayoutConstraint] = [
            rankLabel.al_width == 25,
            rankLabel.al_height == 25,
            rankLabel.al_left == al_left + 8,
            rankLabel.al_top == al_top + 17,
            
            trendIndicator.al_width == 8,
            trendIndicator.al_height == 8,
            trendIndicator.al_left == rankLabel.al_right + 5,
            trendIndicator.al_top == al_top + 26,
            
            nameLabel.al_left == trendIndicator.al_right + 26,
            nameLabel.al_top == al_top + 14,
            
            subLabel.al_top == nameLabel.al_bottom,
            subLabel.al_left == nameLabel.al_left,
            
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
        

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
