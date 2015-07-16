//
//  LyricTableViewCell.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class LyricTableViewCell: UITableViewCell {
    weak var delegate: LyricTableViewCellDelegate?
    var infoView: UIView!
    var lyricView: UIView!
    var lyricLabel: UILabel!
    var seperatorView: UIView!
    
    var shareVC: ShareViewController?
    var metadataView: TrackMetadataView?
    var loadingIndicatorView: UIImageView?

    var lyric: Lyric? {
        didSet {
            lyricLabel?.text = lyric?.text
        }
    }
    
    var track: Track? {
        didSet {
            if let loadingIndicatorView = loadingIndicatorView,
                let shareVC = shareVC,
                let metadataView = metadataView {
                    loadingIndicatorView.alpha = 1.0
                    shareVC.view.alpha = 0.0
                    metadataView.alpha = 0.0
                    delay(0.3) {
                        UIView.animateWithDuration(0.3) {
                            loadingIndicatorView.alpha = 0.0
                            shareVC.view.alpha = 1.0
                            metadataView.alpha = 1.0
                        }
                    }
                    shareVC.lyric = lyric
                    metadataView.track = track
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        lyricView = UIView(frame: CGRectZero)
        lyricView.backgroundColor = VeryLightGray!
        lyricView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        lyricLabel = UILabel(frame: CGRectZero)
        lyricLabel.numberOfLines = 2
        lyricLabel.font = LyricTableViewCellMainTitleFont
        lyricLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricLabel.textAlignment = .Center
        lyricView.addSubview(lyricLabel)
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        clipsToBounds = true
        contentView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        contentView.addSubview(lyricView)
        contentView.addSubview(seperatorView)

        setupLayout()
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: .Default, reuseIdentifier: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            addInfoView()
            delegate?.lyricTableViewCellDidSelect(self)
        }

        UIView.animateWithDuration(0.3, animations: {
            if selected {
                self.lyricView.backgroundColor = WhiteColor
            } else {
                self.lyricView.backgroundColor = VeryLightGray
            }
        })

    }
    
    func addInfoView() {
        infoView = UIView(frame: CGRectZero)
        infoView.backgroundColor = LyricTableViewCellInfoBackgroundColor
        infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.insertSubview(infoView, belowSubview: lyricView)
        
        loadingIndicatorView = UIImageView()
        loadingIndicatorView!.image = UIImage.animatedImageNamed("october-loader-", duration: 1.1)
        loadingIndicatorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        infoView.addSubview(loadingIndicatorView!)
        
        shareVC = ShareViewController()
        shareVC!.view.alpha = 0.0
        infoView.addSubview(shareVC!.view)
        
        metadataView = TrackMetadataView(frame: CGRectZero)
        metadataView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        metadataView!.alpha = 0.0
        infoView.addSubview(metadataView!)
        
        if let metadataView = metadataView, let loadingIndicatorView = loadingIndicatorView {
            let shareView = shareVC!.view
            
            let constraint = infoView.al_top == lyricView.al_bottom
            constraint.priority = 1000
            
            addConstraints([
                constraint,
                infoView.al_bottom == contentView.al_bottom,
                infoView.al_width == contentView.al_width,
                infoView.al_left == contentView.al_left,
                
                shareView.al_width == infoView.al_width,
                shareView.al_height == 45,
                shareView.al_left == infoView.al_left,
                shareView.al_bottom == infoView.al_bottom,
                
                metadataView.al_bottom == shareView.al_top,
                metadataView.al_width <= infoView.al_width,
                metadataView.al_top == infoView.al_top,
                metadataView.al_left == infoView.al_left,
                metadataView.al_right == infoView.al_right,
                
                loadingIndicatorView.al_width == 100,
                loadingIndicatorView.al_height == 80,
                loadingIndicatorView.al_centerX == infoView.al_centerX,
                loadingIndicatorView.al_centerY == infoView.al_centerY
            ])
        }
    }
    
    override func prepareForReuse() {
        if let infoView = infoView,
            let shareVC = shareVC,
            let metadataView = metadataView {
                infoView.removeFromSuperview()
                shareVC.view.removeFromSuperview()
                metadataView.removeFromSuperview()
        }
        infoView = nil
        shareVC = nil
        metadataView = nil
    }
    
    func setupLayout() {
        addConstraints([
            lyricView.al_width == contentView.al_width,
            lyricView.al_top == contentView.al_top,
            lyricView.al_left == contentView.al_left,
            lyricView.al_height == LyricTableViewCellHeight,
            
            lyricLabel.al_left == lyricView.al_left + 10.0,
            lyricLabel.al_right == lyricView.al_right - 10.0,
            lyricLabel.al_top == lyricView.al_top + 10.0,
            lyricLabel.al_bottom == lyricView.al_bottom - 10.0,
            
            seperatorView.al_bottom == lyricView.al_bottom,
            seperatorView.al_width == contentView.al_width,
            seperatorView.al_left == contentView.al_left,
            seperatorView.al_height == 1.0
        ])
    }
    
}

protocol LyricTableViewCellDelegate: class {
    func lyricTableViewCellDidSelect(lyricTableViewCell: LyricTableViewCell)
}