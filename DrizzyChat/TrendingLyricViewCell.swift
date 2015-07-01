//
//  TrendingLyricViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class TrendingLyricViewCell: UICollectionViewCell {
    var rankLabel: UILabel? /// number rank on the left of the cell
    var lyricView: UITextView? /// to display the lyric
    var artistLabel: UILabel? /// yellow name of the artist (previously the @handle)
    var trendIndicator: UIImageView! /// green or red arrow depending on performance
    var lineBreakView: UIView! /// line break 1 pixel high to fake a line break
    var touchView: UIView
    var lyricViewNumLines: CGFloat
    
    override init(frame: CGRect) {
        rankLabel = UILabel()
        rankLabel?.textAlignment = .Right
        rankLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        rankLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        lyricView = UITextView()
        lyricView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricView?.font = UIFont(name: "OpenSans", size: 12.0)
        lyricView?.editable = false
        lyricView?.scrollEnabled = false
        lyricView?.showsHorizontalScrollIndicator = false
        lyricView?.editable = false
        
        artistLabel = UILabel()
        artistLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistLabel?.font = UIFont(name: "OpenSans", size: 10.0)
        artistLabel?.textColor = UIColor.orangeColor()
        
        trendIndicator = UIImageView()
        trendIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        trendIndicator.contentMode = .ScaleAspectFit
        
        lineBreakView = UIView()
        lineBreakView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineBreakView.backgroundColor = UIColor(fromHexString: "#d3d3d3")
        
        touchView = UIView()
        touchView.setTranslatesAutoresizingMaskIntoConstraints(false)
        touchView.backgroundColor = UIColor.clearColor()
        
        lyricViewNumLines = 0.0
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#ffffff")
        
        addSubview(rankLabel!)
        addSubview(lyricView!)
        addSubview(artistLabel!)
        addSubview(trendIndicator!)
        addSubview(lineBreakView!)
        addSubview(touchView)
        
        setLayout()
        
        setNumLines()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumLines() {
        lyricViewNumLines = lyricView!.contentSize.height / lyricView!.font.lineHeight
        println(lyricViewNumLines)
    }
    
    func setLayout() {
        let constraints: [NSLayoutConstraint] = [
            rankLabel!.al_width == 25,
            rankLabel!.al_height == 25,
            rankLabel!.al_left == al_left + 8,
            rankLabel!.al_centerY == al_centerY,
            
            trendIndicator.al_width == 8,
            trendIndicator.al_height == 8,
            trendIndicator.al_left == rankLabel!.al_right + 5,
            trendIndicator.al_centerY == rankLabel!.al_centerY,
            
            lyricView!.al_left == trendIndicator!.al_right + 17,
            lyricView!.al_right == al_right - 10,
            lyricView!.al_top == al_top,
            lyricView!.al_height == 50,
            
            artistLabel!.al_bottom == al_bottom - 9,
            artistLabel!.al_left == trendIndicator.al_right + 22,
            artistLabel!.al_width == 100,
            artistLabel!.al_height == 15,
            
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
