//
//  TrackMetadataView.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/10/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

func addCircularMaskToView(view: UIView, width: CGFloat) -> CAShapeLayer {
    var circle = CAShapeLayer()
    var circularPath = UIBezierPath(roundedRect: CGRectMake(0, 0, width, width), cornerRadius: CGFloat(width / 2))
    circle.path = circularPath.CGPath
    circle.lineWidth = 0
    
    view.layer.mask = circle
    return circle
}

class TrackMetadataView: UIView {
    
    var title: NSAttributedString
    var contentView: UIView
    var titleLabel: UILabel
    var coverArtView: UIImageView
    var seperatorView: UIView
    var titleLabelConstraints: [NSLayoutAttribute: NSLayoutConstraint]!
    var coverArtViewConstraints: [NSLayoutAttribute: NSLayoutConstraint]!
    var contentViewWidthConstraint: NSLayoutConstraint?

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
        coverArtView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        coverArtView.clipsToBounds = true
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.textColor = MainTextColor
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.textAlignment = .Center
        titleLabel.font = SubtitleFont
        titleLabel.text = "No Metadata"
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        title = NSAttributedString()
        
        super.init(frame: frame)
        
        addSubview(contentView)
        addSubview(seperatorView)
        contentView.addSubview(coverArtView)
        contentView.addSubview(titleLabel)
        
        setupLayout()
        addCircularMaskToView(coverArtView, CoverArtViewImageWidth)
    }
    
    func setupLayout() {
        
        titleLabelConstraints = [
            .Left: titleLabel.al_left == contentView.al_left,
            .Right: titleLabel.al_right == contentView.al_right,
            .CenterY: titleLabel.al_centerY == contentView.al_centerY
        ]
        
        coverArtViewConstraints = [
            .Width: coverArtView.al_width == 0.0,
            .Height: coverArtView.al_height == coverArtView.al_width,
            .Left: coverArtView.al_left == contentView.al_left,
            .Right: coverArtView.al_right == contentView.al_left,
            .CenterY: coverArtView.al_centerY == contentView.al_centerY
        ]
        
        contentViewWidthConstraint = contentView.al_width == titleLabel.al_width

        addConstraint(contentViewWidthConstraint!)
        addConstraints(titleLabelConstraints.values.array)
        addConstraints(coverArtViewConstraints.values.array)

        addConstraints([
            contentView.al_centerX == al_centerX,
            contentView.al_centerY == al_centerY,
            contentView.al_height == al_height,
            contentView.al_width <= al_width,
            
            seperatorView.al_height == 1.0,
            seperatorView.al_width == al_width,
            seperatorView.al_bottom == al_bottom,
            seperatorView.al_left == al_left
        ])
        
    }
    
    func resetConstraints() {
        self.coverArtViewConstraints[.Width]!.constant = 0.0
        self.coverArtViewConstraints[.Right]!.constant = 0.0
        self.titleLabelConstraints[.Left]!.constant = 0.0
        self.contentViewWidthConstraint!.constant = 0.0
    }
    
    func updateMetadata() {
        if let track = track {
            if let url = track.albumCoverImage {
                coverArtView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url)!), placeholderImage: UIImage(), success: { (req, res, image) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.coverArtView.alpha = 0.0
                        self.coverArtView.image = image
                        self.titleLabel.textAlignment = .Left
                        
                        UIView.animateWithDuration(0.3, animations: {
                            self.coverArtView.alpha = 1.0
                            
                            self.contentViewWidthConstraint!.constant = CGFloat(CoverArtViewImageWidth)
                            self.coverArtViewConstraints[.Width]!.constant = CGFloat(CoverArtViewImageWidth)
                            self.coverArtViewConstraints[.Right]!.constant = CGFloat(CoverArtViewImageWidth)
                            self.titleLabelConstraints[.Left]!.constant = CGFloat(CoverArtViewImageWidth) + 10.0
                        })
                    })

                }, failure: { (req, res, error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        UIView.animateWithDuration(0.3, animations: {
                            self.titleLabel.textAlignment = .Center
                            self.resetConstraints()
                        })
                        
                    })
                })
            }
            titleLabel.text = NSString(format: "\"%@\" - %@", track.name, track.artistName) as String
        }
    }
}
