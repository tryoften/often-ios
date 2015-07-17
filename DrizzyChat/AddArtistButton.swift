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
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
            if selected {
                setTitle("REMOVE ARTIST", forState: .Normal)
                setTitleColor(RemoveArtistsButtonTitleColor, forState: .Normal)
                backgroundColor = RemoveArtistsButtonBackgroundColor
                layer.borderColor = RemoveArtistsButtonBorderColor
            } else {
                setTitle("ADD ARTIST", forState: .Normal)
                setTitleColor(AddArtistsButtonTitleColor, forState: .Normal)
                backgroundColor = AddArtistsButtonBackgroundColor
                layer.borderColor = backgroundColor?.CGColor
            }
            layoutIfNeeded()
            UIView.commitAnimations()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        titleLabel?.font = AddArtistsButtonFont
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layer.borderWidth = 1

        selected = false
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

}
