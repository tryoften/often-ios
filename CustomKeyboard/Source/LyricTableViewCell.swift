//
//  LyricTableViewCell.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class LyricTableViewCell: UITableViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var lyricLabel: UILabel!
    
    var shareVC: ShareViewController!
    var metadataView: TrackMetadataView!
    var delegate: LyricTableViewCellDelegate?
    var isUserLongPressing = false

    var lyric: Lyric? {
        didSet {
            lyricLabel?.text = lyric?.text
        }
    }

    var longPressGestureRecognizer: UILongPressGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clearColor()
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("didLongPressRow:"))
        
        addGestureRecognizer(self.longPressGestureRecognizer!)
        clipsToBounds = true
        
        shareVC = ShareViewController()
        infoView.addSubview(shareVC.view)
        
        metadataView = TrackMetadataView(frame: CGRectZero)
        metadataView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        infoView.addSubview(metadataView!)
        infoView.backgroundColor = UIColor(fromHexString: "#eeeeee")
        
        setupLayout()
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
        
        infoView.addConstraints([
            metadataView.al_width == infoView.al_width,
            metadataView.al_height == 40.0,
            metadataView.al_top == infoView.al_top,
            metadataView.al_left == infoView.al_left,
            
            shareView.al_width == infoView.al_width,
            shareView.al_top == metadataView.al_bottom,
            shareView.al_left == infoView.al_left,
            shareView.al_bottom == infoView.al_bottom
        ])
    }
    
    func didLongPressRow(gestureRecognizer: UILongPressGestureRecognizer) {
        switch(gestureRecognizer.state) {
            case .Began:
                if !isUserLongPressing {
                    isUserLongPressing = true
                }
            break
            
            case .Ended:
                isUserLongPressing = false
            break
            
            default:
            break
        }
        
    }
    
}

protocol LyricTableViewCellDelegate {
    func lyricTableViewCellDidLongPress(lyricTableViewCell: LyricTableViewCell)
}