//
//  ArtistCollectionViewCell.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable line_length
//  swiftlint:disable trailing_newline

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    private var placeholderImageView: UIImageView
    var imageView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var contentEdgeInsets: UIEdgeInsets

    var songCount: Int? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.2),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 8)!,
                NSForegroundColorAttributeName: UIColor.grayColor()
            ]
            let attributedString = NSAttributedString(string: "\(songCount!) songs".uppercaseString, attributes: attributes)
            subtitleLabel.attributedText = attributedString
        }
    }

    override init(frame: CGRect) {
        placeholderImageView = UIImageView()
        placeholderImageView.image = UIImage(named: "placeholder")
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false

        imageView = UIImageView()
        imageView.backgroundColor = ArtistCollectionViewImageViewBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true

        let layer = CAShapeLayer()
        layer.path = ArtistCollectionViewCell.drawImageMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        imageView.layer.mask = layer

        titleLabel = UILabel()
        titleLabel.font = ArtistCollectionViewCellTitleFont
        titleLabel.textColor = ArtistCollectionViewCellTitleTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Left

        subtitleLabel = UILabel()
        subtitleLabel.font = ArtistCollectionViewCellSubtitleFont
        subtitleLabel.textColor = ArtistCollectionViewCellSubtitleTextColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Left

        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()
        addSubview(placeholderImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.19
        layer.shadowOffset = CGSizeMake(0, 0.0)
        layer.shadowRadius = 2
        layer.masksToBounds = true
        selected = false

        setupLayout()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
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
            titleLabel.al_height == 20,

            subtitleLabel.al_top == titleLabel.al_bottom + 5,
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

