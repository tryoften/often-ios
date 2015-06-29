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
                setTitle("ADDED", forState: .Normal)
                backgroundColor = UIColor.whiteColor()
            } else {
                setTitle("ADD ARTIST", forState: .Normal)
                backgroundColor = UIColor(fromHexString: "#F9B341")
            }
            layoutIfNeeded()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

       
        titleLabel?.font = UIFont(name: "OpenSans", size: 9.0)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        selected = false
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

}
