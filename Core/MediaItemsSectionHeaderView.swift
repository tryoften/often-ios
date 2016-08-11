//
//  MediaItemsSectionHeaderView.swift
//  Often
//
//  Created by Luc Succes on 12/17/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit
import Nuke

class MediaItemsSectionHeaderView: UICollectionReusableView {
    var leftLabel: UILabel
    var rightLabel: UILabel
    var middleLabel: UILabel
    var topSeperator: UIView
    var bottomSeperator: UIView
    var artistImageView: UIImageView
    var artistView: UIView
    var contentEdgeInsets: UIEdgeInsets
    
    private var artistImageViewWidthConstraint: NSLayoutConstraint
    private var leftHeaderLabelLeftPaddingConstraint: NSLayoutConstraint?

    let attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.25),
        NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9.5)!,
        NSForegroundColorAttributeName: UIColor.oftBlack74Color()
    ]
    
    var leftText: String? {
        didSet {
            let attributedString = NSAttributedString(string: leftText!.uppercaseString, attributes: attributes)
            leftLabel.attributedText = attributedString
        }
    }
    var rightText: String? {
        didSet {
            let attributedString = NSAttributedString(string: rightText!.uppercaseString, attributes: attributes)
            rightLabel.attributedText = attributedString
            rightLabel.textAlignment = .Right
        }
    }
    
    var middleText: String? {
        didSet {
            let attributedString = NSAttributedString(string: middleText!.uppercaseString, attributes: attributes)
            middleLabel.attributedText = attributedString
        }
    }
    
    var artistImageURL: NSURL? {
        didSet {
            if let _ = artistImageURL {
                artistImageView.nk_setImageWith(artistImageURL!)
                artistImageViewWidthConstraint.constant = 18
                leftHeaderLabelLeftPaddingConstraint?.constant = contentEdgeInsets.left + 24
            } else {
                artistImageViewWidthConstraint.constant = 0
                leftHeaderLabelLeftPaddingConstraint?.constant = contentEdgeInsets.left
            }
        }
    }

    override init(frame: CGRect) {
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        middleLabel = UILabel()
        middleLabel.translatesAutoresizingMaskIntoConstraints = false

        rightLabel = UILabel()
        rightLabel.textAlignment = .Right
        rightLabel.lineBreakMode = .ByTruncatingHead
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
        
        artistImageViewWidthConstraint = artistImageView.al_width == 0
        
        artistView.addSubview(artistImageView)
        artistView.addSubview(leftLabel)
        
        super.init(frame: frame)
        
        leftHeaderLabelLeftPaddingConstraint = leftLabel.al_left == al_left + contentEdgeInsets.left

        addSubview(artistView)
        addSubview(middleLabel)
        addSubview(rightLabel)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        backgroundColor = WhiteColor
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
            
            artistImageView.al_left == artistView.al_left + contentEdgeInsets.left,
            artistImageView.al_top == artistView.al_top + contentEdgeInsets.top,
            artistImageView.al_height == 18,
            artistImageViewWidthConstraint,
            
            leftHeaderLabelLeftPaddingConstraint!,
            leftLabel.al_left == artistImageView.al_right + 6,
            leftLabel.al_centerY == artistImageView.al_centerY,
            leftLabel.al_height == 16,
            leftLabel.al_right == artistView.al_right,
            leftLabel.al_width >= al_width / 3 - 20,
            
            middleLabel.al_centerX == al_centerX,
            middleLabel.al_centerY == al_centerY,
            middleLabel.al_height == leftLabel.al_height,

            rightLabel.al_right == al_right - 10,
            rightLabel.al_left == leftLabel.al_right + 10,
            rightLabel.al_height == leftLabel.al_height,
            rightLabel.al_centerY == leftLabel.al_centerY,

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

    override func prepareForReuse() {
        artistImageView.image = nil
        rightLabel.text = nil
        leftLabel.text = nil
        middleLabel.text = nil
    }

}
