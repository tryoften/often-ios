//
//  LyricTableViewCell.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class LyricTableViewCell: UITableViewCell {

    @IBOutlet weak var lyricLabel: UILabel!
    var delegate: LyricTableViewCellDelegate?
    var isUserLongPressing = false

    var lyric: Lyric? {
        didSet {
            self.lyricLabel?.text = lyric?.text
        }
    }

    var longPressGestureRecognizer: UILongPressGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("didLongPressRow:"))
        
        self.addGestureRecognizer(self.longPressGestureRecognizer!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func didLongPressRow(gestureRecognizer: UILongPressGestureRecognizer) {
        switch(gestureRecognizer.state) {
            case .Began:
                if !isUserLongPressing {
                    self.delegate?.lyricTableViewCellDidLongPress(self)
                    self.isUserLongPressing = true
                }
            break
            
            case .Ended:
                self.isUserLongPressing = false
            break
            
            default:
            break
        }
        
    }
    
}

protocol LyricTableViewCellDelegate {
    func lyricTableViewCellDidLongPress(lyricTableViewCell: LyricTableViewCell)
}