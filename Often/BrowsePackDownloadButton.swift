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

    var title: String = "Download" {
        didSet {
            let text = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 10.5)!,
                NSKernAttributeName: NSNumber(float: 1.0),
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
                title = "Remove"
            } else {
                backgroundColor = TealColor
                textColor = UIColor.oftWhiteColor()
                title = "Download"
            }
        }
    }
    
    private var textColor: UIColor = UIColor.oftWhiteColor()

    init() {
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}