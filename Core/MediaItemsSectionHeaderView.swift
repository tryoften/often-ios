//
//  MediaItemsSectionHeaderView.swift
//  Often
//
//  Created by Luc Succes on 12/17/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class MediaItemsSectionHeaderView: UICollectionReusableView {
    var leftLabel: UILabel
    var rightLabel: UILabel
    var topSeperator: UIView
    var bottomSeperator: UIView

    var leftText: String? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.25),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9.5)!,
                NSForegroundColorAttributeName: BlackColor.colorWithAlphaComponent(0.54)
            ]
            let attributedString = NSAttributedString(string: leftText!.uppercaseString, attributes: attributes)
            leftLabel.attributedText = attributedString
        }
    }
    var rightText: String? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9.5)!,
                NSForegroundColorAttributeName: UIColor.grayColor()
            ]
            let attributedString = NSAttributedString(string: rightText!.uppercaseString, attributes: attributes)
            rightLabel.attributedText = attributedString
        }
    }

    override init(frame: CGRect) {
        leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false

        rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false

        topSeperator = UIView()
        topSeperator.translatesAutoresizingMaskIntoConstraints = false
        topSeperator.backgroundColor = DarkGrey

        bottomSeperator = UIView()
        bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeperator.backgroundColor = DarkGrey

        super.init(frame: frame)

        addSubview(leftLabel)
        addSubview(rightLabel)
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
            leftLabel.al_left == al_left + 10,
            leftLabel.al_centerY == al_centerY,

            rightLabel.al_right == al_right - 10,
            rightLabel.al_top == al_top,
            rightLabel.al_bottom == al_bottom,

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
