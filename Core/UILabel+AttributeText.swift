//
//  UILabel+AttributeText.swift
//  Often
//
//  Created by Kervins Valcourt on 4/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

extension UILabel {
    func setTextWith(_ font: UIFont, letterSpacing: Float, color: UIColor, lineHeight: CGFloat = 1.0, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(value: letterSpacing),
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        attributedText = AttributedString(string: text, attributes: attributes)
    }
}
