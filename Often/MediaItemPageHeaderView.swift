//
//  MediaItemPageHeaderView.swift
//  Often
//
//  Created by Luc Succes on 1/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class MediaItemPageHeaderView: UICollectionReusableView {
    var screenWidth: CGFloat
    var coverPhoto: UIImageView
    var titleLabel: UILabel
    var collapseTitleLabel: UILabel
    var subtitleLabel: UILabel
    var packBackgroundColor: UIView
    var coverPhotoContainer: UIView

    var editingMode: Bool {
        didSet {
            if editingMode {
                titleLabel.backgroundColor = VeryLightGray
            } else {
                titleLabel.backgroundColor = ClearColor
            }
        }
    }

    var imageURL: NSURL? {
        willSet(newValue) {
            if let url = newValue where imageURL != newValue {
                coverPhoto.nk_setImageWith(url)
            }
        }
    }

    var mediaItem: MediaItem?

    var title: String = "" {
        didSet {
            titleLabel.attributedText = NSAttributedString(string: title.uppercaseString, attributes: [
                NSKernAttributeName: NSNumber(float: 1.7),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                NSForegroundColorAttributeName: UIColor.oftBlackColor()
            ])

            collapseTitleLabel.attributedText = NSAttributedString(string: title.uppercaseString, attributes: [
                NSKernAttributeName: NSNumber(float: 1.2),
                NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 14.0)!,
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ])
        }
    }

    var subtitle: String = "" {
        didSet {
            subtitleLabel.attributedText = NSAttributedString(string: subtitle, attributes: [
                NSKernAttributeName: NSNumber(float: 0.6),
                NSFontAttributeName: UIFont(name: "OpenSans", size: 12)!,
                NSForegroundColorAttributeName: UIColor.oftBlack74Color()
            ])
        }
    }

    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        editingMode = false

        coverPhotoContainer = UIView()
        coverPhotoContainer.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoContainer.layer.shadowRadius = 2
        coverPhotoContainer.layer.shadowOpacity = 0.4
        coverPhotoContainer.layer.shadowColor = MediumLightGrey.CGColor
        coverPhotoContainer.layer.shadowOffset = CGSizeMake(0, 1)

        coverPhoto = UIImageView()
        coverPhoto.backgroundColor = VeryLightGray
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.contentMode = .ScaleAspectFill
        coverPhoto.layer.cornerRadius = 4.0
        coverPhoto.layer.shadowRadius = 2
        coverPhoto.layer.shadowOpacity = 0.2
        coverPhoto.layer.shadowColor = MediumLightGrey.CGColor
        coverPhoto.layer.shadowOffset = CGSizeMake(0, 1)
        coverPhoto.clipsToBounds = true

        packBackgroundColor = UIView()
        packBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        packBackgroundColor.backgroundColor = BlackColor

        let layer = CAShapeLayer()
        layer.path = MediaItemPageHeaderView.drawPackBackgroundMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        packBackgroundColor.layer.mask = layer

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        titleLabel.textColor = BlackColor
        titleLabel.lineBreakMode = .ByTruncatingTail
        titleLabel.textAlignment = .Center

        collapseTitleLabel = UILabel()
        collapseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collapseTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        collapseTitleLabel.textColor = UIColor.oftWhiteColor()
        collapseTitleLabel.lineBreakMode = .ByTruncatingTail
        collapseTitleLabel.textAlignment = .Center
        collapseTitleLabel.alpha = 0
        
        subtitleLabel = UILabel()
        subtitleLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        subtitleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .Center
        subtitleLabel.alpha = 0.74
        subtitleLabel.numberOfLines = 2

        super.init(frame: frame)

        backgroundColor = UIColor.oftWhiteColor()

        coverPhotoContainer.addSubview(coverPhoto)
        addSubview(packBackgroundColor)
        addSubview(coverPhotoContainer)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(collapseTitleLabel)

        clipsToBounds = true
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            collapseTitleLabel.al_top == al_top + 21.5,
            collapseTitleLabel.al_width <= al_width - 30,
            collapseTitleLabel.al_centerX == al_centerX,
            collapseTitleLabel.al_height == 22,

            packBackgroundColor.al_top == al_top,
            packBackgroundColor.al_left == al_left,
            packBackgroundColor.al_width == al_width,
            packBackgroundColor.al_height == al_height,

            coverPhotoContainer.al_centerX == al_centerX,
            coverPhotoContainer.al_centerY == al_centerY,
            coverPhotoContainer.al_width == 175,
            coverPhotoContainer.al_height == 175,

            coverPhoto.al_top == coverPhotoContainer.al_top,
            coverPhoto.al_left == coverPhotoContainer.al_left,
            coverPhoto.al_right == coverPhotoContainer.al_right,
            coverPhoto.al_bottom == coverPhotoContainer.al_bottom,

            titleLabel.al_top >= coverPhoto.al_bottom + 24,
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_height == 22,
            titleLabel.al_width == al_width - 30,

            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top  == titleLabel.al_bottom + 5
        ])
    }


    class func drawPackBackgroundMask(frame frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 455.5/2)) -> UIBezierPath  {
        //// path Drawing
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + -0.00000 * frame.height))
        path.addLineToPoint(CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + -0.00000 * frame.height))
        path.addLineToPoint(CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.65976 * frame.height))
        path.addLineToPoint(CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 1.00000 * frame.height))
        path.addLineToPoint(CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + -0.00000 * frame.height))
        path.closePath()
        path.miterLimit = 4

        path.usesEvenOddFillRule = true
        
        return path
    }

}
