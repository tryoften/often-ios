//
//  ArtistCollectionViewCell.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var circleView: UIView
    var circleLayer: CAShapeLayer
    
    override var selected: Bool {
        didSet {
            UIView.animateWithDuration(0.3, animations: {
                if (self.selected) {
                    self.circleLayer.lineWidth = 2.0
                    self.circleLayer.strokeColor = UIColor(fromHexString: "#f19720").CGColor
                } else {
                    self.circleLayer.lineWidth = 0.0
                    self.circleLayer.strokeColor = UIColor.clearColor().CGColor
                }
            })

        }
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.blackColor()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        
        titleLabel = UILabel()
        titleLabel.font = ArtistCollectionViewCellTitleFont
        titleLabel.textColor = ArtistCollectionViewCellTitleTextColor
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.font = ArtistCollectionViewCellSubtitleFont
        subtitleLabel.textColor = ArtistCollectionViewCellSubtitleTextColor
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.textAlignment = .Center
        
        var width = ArtistCollectionViewCellWidth - ArtistCollectionViewCellImageViewLeftMargin * 2

        addCircularMaskToView(imageView, width)
        
        width = width + 12
        
        circleView = UIView()
        circleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        circleLayer = CAShapeLayer()
        var circularPath = UIBezierPath(roundedRect: CGRectMake(0, 0, width, width), cornerRadius: CGFloat(width / 2))
        circleLayer.path = circularPath.CGPath
        circleLayer.lineWidth = 0
        circleLayer.strokeColor = UIColor.clearColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleView.layer.addSublayer(circleLayer)

        super.init(frame: frame)
        
        backgroundColor = ArtistCollectionViewCellBackgroundColor
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(circleView)
        


        layer.cornerRadius = 5.0
        
        setupLayout()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            imageView.al_width == al_width - ArtistCollectionViewCellImageViewLeftMargin * 2,
            imageView.al_height == imageView.al_width,
            imageView.al_centerX == al_centerX,
            imageView.al_centerY == al_centerY - 30,
            
            circleView.al_centerX == imageView.al_centerX,
            circleView.al_centerY == imageView.al_centerY,
            circleView.al_width == imageView.al_width + 12,
            circleView.al_height == imageView.al_height + 12,
            
            titleLabel.al_top == imageView.al_bottom + 5,
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_width == al_width - 15,
            titleLabel.al_height == 25,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_width == titleLabel.al_width,
            subtitleLabel.al_height == 15
        ]
        
        addConstraints(constraints)
    }
}
