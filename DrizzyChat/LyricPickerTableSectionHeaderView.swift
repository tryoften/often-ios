//
//  LyricPickerTableSectionHeaderView.swift
//  October
//
//  Created by Luc Succes on 7/5/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class LyricPickerTableSectionHeaderView: UITableViewHeaderFooterView {
    var titleLabel: UILabel
    var lyricCountLabel: UILabel
    var highlightColorView: UIView
    
    var title: String? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.5),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 10)!
            ]
            var attributedString = NSAttributedString(string: title!.uppercaseString, attributes: attributes)
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
            var attributedString = NSAttributedString(string: "\(lyricsCount!) lyrics".uppercaseString, attributes: attributes)
            lyricCountLabel.attributedText = attributedString
        }
    }
    
    override convenience init(reuseIdentifier: String?) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        lyricCountLabel = UILabel()
        lyricCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        highlightColorView = UIView()
        highlightColorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        highlightColorView.alpha = 0.9
        
        super.init(frame: frame)
        
        backgroundView = UIView()
        contentView.addSubview(titleLabel)
        contentView.addSubview(highlightColorView)
        contentView.addSubview(lyricCountLabel)
        contentView.backgroundColor = VeryLightGray.colorWithAlphaComponent(0.9)
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == contentView.al_left + 15,
            titleLabel.al_top == contentView.al_top,
            titleLabel.al_bottom == contentView.al_bottom,
            
            lyricCountLabel.al_right == contentView.al_right - 15,
            lyricCountLabel.al_top == contentView.al_top,
            lyricCountLabel.al_bottom == contentView.al_bottom,
            
            highlightColorView.al_bottom == contentView.al_bottom,
            highlightColorView.al_width == contentView.al_width,
            highlightColorView.al_left == contentView.al_left,
            highlightColorView.al_height == 2.0
        ])
    }

}
