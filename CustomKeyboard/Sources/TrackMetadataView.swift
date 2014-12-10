//
//  TrackMetadataView.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/10/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class TrackMetadataView: UIView {

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var title: NSAttributedString
    var titleLabel: UILabel
    var coverArtView: UIImageView
    var seperatorView: UIView
    
    var track: Track? {
        didSet {
            updateMetadata()
        }
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        coverArtView = UIImageView(frame: CGRectZero)
        coverArtView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        title = NSAttributedString()
        
        super.init(frame: frame)
        
        addSubview(coverArtView)
        addSubview(titleLabel)
        addSubview(seperatorView)
        
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            coverArtView.al_width == 30.0,
            coverArtView.al_height == coverArtView.al_width,
            coverArtView.al_centerY == self.al_centerY,
            coverArtView.al_left == self.al_left + 20.0,
            
            titleLabel.al_left == coverArtView.al_right + 10.0,
            titleLabel.al_right == self.al_right,
            titleLabel.al_centerY == self.al_centerY,
            
            seperatorView.al_height == 1.0,
            seperatorView.al_width == self.al_width,
            seperatorView.al_bottom == self.al_bottom,
            seperatorView.al_left == self.al_left
        ])
    }
    
    func updateMetadata() {
        if let track = track {
//            coverArtView.setImageWithURL(track.albumCoverImage)
            titleLabel.text = NSString(format: "\"%@\" - %@", track.name, track.artistName)
            titleLabel.font = UIFont(name: "Lato-Regular", size: 12)
        }
    }
}
