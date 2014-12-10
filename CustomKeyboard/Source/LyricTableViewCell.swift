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
        
        lyricLabel = UILabel(frame: CGRectZero)
        lyricLabel.numberOfLines = 2
        lyricLabel.font = UIFont(name: "Lato-Regular", size: 15)
        lyricLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricLabel.textAlignment = .Center
        lyricLabel.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        contentView.addSubview(lyricLabel)
        
        infoView = UIView(frame: CGRectZero)
        infoView.backgroundColor = UIColor(fromHexString: "#eeeeee")
        infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(infoView)

        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(seperatorView)
        
        shareVC = ShareViewController()
        infoView.addSubview(shareVC.view)
        
        metadataView = TrackMetadataView(frame: CGRectZero)
        metadataView.setTranslatesAutoresizingMaskIntoConstraints(false)
        infoView.addSubview(metadataView!)
        
        contentView.bringSubviewToFront(lyricLabel)
        contentView.insertSubview(seperatorView, aboveSubview: lyricLabel)
        
        setupLayout()
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: .Default, reuseIdentifier: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate?.lyricTableViewCellDidLongPress(self)
        }

        // Configure the view for the selected state
    }
    
    func setupLayout() {
        let shareView = shareVC.view
        
        self.addConstraints([
            contentView.al_top == self.al_top,
            contentView.al_bottom == self.al_bottom,
            contentView.al_left == self.al_left,
            contentView.al_right == self.al_right,
            
            lyricLabel.al_width == contentView.al_width,
            lyricLabel.al_top == contentView.al_top,
            lyricLabel.al_left == contentView.al_left,
            lyricLabel.al_height == 80.0,
            
            infoView.al_top == lyricLabel.al_bottom,
            infoView.al_bottom == contentView.al_bottom,
            infoView.al_width == contentView.al_width,
            infoView.al_left == contentView.al_left,
            
            seperatorView.al_bottom == lyricLabel.al_bottom,
            seperatorView.al_width == contentView.al_width,
            seperatorView.al_left == contentView.al_left,
            seperatorView.al_height == 1.0,
            
            metadataView.al_width == infoView.al_width,
            metadataView.al_height == 50.0,
            metadataView.al_top == infoView.al_top,
            metadataView.al_left == infoView.al_left,
            
            shareView.al_width == infoView.al_width,
            shareView.al_top == metadataView.al_bottom,
            shareView.al_left == infoView.al_left,
            shareView.al_bottom == infoView.al_bottom
        ])
    }
    
}

protocol LyricTableViewCellDelegate {
    func lyricTableViewCellDidLongPress(lyricTableViewCell: LyricTableViewCell)
}