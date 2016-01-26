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
    var artistImageView: UIImageView
    var artistView: UIView
    var artistImageViewWidthConstraint: NSLayoutConstraint

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
            rightLabel.textAlignment = .Right
        }
    }
    
    var showImageView: Bool {
        didSet {
            artistImageViewWidthConstraint.constant = showImageView ? 18 : 0
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
        
        artistImageView = UIImageView()
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        artistImageView.contentMode = .ScaleAspectFill
        artistImageView.layer.cornerRadius = 2.0
        artistImageView.clipsToBounds = true

        artistView = UIView()
        artistView.translatesAutoresizingMaskIntoConstraints = false
        
        artistImageViewWidthConstraint = artistImageView.al_width == 18
        
        artistView.addSubview(artistImageView)
        artistView.addSubview(leftLabel)
        
        showImageView = false

        super.init(frame: frame)

        addSubview(artistView)
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
            artistView.al_left == al_left,
            artistView.al_top == al_top,
            artistView.al_bottom == al_bottom,
            artistView.al_right <= al_centerX,
            
            artistImageView.al_left == artistView.al_left + 10,
            artistImageView.al_top == artistView.al_top + 10,
            artistImageView.al_height == 18,
            artistImageViewWidthConstraint,
            
            leftLabel.al_left == artistImageView.al_right + 6,
            leftLabel.al_centerY == artistImageView.al_centerY,
            leftLabel.al_height == 16,
            leftLabel.al_right == artistView.al_right,
            
            rightLabel.al_right == al_right - 10,
            rightLabel.al_left <= al_centerX,
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
