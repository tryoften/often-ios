//
//  BackspaceShape.swift
//  Often
//
//  Created by Luc Succes on 8/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class BackspaceShape: Shape {
    override func drawCall(color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Page-1
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 7, 10)
        CGContextScaleCTM(context, 0.5, 0.5)
        
        
        
        //// Often---White-Keyboard-Copy
        //// message-field-copy-2-+-Keyboard-Copy-+-search-box-not-selected-copy
        //// Keyboard-Copy
        //// Keys
        //// Arrow-and-Line
        //// Group 7
        //// Arrow-Copy-2
        //// Path-95 Drawing
        var path95Path = UIBezierPath()
        path95Path.moveToPoint(CGPointMake(22.95, 33.31))
        path95Path.addLineToPoint(CGPointMake(9.75, 20.28))
        path95Path.addLineToPoint(CGPointMake(22.6, 7.97))
        path95Path.miterLimit = 4;
        
        path95Path.usesEvenOddFillRule = true;
        
        color.setStroke()
        path95Path.lineWidth = 3
        path95Path.stroke()
        
        
        //// Path- Drawing
        var pathPath = UIBezierPath()
        pathPath.moveToPoint(CGPointMake(9.71, 20.43))
        pathPath.addLineToPoint(CGPointMake(47.94, 20.4))
        pathPath.miterLimit = 4;
        
        pathPath.usesEvenOddFillRule = true;
        
        color.setStroke()
        pathPath.lineWidth = 3
        pathPath.stroke()
        
        
        
        
        //// Rectangle-490 Drawing
        let rectangle490Path = UIBezierPath(rect: CGRectMake(0, 0, 3, 40))
        color.setFill()
        rectangle490Path.fill()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        CGContextRestoreGState(context)
    }
}