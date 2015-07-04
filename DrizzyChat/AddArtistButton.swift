//
//  AddArtistButton.swift
//  Drizzy
//
//  Created by Luc Succes on 6/29/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class AddArtistButton: UIButton {
    
    override var selected: Bool {
        didSet {
            if selected {
                setTitle("REMOVE ARTIST", forState: .Normal)
                setTitleColor(UIColor.blackColor(), forState: .Normal)
                backgroundColor = UIColor.whiteColor()
            } else {
                setTitle("ADD ARTIST", forState: .Normal)
                setTitleColor(UIColor.whiteColor(), forState: .Normal)
                backgroundColor = UIColor.clearColor()
            }
            layoutIfNeeded()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        titleLabel?.font = UIFont(name: "OpenSans", size: 12.0)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        backgroundColor = UIColor.clearColor()
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1

        selected = false
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

}
