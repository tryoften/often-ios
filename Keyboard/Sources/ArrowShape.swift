//
//  ArrowShape.swift
//  Often
//
//  Created by Luc Succes on 8/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class ArrowShape: Shape {
    override func drawCall(color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)
        
        //// Page-1
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 10.69, 9.71)
        CGContextScaleCTM(context, 0.5, 0.5)
        
        
        
        //// Often---White-Keyboard
        //// message-field-copy-2-+-Keyboard-Copy-+-search-box-not-selected-copy
        //// Keyboard-Copy
        //// Keys
        //// Arrow
        //// arrow 2
        //// Path-95 Drawing
        var path95Path = UIBezierPath()
        path95Path.moveToPoint(CGPointMake(0, 13.23))
        path95Path.addLineToPoint(CGPointMake(13.03, 0.04))
        path95Path.addLineToPoint(CGPointMake(25.33, 12.89))
        path95Path.miterLimit = 4;
        
        path95Path.usesEvenOddFillRule = true;
        
        color.setStroke()
        path95Path.lineWidth = 3
        path95Path.stroke()
        
        
        //// Path- Drawing
        var pathPath = UIBezierPath()
        pathPath.moveToPoint(CGPointMake(12.87, 0))
        pathPath.addLineToPoint(CGPointMake(12.9, 38.23))
        pathPath.miterLimit = 4;
        
        pathPath.usesEvenOddFillRule = true;
        
        color.setStroke()
        pathPath.lineWidth = 3
        pathPath.stroke()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        CGContextRestoreGState(context)
    }
}