//
//  CategoryCollectionViewCell.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var borderColor: UIColor!
    var highlightColorBorder: UIView!

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CategoryCollectionViewCellBackgroundColor

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

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(highlightColorBorder)

        setupLayout()
        layer.cornerRadius = 2.0
        clipsToBounds = true
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    func setupLayout() {
        addConstraints([
            highlightColorBorder.al_width == al_width,
            highlightColorBorder.al_left == al_left,
            highlightColorBorder.al_top == al_top,
            highlightColorBorder.al_height == 4.5,

            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_width == al_width,

            subtitleLabel.al_centerX == al_centerX,
            subtitleLabel.al_top == titleLabel.al_bottom + 2.0,
            subtitleLabel.al_width == titleLabel.al_width
        ])
    }
}