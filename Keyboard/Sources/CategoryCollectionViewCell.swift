//
//  CategoryCollectionViewCell.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import FLAnimatedImage

class CategoryCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var highlightColorBorder: UIView
    var backgroundImageView: UIImageView
    var searchOverlayView: SearchOverlayView
    
    private var tintView: UIView

    var title: String? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.0),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 11.0)!,
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ]
            let attributedString = NSAttributedString(string: title!.uppercaseString, attributes: attributes)
            titleLabel.attributedText = attributedString
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                highlightColorBorder.hidden = false
            } else {
                highlightColorBorder.hidden = true
            }
        }
    }

    override init(frame: CGRect) {
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        tintView = UIImageView()
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)

        searchOverlayView = SearchOverlayView()
        searchOverlayView.hidden = true
        searchOverlayView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel = UILabel()
        titleLabel.textColor = CategoryCollectionViewCellTitleLabelTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = CategoryCollectionViewCellTitleFont
        titleLabel.textAlignment = .Center

        subtitleLabel = UILabel()
        subtitleLabel.textColor = CategoryCollectionViewCellSubtitleTextColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = CategoryCollectionViewCellSubtitleFont
        subtitleLabel.textAlignment = .Center

        highlightColorBorder = UIView(frame: CGRectZero)
        highlightColorBorder.translatesAutoresizingMaskIntoConstraints = false
        highlightColorBorder.backgroundColor = UIColor.oftGreenblueColor()
        highlightColorBorder.hidden = true

        super.init(frame: frame)
        backgroundColor = CategoryCollectionViewCellBackgroundColor

        addSubview(backgroundImageView)
        addSubview(tintView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(highlightColorBorder)
        addSubview(searchOverlayView)

        setupLayout()
        layer.cornerRadius = 2.0
        clipsToBounds = true
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    func setupLayout() {
        addConstraints([
            backgroundImageView.al_top == al_top,
            backgroundImageView.al_right == al_right,
            backgroundImageView.al_left == al_left,
            backgroundImageView.al_bottom == al_bottom,

            tintView.al_top == al_top,
            tintView.al_bottom == al_bottom,
            tintView.al_left == al_left,
            tintView.al_right == al_right,

            highlightColorBorder.al_width == al_width,
            highlightColorBorder.al_left == al_left,
            highlightColorBorder.al_bottom == al_bottom,
            highlightColorBorder.al_height == 4.5,

            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_width == al_width,

            searchOverlayView.al_top == contentView.al_top,
            searchOverlayView.al_bottom == contentView.al_bottom,
            searchOverlayView.al_left == contentView.al_left,
            searchOverlayView.al_right == contentView.al_right,

            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top == titleLabel.al_bottom + 2.0,
            subtitleLabel.al_width == titleLabel.al_width
        ])
    }
}
