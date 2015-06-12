//
//  TrendingSectionHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    Same as the Browse Section header but should have a black view above the artist/songs label
    that can tab between the two
    Probably need to remove the animations from the button presses
*/

class TrendingSectionHeaderView: UICollectionReusableView {
    let trendingLabel: UILabel
    @IBOutlet var bottomLineBreak: UIView?
    @IBOutlet var tabView: UIView?
    @IBOutlet var artistsButton: UIButton?
    @IBOutlet var lyricsButton: UIButton?
    var screenWidth: CGFloat?
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        trendingLabel = UILabel()
        trendingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        trendingLabel.font = UIFont(name: "OpenSans", size: 10.0)
        trendingLabel.text = "TRENDING"
        
        tabView = UIView()
        tabView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabView?.backgroundColor = UIColor.blackColor()
        
        bottomLineBreak = UIView()
        bottomLineBreak?.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomLineBreak?.backgroundColor = UIColor(fromHexString: "#d3d3d3")
        
        artistsButton = UIButton()
        artistsButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistsButton?.setTitle("ARTISTS", forState: UIControlState.Normal)
        artistsButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 14.0)
        artistsButton?.setTitleColor(UIColor(fromHexString: "#FFB316"), forState: UIControlState.Normal)
        
        lyricsButton = UIButton()
        lyricsButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricsButton?.setTitle("LYRICS", forState: UIControlState.Normal)
        lyricsButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 14.0)
        lyricsButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        super.init(frame: frame)
        
        artistsButton?.addTarget(self, action: "artistsTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        lyricsButton?.addTarget(self, action: "lyricsTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        backgroundColor = UIColor(fromHexString: "#ffffff")
        
        addSubview(trendingLabel)
        addSubview(bottomLineBreak!)
        addSubview(tabView!)
        addSubview(artistsButton!)
        addSubview(lyricsButton!)
        
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            trendingLabel.al_bottom == al_bottom - 15,
            trendingLabel.al_left == al_left + 17,
            
            bottomLineBreak!.al_bottom == al_bottom,
            bottomLineBreak!.al_width == UIScreen.mainScreen().bounds.width,
            bottomLineBreak!.al_height == 1/2
        ])
        
        addConstraints([
            tabView!.al_bottom == trendingLabel.al_top - 15,
            tabView!.al_height == 57,
            tabView!.al_width == screenWidth!
        ])
        
        addConstraints([
            artistsButton!.al_height == 50,
            artistsButton!.al_width == (screenWidth! / 2) - 5,
            artistsButton!.al_left == al_left + 5,
            artistsButton!.al_top == al_top - 28,
            
            lyricsButton!.al_left == artistsButton!.al_right + 5,
            lyricsButton!.al_top == al_top - 28,
            lyricsButton!.al_height == 50,
            lyricsButton!.al_width == (screenWidth! / 2) - 5
        ])
    }
    
    @IBAction func artistsTapped(sender: UIButton) {
        println("Artists Tapped")
        artistsButton?.setTitleColor(UIColor(fromHexString: "#FFB316"), forState: UIControlState.Normal)
        lyricsButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
    }
    
    @IBAction func lyricsTapped(sender: UIButton) {
        println("Lyrics Tapped")
        artistsButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        lyricsButton?.setTitleColor(UIColor(fromHexString: "#FFB316"), forState: UIControlState.Normal)
    }
}
