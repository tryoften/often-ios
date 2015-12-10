//
//  TrendingLyricsSectionHeaderView.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class TrendingLyricsSectionHeaderView: UICollectionReusableView {
    var titleLabel: UILabel
    var lyricCountLabel: UILabel
    var topSeperator: UIView
    var bottomSeperator: UIView

    var title: String? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.5),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 10)!,
                NSForegroundColorAttributeName: BlackColor
            ]
            let attributedString = NSAttributedString(string: title!.uppercaseString, attributes: attributes)
            titleLabel.attributedText = attributedString
        }
    }
    var lyricsCount: Int? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.5),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 10)!,
                NSForegroundColorAttributeName: UIColor.grayColor()
            ]
            let attributedString = NSAttributedString(string: "\(lyricsCount!) lyrics".uppercaseString, attributes: attributes)
            lyricCountLabel.attributedText = attributedString
        }
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        lyricCountLabel = UILabel()
        lyricCountLabel.translatesAutoresizingMaskIntoConstraints = false

        topSeperator = UIView()
        topSeperator.translatesAutoresizingMaskIntoConstraints = false
        topSeperator.backgroundColor = DarkGrey

        bottomSeperator = UIView()
        bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeperator.backgroundColor = DarkGrey

        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(lyricCountLabel)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        backgroundColor = UIColor(fromHexString: "#f7f7f7").colorWithAlphaComponent(0.9)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            titleLabel.al_left == al_left + 15,
            titleLabel.al_bottom == al_bottom - 5,

            lyricCountLabel.al_right == al_right - 15,
            lyricCountLabel.al_top == al_top,
            lyricCountLabel.al_bottom == al_bottom,

            topSeperator.al_top == al_top,
            topSeperator.al_left == al_left,
            topSeperator.al_width == al_width,
            topSeperator.al_height == 0.6,

            bottomSeperator.al_bottom == al_bottom,
            bottomSeperator.al_left == al_left,
            bottomSeperator.al_width == al_width,
            bottomSeperator.al_height == 0.6,
        ])
    }
    
}
