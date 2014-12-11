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
    var contentView: UIView
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
        contentView = UIView(frame: CGRectZero)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        coverArtView = UIImageView(frame: CGRectZero)
        coverArtView.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverArtView.clipsToBounds = true
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.textColor = UIColor(fromHexString: "#777777")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        title = NSAttributedString()
        
        super.init(frame: frame)
        
        addSubview(contentView)
        addSubview(seperatorView)
        contentView.addSubview(coverArtView)
        contentView.addSubview(titleLabel)
        
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            contentView.al_centerX == al_centerX,
            contentView.al_centerY == al_centerY,
            contentView.al_height == al_height,
            contentView.al_width == titleLabel.al_width + 45.0,

            coverArtView.al_width == 35.0,
            coverArtView.al_height == coverArtView.al_width,
            coverArtView.al_centerY == contentView.al_centerY,
            coverArtView.al_left == contentView.al_left,
            
            titleLabel.al_left == coverArtView.al_right + 10.0,
//            titleLabel.al_right == contentView.al_right,
            titleLabel.al_centerY == contentView.al_centerY,
            
            seperatorView.al_height == 1.0,
            seperatorView.al_width == al_width,
            seperatorView.al_bottom == al_bottom,
            seperatorView.al_left == al_left
        ])
        
        var circle = CAShapeLayer()
        var circularPath = UIBezierPath(roundedRect: CGRectMake(0, 0, 35, 35), cornerRadius: 35/2)
        circle.path = circularPath.CGPath
        
        circle.fillColor = UIColor.blackColor().CGColor
        circle.strokeColor = UIColor.blackColor().CGColor
        circle.lineWidth = 0
        
        coverArtView.layer.mask = circle
    }
    
    func updateMetadata() {
        if let track = track {
            coverArtView.setImageWithURL(track.albumCoverImage)
            titleLabel.text = NSString(format: "\"%@\" - %@", track.name, track.artistName)
            titleLabel.font = UIFont(name: "Lato-Regular", size: 12)
        }
    }
}
