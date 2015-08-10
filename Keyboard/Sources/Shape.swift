//
//  Shape.swift
//  Surf
//
//  Created by Luc Succes on 7/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class Shape: UIView {
    var color: UIColor? {
        didSet {
            if let color = self.color {
                setNeedsDisplay()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    convenience init(color: UIColor) {
        self.init(frame: CGRectZero)
        self.color = color
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        self.opaque = false
        self.clipsToBounds = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}