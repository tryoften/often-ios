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

    var itemCount: Int? {
        didSet {
            subtitleLabel.setTextWith(ArtistCollectionViewCellSubtitleFont!,
                                      letterSpacing: 1.0,
                                      color: ArtistCollectionViewCellSubtitleTextColor,
                                      text: "\(itemCount!) Quotes & Gifs".uppercased())
        }
    }
    
    var style: BrowseMediaItemCollectionViewCellStyle = .mainApp {
        didSet {
            setupCellStyle()
        }
    }

    override init(frame: CGRect) {
        placeholderImageView = UIImageView()
        placeholderImageView.backgroundColor = VeryLightGray
        placeholderImageView.contentMode = .center
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false

        addedBadgeView = UIImageView(image: StyleKit.imageOfCheckicon(color: TealColor!, scale: 0.4))
        addedBadgeView.backgroundColor = WhiteColor
        addedBadgeView.translatesAutoresizingMaskIntoConstraints = false
        addedBadgeView.layer.cornerRadius = 18.0
        addedBadgeView.layer.shadowRadius = 2
        addedBadgeView.layer.shadowOpacity = 0.2
        addedBadgeView.layer.shadowColor = MediumLightGrey?.cgColor
        addedBadgeView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.backgroundColor = ClearColor
        shareButton.setImage(StyleKit.imageOfShareCanvas(color: WhiteColor), for: UIControlState())

        var layer = CAShapeLayer()
        layer.path = BrowseMediaItemCollectionViewCell.drawImageMask().cgPath
        layer.fillColor = UIColor.white().cgColor
        layer.backgroundColor = UIColor.clear().cgColor
        layer.frame = CGRect(x: 0, y: 0, width: ArtistCollectionViewCellWidth, height: ArtistCollectionViewCellWidth)
        placeholderImageView.layer.mask = layer

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        layer = CAShapeLayer()
        layer.path = BrowseMediaItemCollectionViewCell.drawImageMask().cgPath
        layer.fillColor = UIColor.white().cgColor
        layer.backgroundColor = UIColor.clear().cgColor
        imageView.layer.mask = layer

        highlightColorBorder = UIView(frame: CGRect.zero)
        highlightColorBorder.translatesAutoresizingMaskIntoConstraints = false
        highlightColorBorder.backgroundColor = UIColor.oftGreenblueColor()
        highlightColorBorder.isHidden = true

        titleLabel = UILabel()
        titleLabel.font = ArtistCollectionViewCellTitleFont
        titleLabel.textColor = ArtistCollectionViewCellTitleTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left

        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .left

        contentEdgeInsets = UIEdgeInsets(top: 15, left: 14, bottom: 10, right: 14)

        super.init(frame: frame)
        
        addSubview(placeholderImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(addedBadgeView)
        addSubview(highlightColorBorder)
        addSubview(shareButton)

        backgroundColor = UIColor.white()
        self.layer.cornerRadius = 2.0
        self.layer.shadowColor = UIColor.black().cgColor
        self.layer.shadowOpacity = 0.14
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1

        isSelected = false
        style = .mainApp
        setupLayout()

        let width: CGFloat = self.frame.size.width
        setImageViewLayers(CGRect(x: 0, y: 0, width: width, height: frame.size.height/2 + 20))
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }

    func setImageViewLayers(_ frame: CGRect) {
        var layer = CAShapeLayer()
        layer.path = self.dynamicType.drawImageMask(frame: frame).cgPath
        layer.fillColor = UIColor.white().cgColor
        layer.backgroundColor = UIColor.clear().cgColor
        layer.frame = frame
        placeholderImageView.layer.mask = layer

        layer = CAShapeLayer()
        layer.path = self.dynamicType.drawImageMask(frame: frame).cgPath
        layer.fillColor = UIColor.white().cgColor
        layer.backgroundColor = UIColor.clear().cgColor
        layer.frame = frame
        imageView.layer.mask = layer
    }


    override func prepareForReuse() {
        imageView.image = nil
        highlightColorBorder.isHidden = true
    }

    func setupLayout() {
        var constraints = [
            imageView.al_width == al_width,
            imageView.al_height == al_height / 2 + 20,
            imageView.al_centerX == al_centerX,
            imageView.al_top == al_top
        ]

        constraints += [
            addedBadgeView.al_width == 36,
            addedBadgeView.al_height == addedBadgeView.al_width,
            addedBadgeView.al_right == al_right - 12,
            addedBadgeView.al_top == al_top + 96
        ]

        constraints += [
            shareButton.al_width == 40,
            shareButton.al_height == shareButton.al_width,
            shareButton.al_top == al_top,
            shareButton.al_right == al_right
        ]

        constraints += [
            placeholderImageView.al_width == imageView.al_width,
            placeholderImageView.al_height == imageView.al_height,
            placeholderImageView.al_centerX == imageView.al_centerX,
            placeholderImageView.al_centerY == imageView.al_centerY
        ]

        constraints += [
            titleLabel.al_top == imageView.al_bottom + contentEdgeInsets.top,
            titleLabel.al_left == al_left + contentEdgeInsets.left,
            titleLabel.al_right == al_right - contentEdgeInsets.right
        ]

        constraints += [
            highlightColorBorder.al_width == al_width,
            highlightColorBorder.al_left == al_left,
            highlightColorBorder.al_bottom == al_bottom,
            highlightColorBorder.al_height == 4.5
        ]

        constraints += [
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == titleLabel.al_left,
            subtitleLabel.al_width == titleLabel.al_width
        ]

        addConstraints(constraints)
    }
    
    func setupCellStyle() {
        switch style {
        case .keyboard:
            addedBadgeView.isHidden = true
            shareButton.isHidden = false
        case .mainApp:
            addedBadgeView.isHidden = false
            shareButton.isHidden = true
        }
    }

    class func drawImageMask(frame: CGRect = CGRect(x: 0, y: 0, width: ArtistCollectionViewCellWidth, height: ArtistCollectionViewCellWidth)) -> UIBezierPath {
        //// path Drawing
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.01428 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.01481 * frame.width, y: frame.minY + -0.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.00639 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.00665 * frame.width, y: frame.minY + -0.00000 * frame.height))
        path.addLine(to: CGPoint(x: frame.minX + 0.98519 * frame.width, y: frame.minY + -0.00000 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.01428 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.99337 * frame.width, y: frame.minY + -0.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.00640 * frame.height))
        path.addLine(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.85646 * frame.height))
        path.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 1.00000 * frame.height))
        path.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.01428 * frame.height))
        path.close()
        path.miterLimit = 4
        path.usesEvenOddFillRule = true
        
        return path
    }

    enum BrowseMediaItemCollectionViewCellStyle {
        case keyboard
        case mainApp
    }
    
}
