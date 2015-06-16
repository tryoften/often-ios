//
//  FlexibleBoundsTextField.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class FlexibleBoundsTextField : UITextField {
    var leftMargin : CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
}
