//
//  ArtistCollectionViewCell.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    private var placeholderImageView: UIImageView
    var imageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var circleView: UIView
    var circleLayer: CAShapeLayer
    var deleteButton: UIButton
    
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
        placeholderImageView = UIImageView()
        placeholderImageView.image = UIImage(named: "placeholder")
        placeholderImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
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
        
        deleteButton = UIButton()
        deleteButton.backgroundColor = UIColor(fromHexString: "#f19720")
        deleteButton.setImage(UIImage(named: "close artists"), forState: .Normal)
        deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        deleteButton.layer.cornerRadius = 25 / 2
        deleteButton.clipsToBounds = true
        deleteButton.alpha = 0.0
        deleteButton.hidden = true

        var width = ArtistCollectionViewCellWidth - ArtistCollectionViewCellImageViewLeftMargin * 2
        
        addCircularMaskToView(placeholderImageView, width)
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
        addSubview(placeholderImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(circleView)
        addSubview(deleteButton)

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
            
            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,
            
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
            subtitleLabel.al_height == 15,
            
            deleteButton.al_width == 25,
            deleteButton.al_height == deleteButton.al_width,
            deleteButton.al_right == al_right + 5,
            deleteButton.al_top == al_top - 5
        ]
        
        addConstraints(constraints)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        var attributes = layoutAttributes as! ArtistPickerCollectionViewLayoutAttributes
        
        UIView.animateWithDuration(0.3, animations: {
            if attributes.deleteButtonHidden == true {
                self.deleteButton.alpha = 0.0
            } else {
                self.deleteButton.hidden = false
                self.deleteButton.alpha = 1.0
            }
        }, completion: { done in
            self.deleteButton.hidden = attributes.deleteButtonHidden
        })

    }
}
