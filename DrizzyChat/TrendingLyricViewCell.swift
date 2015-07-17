//
//  TrendingLyricViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class TrendingLyricViewCell: UICollectionViewCell {
    var rankLabel: UILabel /// number rank on the left of the cell
    var lyricView: UITextView /// to display the lyric
    var artistLabel: UILabel /// yellow name of the artist (previously the @handle)
    var trendIndicator: UIImageView /// green or red arrow depending on performance
    var lineBreakView: UIView /// line break 1 pixel high to fake a line break
    var touchView: UIView
    var lyricViewNumLines: Int
    
    override init(frame: CGRect) {
        rankLabel = UILabel()
        rankLabel.textAlignment = .Right
        rankLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        rankLabel.font = TrendingLyricViewCellRankLabelFont
        
        lyricView = UITextView()
        lyricView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricView.font = TrendingLyricViewCellLyricTextViewlFont
        lyricView.editable = false
        lyricView.scrollEnabled = false
        lyricView.showsHorizontalScrollIndicator = false
        lyricView.editable = false
        
        artistLabel = UILabel()
        artistLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistLabel.font = TrendingLyricViewCellArtistLabelFont
        artistLabel.textColor = TrendingLyricViewCellArtistLabelTextColor
        
        trendIndicator = UIImageView()
        trendIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        trendIndicator.contentMode = .ScaleAspectFit
        
        lineBreakView = UIView()
        lineBreakView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineBreakView.backgroundColor = TrendingLyricViewCellLineBreakViewBackgroundColor
        
        touchView = UIView()
        touchView.setTranslatesAutoresizingMaskIntoConstraints(false)
        touchView.backgroundColor = TrendingLyricViewCellTouchViewBackgroundColor
        
        lyricViewNumLines = 0
        
        super.init(frame: frame)
        
        backgroundColor = TrendingLyricViewCellBackgroundColor
        
        addSubview(rankLabel)
        addSubview(lyricView)
        addSubview(artistLabel)
        addSubview(trendIndicator)
        addSubview(lineBreakView)
        addSubview(touchView)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        let constraints: [NSLayoutConstraint] = [
            rankLabel.al_width == 25,
            rankLabel.al_height == 25,
            rankLabel.al_left == al_left + 8,
            rankLabel.al_centerY == al_centerY,
            
            trendIndicator.al_width == 8,
            trendIndicator.al_height == 8,
            trendIndicator.al_left == rankLabel.al_right + 5,
            trendIndicator.al_centerY == rankLabel.al_centerY,
            
            lyricView.al_left == trendIndicator.al_right + 17,
            lyricView.al_right == al_right - 10,
            lyricView.al_top == al_top,
            lyricView.al_height == 50,
            
            artistLabel.al_bottom == al_bottom - 9,
            artistLabel.al_left == trendIndicator.al_right + 22,
            artistLabel.al_width == 100,
            artistLabel.al_height == 15,
            
            lineBreakView.al_bottom == al_bottom,
            lineBreakView.al_width == 335,
            lineBreakView.al_height == 1/2,
            lineBreakView.al_left == al_left + 20,
            
            touchView.al_width == al_width,
            touchView.al_height == al_height,
            touchView.al_left == al_left,
            touchView.al_top == al_top
        ]
        addConstraints(constraints)
    }
}

class TrendingOneLineLyricViewCell: TrendingLyricViewCell {
    
    func setupOneLineLayout() {
        let constraints: [NSLayoutConstraint] = [
            rankLabel.al_width == 25,
            rankLabel.al_height == 25,
            rankLabel.al_left == al_left + 8,
            rankLabel.al_centerY == al_centerY,
            
            trendIndicator.al_width == 8,
            trendIndicator.al_height == 8,
            trendIndicator.al_left == rankLabel.al_right + 5,
            trendIndicator.al_centerY == rankLabel.al_centerY,
            
            lyricView.al_left == trendIndicator.al_right + 17,
            lyricView.al_right == al_right - 10,
            lyricView.al_top == al_top + 9,
            lyricView.al_height == 50,
            
            artistLabel.al_bottom == al_bottom - 17,
            artistLabel.al_left == trendIndicator.al_right + 22,
            artistLabel.al_width == 100,
            artistLabel.al_height == 15,
            
            lineBreakView.al_bottom == al_bottom,
            lineBreakView.al_width == 335,
            lineBreakView.al_height == 1/2,
            lineBreakView.al_left == al_left + 20,
            
            touchView.al_width == al_width,
            touchView.al_height == al_height,
            touchView.al_left == al_left,
            touchView.al_top == al_top
        ]
        addConstraints(constraints)
    }
}
