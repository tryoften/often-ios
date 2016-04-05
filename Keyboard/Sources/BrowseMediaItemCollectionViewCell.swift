//
//  ArtistCollectionViewCell.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable line_length
//  swiftlint:disable trailing_newline
//  swiftlint:disable force_cast

import UIKit

class BrowseMediaItemCollectionViewCell: UICollectionViewCell {
    var placeholderImageView: UIImageView
    var imageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var contentEdgeInsets: UIEdgeInsets

    var songCount: Int? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 8)!,
                NSForegroundColorAttributeName: UIColor.grayColor()
            ]
            let attributedString = NSAttributedString(string: "\(songCount!) lyrics".uppercaseString, attributes: attributes)
            subtitleLabel.attributedText = attributedString
        }
    }

    override init(frame: CGRect) {
        placeholderImageView = UIImageView()
        placeholderImageView.backgroundColor = MediumGrey
        placeholderImageView.image = UIImage(named: "placeholder")
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false

        var layer = CAShapeLayer()
        layer.path = BrowseMediaItemCollectionViewCell.drawImageMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.frame = CGRectMake(0, 0, ArtistCollectionViewCellWidth, ArtistCollectionViewCellWidth)
        placeholderImageView.layer.mask = layer

        imageView = UIImageView()
        imageView.backgroundColor = ArtistCollectionViewImageViewBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true

        layer = CAShapeLayer()
        layer.path = BrowseMediaItemCollectionViewCell.drawImageMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        imageView.layer.mask = layer

        titleLabel = UILabel()
        titleLabel.font = ArtistCollectionViewCellTitleFont
        titleLabel.textColor = ArtistCollectionViewCellTitleTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center

        subtitleLabel = UILabel()
        subtitleLabel.font = ArtistCollectionViewCellSubtitleFont
        subtitleLabel.textColor = ArtistCollectionViewCellSubtitleTextColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Center

        contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)

        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()
        addSubview(placeholderImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        self.layer.cornerRadius = 2.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.14
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowRadius = 1

        selected = false
        setupLayout()

        let width: CGFloat = self.frame.size.width
        setImageViewLayers(CGRectMake(0, 0, width, width))
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    func setImageViewLayers(frame: CGRect) {
        var layer = CAShapeLayer()
        layer.path = self.dynamicType.drawImageMask(frame: frame).CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.frame = frame
        placeholderImageView.layer.mask = layer

        layer = CAShapeLayer()
        layer.path = self.dynamicType.drawImageMask(frame: frame).CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.frame = frame
        imageView.layer.mask = layer
    }


    override func prepareForReuse() {
        imageView.image = nil
    }

    func setupLayout() {
        addConstraints([
            imageView.al_width == al_width,
            imageView.al_height == imageView.al_width,
            imageView.al_centerX == al_centerX,
            imageView.al_top == al_top,

            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,

            titleLabel.al_top == imageView.al_bottom + contentEdgeInsets.top,
            titleLabel.al_left == al_left + contentEdgeInsets.left,
            titleLabel.al_right == al_right - contentEdgeInsets.right,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_width == titleLabel.al_width
        ])
    }

    class func drawImageMask(frame frame: CGRect = CGRectMake(0, 0, ArtistCollectionViewCellWidth, ArtistCollectionViewCellWidth)) -> UIBezierPath {
        //// path Drawing
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 0.01428 * frame.height))
        path.addCurveToPoint(CGPointMake(frame.minX + 0.01481 * frame.width, frame.minY + -0.00000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 0.00639 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.00665 * frame.width, frame.minY + -0.00000 * frame.height))
        path.addLineToPoint(CGPointMake(frame.minX + 0.98519 * frame.width, frame.minY + -0.00000 * frame.height))
        path.addCurveToPoint(CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.01428 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.99337 * frame.width, frame.minY + -0.00000 * frame.height), controlPoint2: CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.00640 * frame.height))
        path.addLineToPoint(CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.85646 * frame.height))
        path.addLineToPoint(CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 1.00000 * frame.height))
        path.addLineToPoint(CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 0.01428 * frame.height))
        path.closePath()
        path.miterLimit = 4;

        path.usesEvenOddFillRule = true;
        
        return path
    }
}

