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
            guard let pack = pack else {
                return
            }

            if pack.premium {

            } else {

            }
        }
    }

    var title: String = "Download" {
        didSet {
            let text = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 10.5)!,
                NSKernAttributeName: NSNumber(float: 1.0),
                NSForegroundColorAttributeName: UIColor.oftWhiteColor()
            ])
            setAttributedTitle(text, forState: .Normal)
        }
    }

    override var selected: Bool {
        didSet {
            if selected {
                backgroundColor = WhiteColor
            } else {
                backgroundColor = TealColor
            }
        }
    }

    init() {
        super.init(frame: CGRectZero)


        setTitleColor(BlackColor, forState: .Selected)
        setTitleColor(WhiteColor, forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}