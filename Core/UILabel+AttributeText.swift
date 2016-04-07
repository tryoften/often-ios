//
//  UILabel+AttributeText.swift
//  Often
//
//  Created by Kervins Valcourt on 4/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

extension UILabel {
    func setTextWith(font: UIFont, letterSpacing: Float, color: UIColor, text: String) {
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: letterSpacing),
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
        ]

        attributedText = NSAttributedString(string: text.uppercaseString, attributes: attributes)
    }
}