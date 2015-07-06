//
//  LyricTableViewCell.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class LyricTableViewCell: UITableViewCell {
    var infoView: UIView!
    var lyricView: UIView!
    var lyricLabel: UILabel!
    var shareVC: ShareViewController!
    var metadataView: TrackMetadataView!
    var seperatorView: UIView!
    var delegate: LyricTableViewCellDelegate?

    var lyric: Lyric? {
        didSet {
            lyricLabel?.text = lyric?.text
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        clipsToBounds = true
        
        contentView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        lyricView = UIView(frame: CGRectZero)
        lyricView.backgroundColor = LyricTableViewCellTextViewBackgroundColor!
        lyricView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(lyricView)
        
        lyricLabel = UILabel(frame: CGRectZero)
        lyricLabel.numberOfLines = 2
        lyricLabel.font = LyricTableViewCellMainTitleFont
        lyricLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricLabel.textAlignment = .Center
        lyricView.addSubview(lyricLabel)
        
        infoView = UIView(frame: CGRectZero)
        infoView.backgroundColor = LyricTableViewCellInfoBackgroundColor
        infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(infoView)

        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(seperatorView)
        
        shareVC = ShareViewController()
        infoView.addSubview(shareVC.view)
        
        metadataView = TrackMetadataView(frame: CGRectZero)
        metadataView.setTranslatesAutoresizingMaskIntoConstraints(false)
        infoView.addSubview(metadataView!)
        
        contentView.bringSubviewToFront(lyricView)
        contentView.insertSubview(seperatorView, aboveSubview: lyricView)
        
        setupLayout()
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: .Default, reuseIdentifier: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate?.lyricTableViewCellDidSelect(self)
        }

        UIView.animateWithDuration(0.3, animations: {
            if selected {
                self.lyricView.backgroundColor = LyricTableViewCellHighlightedBackgroundColor
            } else {
                self.lyricView.backgroundColor = LyricTableViewCellNormalBackgroundColor
            }
        })

    }
    
    override func prepareForReuse() {
        metadataView.resetConstraints()
    }
    
    func setupLayout() {
        let shareView = shareVC.view
        
        addConstraints([
            lyricView.al_width == contentView.al_width,
            lyricView.al_top == contentView.al_top,
            lyricView.al_left == contentView.al_left,
            lyricView.al_height == LyricTableViewCellHeight,
            
            lyricLabel.al_left == lyricView.al_left + 2.0,
            lyricLabel.al_right == lyricView.al_right - 2.0,
            lyricLabel.al_top == lyricView.al_top + 2.0,
            lyricLabel.al_bottom == lyricView.al_bottom - 2.0,
            
            infoView.al_top == lyricView.al_bottom,
            infoView.al_bottom == contentView.al_bottom,
            infoView.al_width == contentView.al_width,
            infoView.al_left == contentView.al_left,
            
            seperatorView.al_bottom == lyricView.al_bottom,
            seperatorView.al_width == contentView.al_width,
            seperatorView.al_left == contentView.al_left,
            seperatorView.al_height == 1.0,
            
            metadataView.al_bottom == shareView.al_top,
            metadataView.al_width <= infoView.al_width,
            metadataView.al_top == infoView.al_top,
            metadataView.al_left == infoView.al_left,
            metadataView.al_right == infoView.al_right,
            
            shareView.al_width == infoView.al_width,
            shareView.al_height == 45,
            shareView.al_left == infoView.al_left,
            shareView.al_bottom == infoView.al_bottom
        ])
    }
    
}

protocol LyricTableViewCellDelegate {
    func lyricTableViewCellDidSelect(lyricTableViewCell: LyricTableViewCell)
}