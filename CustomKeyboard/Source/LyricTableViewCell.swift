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
        
        lyricView = UIView(frame: CGRectZero)
        lyricView.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        lyricView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(lyricView)
        
        lyricLabel = UILabel(frame: CGRectZero)
        lyricLabel.numberOfLines = 2
        lyricLabel.font = UIFont(name: "Lato-Regular", size: 15)
        lyricLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricLabel.textAlignment = .Center
        lyricView.addSubview(lyricLabel)
        
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
    }
    
    func setupLayout() {
        let shareView = shareVC.view
        
        addConstraints([
            lyricView.al_width == contentView.al_width,
            lyricView.al_top == contentView.al_top,
            lyricView.al_left == contentView.al_left,
            lyricView.al_height == 75.0,
            
            lyricLabel.al_left == lyricView.al_left + 10.0,
            lyricLabel.al_right == lyricView.al_right - 10.0,
            lyricLabel.al_top == lyricView.al_top + 10.0,
            lyricLabel.al_bottom == lyricView.al_bottom - 10.0,
            
            infoView.al_top == lyricView.al_bottom,
            infoView.al_bottom == contentView.al_bottom,
            infoView.al_width == contentView.al_width,
            infoView.al_left == contentView.al_left,
            
            seperatorView.al_bottom == lyricView.al_bottom,
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
    func lyricTableViewCellDidSelect(lyricTableViewCell: LyricTableViewCell)
}