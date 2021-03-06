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
    var addedBadgeView: UIImageView
    var highlightColorBorder: UIView
    var shareButton: UIButton
    var newPackBadge: UIButton
    var updatedContentBadge: UIButton
    var checkmarkBadge: UIImageView
    
    var itemCount: Int? {
        didSet {
            subtitleLabel.setTextWith(ArtistCollectionViewCellSubtitleFont!,
                                      letterSpacing: 1.0,
                                      color: ArtistCollectionViewCellSubtitleTextColor,
                                      text: "\(itemCount!) Quotes & Gifs".uppercaseString)
        }
    }
    
    var style: BrowseMediaItemCollectionViewCellStyle = .MainApp {
        didSet {
            setupCellStyle()
        }
    }

    override init(frame: CGRect) {
        placeholderImageView = UIImageView()
        placeholderImageView.backgroundColor = VeryLightGray
        placeholderImageView.contentMode = .Center
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false

        addedBadgeView = UIImageView(image: StyleKit.imageOfCheckicon(color: TealColor, scale: 0.4))
        addedBadgeView.backgroundColor = WhiteColor
        addedBadgeView.translatesAutoresizingMaskIntoConstraints = false
        addedBadgeView.layer.cornerRadius = 18.0
        addedBadgeView.layer.shadowRadius = 2
        addedBadgeView.layer.shadowOpacity = 0.2
        addedBadgeView.layer.shadowColor = MediumLightGrey.CGColor
        addedBadgeView.layer.shadowOffset = CGSizeMake(0, 1)

        newPackBadge = UIButton()
        newPackBadge.translatesAutoresizingMaskIntoConstraints = false
        newPackBadge.setAttributedTitle(NSAttributedString(string: "new".uppercaseString, attributes: [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 8.0)!,
            NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ]), forState: .Normal)
        newPackBadge.backgroundColor = UIColor.oftBrightLavenderColor()
        newPackBadge.layer.cornerRadius = 10.0
        newPackBadge.layer.shadowRadius = 2
        newPackBadge.layer.shadowOpacity = 0.2
        newPackBadge.layer.shadowColor = MediumLightGrey.CGColor
        newPackBadge.layer.shadowOffset = CGSizeMake(0, 1)
        newPackBadge.hidden = true

        updatedContentBadge = UIButton()
        updatedContentBadge.translatesAutoresizingMaskIntoConstraints = false
        updatedContentBadge.backgroundColor = UIColor.oftWhiteColor()
        updatedContentBadge.layer.cornerRadius = 10.0
        updatedContentBadge.layer.shadowRadius = 2
        updatedContentBadge.layer.shadowOpacity = 0.2
        updatedContentBadge.layer.shadowColor = MediumLightGrey.CGColor
        updatedContentBadge.layer.shadowOffset = CGSizeMake(0, 1)
        updatedContentBadge.hidden = true
        updatedContentBadge.setAttributedTitle(NSAttributedString(string: "updated".uppercaseString, attributes: [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 8.0)!,
            NSForegroundColorAttributeName: UIColor.oftBlackColor()
            ]), forState: .Normal)

        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.backgroundColor = ClearColor
        shareButton.setImage(StyleKit.imageOfShareCanvas(color: WhiteColor), forState: .Normal)

        var layer = CAShapeLayer()
        layer.path = BrowseMediaItemCollectionViewCell.drawImageMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.frame = CGRectMake(0, 0, ArtistCollectionViewCellWidth, ArtistCollectionViewCellWidth)
        placeholderImageView.layer.mask = layer

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true

        layer = CAShapeLayer()
        layer.path = BrowseMediaItemCollectionViewCell.drawImageMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        imageView.layer.mask = layer

        highlightColorBorder = UIView(frame: CGRectZero)
        highlightColorBorder.translatesAutoresizingMaskIntoConstraints = false
        highlightColorBorder.backgroundColor = UIColor.oftGreenblueColor()
        highlightColorBorder.hidden = true

        titleLabel = UILabel()
        titleLabel.font = ArtistCollectionViewCellTitleFont
        titleLabel.textColor = ArtistCollectionViewCellTitleTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Left

        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Left
        
        checkmarkBadge = UIImageView()
        checkmarkBadge.translatesAutoresizingMaskIntoConstraints = false
        checkmarkBadge.contentMode = .ScaleAspectFit
        checkmarkBadge.image = StyleKit.imageOfVerifiedCheck()
        checkmarkBadge.hidden = true
        
        contentEdgeInsets = UIEdgeInsets(top: 15, left: 14, bottom: 10, right: 14)

        super.init(frame: frame)
        
        addSubview(placeholderImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(addedBadgeView)
        addSubview(highlightColorBorder)
        addSubview(shareButton)
        addSubview(newPackBadge)
        addSubview(updatedContentBadge)
        addSubview(checkmarkBadge)

        backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 2.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.14
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowRadius = 1

        selected = false
        style = .MainApp
        setupLayout()

        let width: CGFloat = self.frame.size.width
        setImageViewLayers(CGRectMake(0, 0, width, frame.size.height/2 + 20))
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
        highlightColorBorder.hidden = true
    }

    func setupLayout() {
        addConstraints([
            imageView.al_width == al_width,
            imageView.al_height == al_height / 2 + 20,
            imageView.al_centerX == al_centerX,
            imageView.al_top == al_top,

            addedBadgeView.al_width == 36,
            addedBadgeView.al_height == addedBadgeView.al_width,
            addedBadgeView.al_right == al_right - 12,
            addedBadgeView.al_top == al_top + 96,
            
            shareButton.al_width == 40,
            shareButton.al_height == shareButton.al_width,
            shareButton.al_top == al_top,
            shareButton.al_right == al_right,

            newPackBadge.al_centerY == al_centerY,
            newPackBadge.al_right == al_right - 16,
            newPackBadge.al_width == 44,
            newPackBadge.al_height == 21,

            updatedContentBadge.al_centerY == al_centerY,
            updatedContentBadge.al_right == al_right - 16,
            updatedContentBadge.al_width == 66,
            updatedContentBadge.al_height == 21,

            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY,

            titleLabel.al_top == imageView.al_bottom + contentEdgeInsets.top,
            titleLabel.al_left == al_left + contentEdgeInsets.left,
            titleLabel.al_right == al_right - contentEdgeInsets.right,

            highlightColorBorder.al_width == al_width,
            highlightColorBorder.al_left == al_left,
            highlightColorBorder.al_bottom == al_bottom,
            highlightColorBorder.al_height == 4.5,

            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_width == titleLabel.al_width,
            
            checkmarkBadge.al_centerX == imageView.al_right,
            checkmarkBadge.al_centerY == imageView.al_top,
            checkmarkBadge.al_width == 32,
            checkmarkBadge.al_height == 32
        ])
    }
    
    func setupCellStyle() {
        switch style {
        case .Keyboard:
            addedBadgeView.hidden = true
            shareButton.hidden = false
        case .MainApp:
            addedBadgeView.hidden = false
            shareButton.hidden = true
        }
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
        path.miterLimit = 4
        path.usesEvenOddFillRule = true
        
        return path
    }

    enum BrowseMediaItemCollectionViewCellStyle {
        case Keyboard
        case MainApp
    }
    
}
