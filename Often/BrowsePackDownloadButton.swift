//
//  BrowsePackDownloadButton.swift
//  Often
//
//  Created by Luc Succes on 4/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum BrowsePackDownloadButtonState {
    case bought
    case inTrial
    case added
    case notAdded
}

class BrowsePackDownloadButton: UIButton {
    var pack: PackMediaItem? = nil
    var packState: BrowsePackDownloadButtonState = .notAdded {
        didSet {
            switch packState {
            case .added:
                isSelected = true
            case .notAdded:
                isSelected = false
            default: break
            }
        }
    }

    var title: String = "Download".uppercased() {
        didSet {
            let text = AttributedString(string: title, attributes: [
                NSKernAttributeName: NSNumber(value: 1.0),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 9)!,
                NSForegroundColorAttributeName: textColor
            ])
            
            setAttributedTitle(text, for: UIControlState())
            setAttributedTitle(text, for: .selected)
        }
    }

    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.isSelected {
                    self.backgroundColor = WhiteColor
                    self.textColor = BlackColor!
                    self.title = "Remove".uppercased()
                } else {
                    self.backgroundColor = TealColor
                    self.textColor = UIColor.oftWhiteColor()
                    self.title = "Download".uppercased()
                }
            }
        }
    }
    
    private var textColor: UIColor = UIColor.oftWhiteColor()

    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = TealColor
        contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18)
        layer.cornerRadius = 15
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowColor = MediumLightGrey?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
