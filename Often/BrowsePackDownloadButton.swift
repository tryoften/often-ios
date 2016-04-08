//
//  BrowsePackDownloadButton.swift
//  Often
//
//  Created by Luc Succes on 4/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum BrowsePackDownloadButtonState {
    case Bought
    case InTrial
    case Added
    case NotAdded
}

class BrowsePackDownloadButton: UIButton {
    var pack: PackMediaItem? = nil
    var packState: BrowsePackDownloadButtonState = .NotAdded {
        didSet {
            switch packState {
            case .Added:
                selected = true
            case .NotAdded:
                selected = false
            default: break
            }
        }
    }

    var title: String = "Download".uppercaseString {
        didSet {
            let text = NSAttributedString(string: title, attributes: [
                NSKernAttributeName: NSNumber(float: 1.0),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9)!,
                NSForegroundColorAttributeName: textColor
            ])
            
            setAttributedTitle(text, forState: .Normal)
            setAttributedTitle(text, forState: .Selected)
        }
    }

    override var selected: Bool {
        didSet {
            if selected {
                backgroundColor = WhiteColor
                textColor = BlackColor
                title = "Remove".uppercaseString
            } else {
                backgroundColor = TealColor
                textColor = UIColor.oftWhiteColor()
                title = "Download".uppercaseString
            }
        }
    }
    
    private var textColor: UIColor = UIColor.oftWhiteColor()

    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = TealColor
        contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18)
        layer.cornerRadius = 15
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowColor = MediumLightGrey.CGColor
        layer.shadowOffset = CGSizeMake(0, 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}