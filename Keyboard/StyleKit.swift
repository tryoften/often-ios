//
//  StyleKit.swift
//  Often
//
//  Created by Luc Succes on 10/1/15.
//  Copyright (c) 2015 Project Surf Inc. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class StyleKit : NSObject {

    //// Drawing Methods

    public class func drawBackspace(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), keySize: CGRect = CGRectMake(0, 0, 35, 35)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Frames
        let frame = CGRectMake(keySize.origin.x, keySize.origin.y, keySize.size.width, keySize.size.height)


        //// Icon
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.14286 * frame.width, frame.minY + 0.20000 * frame.height)
        CGContextScaleCTM(context, 0.5, 0.5)

        CGContextSetBlendMode(context, .Multiply)
        CGContextBeginTransparencyLayer(context, nil)


        //// arrow-icon
        //// head Drawing
        let headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(22.95, 33.31))
        headPath.addLineToPoint(CGPointMake(9.75, 20.28))
        headPath.addLineToPoint(CGPointMake(22.6, 7.97))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        color.setStroke()
        headPath.lineWidth = 3
        headPath.stroke()


        //// tail Drawing
        let tailPath = UIBezierPath()
        tailPath.moveToPoint(CGPointMake(9.71, 20.43))
        tailPath.addLineToPoint(CGPointMake(47.94, 20.4))
        tailPath.miterLimit = 4;

        tailPath.usesEvenOddFillRule = true;

        color.setStroke()
        tailPath.lineWidth = 3
        tailPath.stroke()




        //// Bar Drawing
        let barPath = UIBezierPath(rect: CGRectMake(0, 0, 3, 40))
        color.setFill()
        barPath.fill()


        CGContextEndTransparencyLayer(context)

        CGContextRestoreGState(context)
    }

    public class func drawArrowup(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), keySize: CGRect = CGRectMake(0, 0, 35, 35)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Frames
        let frame = CGRectMake(keySize.origin.x, keySize.origin.y, keySize.size.width, keySize.size.height)


        //// icon
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.48571 * frame.width, frame.minY + 0.49335 * frame.height)
        CGContextScaleCTM(context, 0.5, 0.5)



        //// head Drawing
        let headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(-12.67, -5.88))
        headPath.addLineToPoint(CGPointMake(0.36, -19.07))
        headPath.addLineToPoint(CGPointMake(12.67, -6.22))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        color.setStroke()
        headPath.lineWidth = 3
        headPath.stroke()


        //// tail Drawing
        let tailPath = UIBezierPath()
        tailPath.moveToPoint(CGPointMake(0.21, -19.11))
        tailPath.addLineToPoint(CGPointMake(0.24, 19.11))
        tailPath.miterLimit = 4;

        tailPath.usesEvenOddFillRule = true;

        color.setStroke()
        tailPath.lineWidth = 3
        tailPath.stroke()



        CGContextRestoreGState(context)
    }

    public class func drawSearch(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// search
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.57045 * frame.width, frame.minY + 0.58812 * frame.height)
        CGContextScaleCTM(context, scale, scale)



        //// Path-82 Drawing
        let path82Path = UIBezierPath()
        path82Path.moveToPoint(CGPointMake(1.45, 1.32))
        path82Path.addLineToPoint(CGPointMake(8.97, 10.58))
        path82Path.miterLimit = 4;

        path82Path.usesEvenOddFillRule = true;

        color.setStroke()
        path82Path.lineWidth = 3
        path82Path.stroke()


        //// Oval-77 Drawing
        let oval77Path = UIBezierPath(ovalInRect: CGRectMake(-13.97, -15.58, 19, 18))
        color.setStroke()
        oval77Path.lineWidth = 3
        oval77Path.stroke()



        CGContextRestoreGState(context)
    }

    public class func drawArrowheadup(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), borderWidth: CGFloat = 2) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// head Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.48860 * frame.width, frame.minY + 0.47676 * frame.height)

        let headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(-10.9, 5.31))
        headPath.addLineToPoint(CGPointMake(-0, -5.31))
        headPath.addLineToPoint(CGPointMake(10.9, 5.29))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        color.setStroke()
        headPath.lineWidth = borderWidth
        headPath.stroke()

        CGContextRestoreGState(context)
    }

    public class func drawShare(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// share
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.37612 * frame.width, frame.minY + 0.29439 * frame.height)
        CGContextScaleCTM(context, 0.5, 0.5)



        //// square Drawing
        let squarePath = UIBezierPath()
        squarePath.moveToPoint(CGPointMake(7.79, 15.53))
        squarePath.addLineToPoint(CGPointMake(15.39, 15.45))
        squarePath.addLineToPoint(CGPointMake(15.39, 30.11))
        squarePath.addLineToPoint(CGPointMake(0.73, 30.11))
        squarePath.addLineToPoint(CGPointMake(0.73, 15.45))
        squarePath.addLineToPoint(CGPointMake(7.79, 15.53))
        squarePath.closePath()
        squarePath.miterLimit = 4;

        squarePath.usesEvenOddFillRule = true;

        color.setStroke()
        squarePath.lineWidth = 3
        squarePath.stroke()


        //// line Drawing
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPointMake(8.08, 1.15))
        linePath.addLineToPoint(CGPointMake(8.01, 15.97))
        linePath.miterLimit = 4;

        linePath.usesEvenOddFillRule = true;

        color.setStroke()
        linePath.lineWidth = 3
        linePath.stroke()


        //// head Drawing
        let headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(0, 8.08))
        headPath.addLineToPoint(CGPointMake(7.99, 0))
        headPath.addLineToPoint(CGPointMake(15.98, 8.07))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        color.setStroke()
        headPath.lineWidth = 3
        headPath.stroke()



        CGContextRestoreGState(context)
    }

    public class func drawClose(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// close
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.48651 * frame.width, frame.minY + 0.48646 * frame.height)
        CGContextScaleCTM(context, scale, scale)



        //// rightBar Drawing
        CGContextSaveGState(context)

        let rightBarPath = UIBezierPath()
        rightBarPath.moveToPoint(CGPointMake(15.97, -11.31))
        rightBarPath.addLineToPoint(CGPointMake(11.98, -15.08))
        rightBarPath.addLineToPoint(CGPointMake(-15.97, 11.31))
        rightBarPath.addLineToPoint(CGPointMake(-11.98, 15.08))
        rightBarPath.addLineToPoint(CGPointMake(15.97, -11.31))
        rightBarPath.addLineToPoint(CGPointMake(15.97, -11.31))
        rightBarPath.closePath()
        rightBarPath.miterLimit = 4;

        rightBarPath.usesEvenOddFillRule = true;

        color.setFill()
        rightBarPath.fill()

        CGContextRestoreGState(context)


        //// leftBar Drawing
        CGContextSaveGState(context)

        let leftBarPath = UIBezierPath()
        leftBarPath.moveToPoint(CGPointMake(-15.97, -11.31))
        leftBarPath.addLineToPoint(CGPointMake(-11.98, -15.08))
        leftBarPath.addLineToPoint(CGPointMake(15.97, 11.31))
        leftBarPath.addLineToPoint(CGPointMake(11.98, 15.08))
        leftBarPath.addLineToPoint(CGPointMake(-15.97, -11.31))
        leftBarPath.addLineToPoint(CGPointMake(-15.97, -11.31))
        leftBarPath.closePath()
        leftBarPath.miterLimit = 4;

        leftBarPath.usesEvenOddFillRule = true;

        color.setFill()
        leftBarPath.fill()

        CGContextRestoreGState(context)



        CGContextRestoreGState(context)
    }

    public class func drawButtonclose(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// close 2
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.51429 * frame.width, frame.minY + 0.50159 * frame.height)
        CGContextScaleCTM(context, scale, scale)



        //// Rectangle-406 Drawing
        let rectangle406Path = UIBezierPath()
        rectangle406Path.moveToPoint(CGPointMake(-7.99, -5.66))
        rectangle406Path.addLineToPoint(CGPointMake(-5.99, -7.54))
        rectangle406Path.addLineToPoint(CGPointMake(7.99, 5.66))
        rectangle406Path.addLineToPoint(CGPointMake(5.99, 7.54))
        rectangle406Path.addLineToPoint(CGPointMake(-7.99, -5.66))
        rectangle406Path.addLineToPoint(CGPointMake(-7.99, -5.66))
        rectangle406Path.closePath()
        rectangle406Path.miterLimit = 4;

        rectangle406Path.usesEvenOddFillRule = true;

        color.setFill()
        rectangle406Path.fill()


        //// Rectangle-407 Drawing
        let rectangle407Path = UIBezierPath()
        rectangle407Path.moveToPoint(CGPointMake(7.99, -5.66))
        rectangle407Path.addLineToPoint(CGPointMake(5.99, -7.54))
        rectangle407Path.addLineToPoint(CGPointMake(-7.99, 5.66))
        rectangle407Path.addLineToPoint(CGPointMake(-5.99, 7.54))
        rectangle407Path.addLineToPoint(CGPointMake(7.99, -5.66))
        rectangle407Path.addLineToPoint(CGPointMake(7.99, -5.66))
        rectangle407Path.closePath()
        rectangle407Path.miterLimit = 4;

        rectangle407Path.usesEvenOddFillRule = true;

        color.setFill()
        rectangle407Path.fill()



        CGContextRestoreGState(context)
    }

    public class func drawFavorite(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1, selected: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let highlightedColor = UIColor(red: 0.129, green: 0.808, blue: 0.600, alpha: 1.000)
        let noneColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.000)

        //// Variable Declarations
        let selectedFillColor = selected ? highlightedColor : noneColor
        let selectedHighlightColor = selected ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : color
        let strokeColor = selected ? highlightedColor : color

        //// Frames
        let frame = CGRectMake(0, -0, 50, 50)


        //// icon
        CGContextSaveGState(context)
        CGContextScaleCTM(context, scale, scale)



        //// circle Drawing
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(frame.minX + 11.5, frame.minY + 8, 80.5, 80.5))
        selectedFillColor.setFill()
        circlePath.fill()
        strokeColor.setStroke()
        circlePath.lineWidth = 3
        circlePath.stroke()


        //// star Drawing
        let starPath = UIBezierPath()
        starPath.moveToPoint(CGPointMake(51.75, 59.05))
        starPath.addLineToPoint(CGPointMake(38.82, 68.04))
        starPath.addLineToPoint(CGPointMake(43.38, 52.97))
        starPath.addLineToPoint(CGPointMake(frame.minX + 30.83, frame.minY + 43.45))
        starPath.addLineToPoint(CGPointMake(frame.minX + 46.58, frame.minY + 43.13))
        starPath.addLineToPoint(CGPointMake(51.75, 28.26))
        starPath.addLineToPoint(CGPointMake(56.92, 43.13))
        starPath.addLineToPoint(CGPointMake(72.67, 43.45))
        starPath.addLineToPoint(CGPointMake(60.12, 52.97))
        starPath.addLineToPoint(CGPointMake(64.68, 68.04))
        starPath.addLineToPoint(CGPointMake(51.75, 59.05))
        starPath.closePath()
        starPath.miterLimit = 4;

        starPath.usesEvenOddFillRule = true;

        selectedHighlightColor.setFill()
        starPath.fill()



        CGContextRestoreGState(context)
    }

    public class func drawCancel(frame frame: CGRect = CGRectMake(0, 0, 50, 50), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1, selected: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let highlightedColor = UIColor(red: 0.129, green: 0.808, blue: 0.600, alpha: 1.000)
        let noneColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.000)

        //// Variable Declarations
        let selectedFillColor = selected ? highlightedColor : noneColor
        let selectedHighlightColor = selected ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : color
        let strokeColor = selected ? highlightedColor : color

        //// insert-copy
        CGContextSaveGState(context)
        CGContextScaleCTM(context, scale, scale)



        //// Oval-86 Drawing
        let oval86Path = UIBezierPath(ovalInRect: CGRectMake(8.5, 9.5, 80.5, 80.5))
        selectedFillColor.setFill()
        oval86Path.fill()
        strokeColor.setStroke()
        oval86Path.lineWidth = 3
        oval86Path.stroke()


        //// Rectangle-1487 Drawing
        let rectangle1487Path = UIBezierPath()
        rectangle1487Path.moveToPoint(CGPointMake(34.36, 38.19))
        rectangle1487Path.addLineToPoint(CGPointMake(37.19, 35.36))
        rectangle1487Path.addLineToPoint(CGPointMake(62.64, 60.81))
        rectangle1487Path.addLineToPoint(CGPointMake(59.81, 63.64))
        rectangle1487Path.addLineToPoint(CGPointMake(34.36, 38.19))
        rectangle1487Path.closePath()
        rectangle1487Path.miterLimit = 4;

        rectangle1487Path.usesEvenOddFillRule = true;

        selectedHighlightColor.setFill()
        rectangle1487Path.fill()


        //// Rectangle-1487-Copy Drawing
        let rectangle1487CopyPath = UIBezierPath()
        rectangle1487CopyPath.moveToPoint(CGPointMake(62.64, 38.19))
        rectangle1487CopyPath.addLineToPoint(CGPointMake(59.81, 35.36))
        rectangle1487CopyPath.addLineToPoint(CGPointMake(34.36, 60.81))
        rectangle1487CopyPath.addLineToPoint(CGPointMake(37.19, 63.64))
        rectangle1487CopyPath.addLineToPoint(CGPointMake(62.64, 38.19))
        rectangle1487CopyPath.closePath()
        rectangle1487CopyPath.miterLimit = 4;

        rectangle1487CopyPath.usesEvenOddFillRule = true;

        selectedHighlightColor.setFill()
        rectangle1487CopyPath.fill()



        CGContextRestoreGState(context)
    }

    public class func drawInsert(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1, selected: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let highlightedColor = UIColor(red: 0.129, green: 0.808, blue: 0.600, alpha: 1.000)
        let noneColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.000)

        //// Variable Declarations
        let selectedFillColor = selected ? highlightedColor : noneColor
        let selectedHighlightColor = selected ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : color
        let strokeColor = selected ? highlightedColor : color

        //// Frames
        let frame = CGRectMake(0, 0, 50, 50)


        //// icon
        CGContextSaveGState(context)
        CGContextScaleCTM(context, scale, scale)



        //// Oval-86 Drawing
        let oval86Path = UIBezierPath(ovalInRect: CGRectMake(frame.minX + 8.5, frame.minY + 9, 80.5, 80.5))
        selectedFillColor.setFill()
        oval86Path.fill()
        strokeColor.setStroke()
        oval86Path.lineWidth = 3
        oval86Path.stroke()


        //// Arrow-Copy-2
        //// head Drawing
        let headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(frame.minX + 37.71, frame.minY + 48.38))
        headPath.addLineToPoint(CGPointMake(frame.minX + 48.52, frame.minY + 37.43))
        headPath.addLineToPoint(CGPointMake(frame.minX + 58.73, frame.minY + 48.09))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        selectedHighlightColor.setStroke()
        headPath.lineWidth = 3
        headPath.stroke()


        //// tail Drawing
        let tailPath = UIBezierPath()
        tailPath.moveToPoint(CGPointMake(frame.minX + 48.39, frame.minY + 37.39))
        tailPath.addLineToPoint(CGPointMake(frame.minX + 48.41, frame.minY + 69.11))
        tailPath.miterLimit = 4;

        tailPath.usesEvenOddFillRule = true;

        selectedHighlightColor.setFill()
        tailPath.fill()
        selectedHighlightColor.setStroke()
        tailPath.lineWidth = 3
        tailPath.stroke()




        //// Rectangle-490 Drawing
        let rectangle490Path = UIBezierPath()
        rectangle490Path.moveToPoint(CGPointMake(65.35, 29.33))
        rectangle490Path.addLineToPoint(CGPointMake(65.35, 31.82))
        rectangle490Path.addLineToPoint(CGPointMake(frame.minX + 32.15, frame.minY + 31.82))
        rectangle490Path.addLineToPoint(CGPointMake(frame.minX + 32.15, frame.minY + 29.33))
        rectangle490Path.addLineToPoint(CGPointMake(65.35, 29.33))
        rectangle490Path.closePath()
        rectangle490Path.miterLimit = 4;

        rectangle490Path.usesEvenOddFillRule = true;

        selectedHighlightColor.setFill()
        rectangle490Path.fill()



        CGContextRestoreGState(context)
    }

    public class func drawFavoritedstate(frame frame: CGRect = CGRectMake(0, 0, 62, 62), scale: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let fillColor = UIColor(red: 0.145, green: 0.780, blue: 0.530, alpha: 1.000)
        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// icon
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 62, frame.minY + 62)
        CGContextScaleCTM(context, scale, scale)



        //// triangle Drawing
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(CGPointMake(0, -62))
        trianglePath.addLineToPoint(CGPointMake(-0, -0))
        trianglePath.addLineToPoint(CGPointMake(-62, 0))
        trianglePath.addLineToPoint(CGPointMake(0, -62))
        trianglePath.closePath()
        trianglePath.miterLimit = 4;

        trianglePath.usesEvenOddFillRule = true;

        fillColor.setFill()
        trianglePath.fill()


        //// star Drawing
        let starPath = UIBezierPath()
        starPath.moveToPoint(CGPointMake(-18.75, -30.85))
        starPath.addLineToPoint(CGPointMake(-16.1, -23.19))
        starPath.addLineToPoint(CGPointMake(-8, -23.04))
        starPath.addLineToPoint(CGPointMake(-14.47, -18.16))
        starPath.addLineToPoint(CGPointMake(-12.11, -10.41))
        starPath.addLineToPoint(CGPointMake(-18.75, -15.05))
        starPath.addLineToPoint(CGPointMake(-25.39, -10.41))
        starPath.addLineToPoint(CGPointMake(-23.03, -18.16))
        starPath.addLineToPoint(CGPointMake(-29.5, -23.04))
        starPath.addLineToPoint(CGPointMake(-21.4, -23.19))
        starPath.closePath()
        fillColor2.setFill()
        starPath.fill()



        CGContextRestoreGState(context)
    }

    public class func drawUser(frame frame: CGRect = CGRectMake(5, 6, 30, 30), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)) {


        //// Subframes
        let userprofile: CGRect = CGRectMake(frame.minX + floor(frame.width * 0.26769 + 0.47) + 0.03, frame.minY + floor(frame.height * 0.13694 + 0.5), floor(frame.width * 0.73778 + 0.37) - floor(frame.width * 0.26769 + 0.47) + 0.1, floor(frame.height * 0.86667 - 0.39) - floor(frame.height * 0.13694 + 0.5) + 0.89)


        //// user-profile
        //// Oval-17 Drawing
        let oval17Path = UIBezierPath(ovalInRect: CGRectMake(userprofile.minX + floor(userprofile.width * 0.10573 + 0.01) + 0.49, userprofile.minY + floor(userprofile.height * 0.00000 + 0.45) + 0.05, floor(userprofile.width * 0.87493 + 0.16) - floor(userprofile.width * 0.10573 + 0.01) - 0.15, floor(userprofile.height * 0.49506 - 0.39) - floor(userprofile.height * 0.00000 + 0.45) + 0.84))
        color.setFill()
        oval17Path.fill()
        color.setStroke()
        oval17Path.lineWidth = 1
        oval17Path.stroke()


        //// Path-18 Drawing
        let path18Path = UIBezierPath()
        path18Path.moveToPoint(CGPointMake(userprofile.minX + 0.50000 * userprofile.width, userprofile.minY + 1.00000 * userprofile.height))
        path18Path.addCurveToPoint(CGPointMake(userprofile.minX + 0.00000 * userprofile.width, userprofile.minY + 0.90612 * userprofile.height), controlPoint1: CGPointMake(userprofile.minX + 0.16067 * userprofile.width, userprofile.minY + 1.00000 * userprofile.height), controlPoint2: CGPointMake(userprofile.minX + 0.00000 * userprofile.width, userprofile.minY + 0.90612 * userprofile.height))
        path18Path.addCurveToPoint(CGPointMake(userprofile.minX + 0.50000 * userprofile.width, userprofile.minY + 0.62945 * userprofile.height), controlPoint1: CGPointMake(userprofile.minX + 0.00000 * userprofile.width, userprofile.minY + 0.90612 * userprofile.height), controlPoint2: CGPointMake(userprofile.minX + 0.06114 * userprofile.width, userprofile.minY + 0.62945 * userprofile.height))
        path18Path.addCurveToPoint(CGPointMake(userprofile.minX + 1.00000 * userprofile.width, userprofile.minY + 0.90612 * userprofile.height), controlPoint1: CGPointMake(userprofile.minX + 0.93886 * userprofile.width, userprofile.minY + 0.62945 * userprofile.height), controlPoint2: CGPointMake(userprofile.minX + 1.00000 * userprofile.width, userprofile.minY + 0.90612 * userprofile.height))
        path18Path.addCurveToPoint(CGPointMake(userprofile.minX + 0.50000 * userprofile.width, userprofile.minY + 1.00000 * userprofile.height), controlPoint1: CGPointMake(userprofile.minX + 1.00000 * userprofile.width, userprofile.minY + 0.90612 * userprofile.height), controlPoint2: CGPointMake(userprofile.minX + 0.83933 * userprofile.width, userprofile.minY + 1.00000 * userprofile.height))
        path18Path.closePath()
        path18Path.miterLimit = 4;

        path18Path.usesEvenOddFillRule = true;

        color.setFill()
        path18Path.fill()
        color.setStroke()
        path18Path.lineWidth = 1
        path18Path.stroke()
    }

    public class func drawSettings(frame frame: CGRect = CGRectMake(0, 0, 40, 40), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)) {

        //// wheel Drawing
        let wheelPath = UIBezierPath()
        wheelPath.moveToPoint(CGPointMake(frame.minX + 0.37849 * frame.width, frame.minY + 0.78999 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.92500 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.62056 * frame.width, frame.minY + 0.79105 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.80052 * frame.width, frame.minY + 0.80052 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.79097 * frame.width, frame.minY + 0.61913 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.92500 * frame.width, frame.minY + 0.50000 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.78991 * frame.width, frame.minY + 0.37992 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.80052 * frame.width, frame.minY + 0.19948 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.62151 * frame.width, frame.minY + 0.21001 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.07500 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.37944 * frame.width, frame.minY + 0.20895 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.19948 * frame.width, frame.minY + 0.19948 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.20903 * frame.width, frame.minY + 0.38087 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.07500 * frame.width, frame.minY + 0.50000 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.21009 * frame.width, frame.minY + 0.62008 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.19948 * frame.width, frame.minY + 0.80052 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.37849 * frame.width, frame.minY + 0.78999 * frame.height))
        wheelPath.addLineToPoint(CGPointMake(frame.minX + 0.37849 * frame.width, frame.minY + 0.78999 * frame.height))
        wheelPath.closePath()
        wheelPath.moveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.62750 * frame.height))
        wheelPath.addCurveToPoint(CGPointMake(frame.minX + 0.62750 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.57042 * frame.width, frame.minY + 0.62750 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.62750 * frame.width, frame.minY + 0.57042 * frame.height))
        wheelPath.addCurveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.37250 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.62750 * frame.width, frame.minY + 0.42958 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.57042 * frame.width, frame.minY + 0.37250 * frame.height))
        wheelPath.addCurveToPoint(CGPointMake(frame.minX + 0.37250 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.42958 * frame.width, frame.minY + 0.37250 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.37250 * frame.width, frame.minY + 0.42958 * frame.height))
        wheelPath.addCurveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.62750 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.37250 * frame.width, frame.minY + 0.57042 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.42958 * frame.width, frame.minY + 0.62750 * frame.height))
        wheelPath.closePath()
        wheelPath.miterLimit = 4;

        wheelPath.usesEvenOddFillRule = true;

        color.setFill()
        wheelPath.fill()
    }

    //// Generated Images

    public class func imageOfBackspace(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), keySize: CGRect = CGRectMake(0, 0, 35, 35)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), false, 0)
            StyleKit.drawBackspace(color: color, keySize: keySize)

        let imageOfBackspace = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfBackspace
    }

    public class func imageOfArrowup(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), keySize: CGRect = CGRectMake(0, 0, 35, 35)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), false, 0)
            StyleKit.drawArrowup(color: color, keySize: keySize)

        let imageOfArrowup = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfArrowup
    }

    public class func imageOfSearch(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawSearch(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color, scale: scale)

        let imageOfSearch = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfSearch
    }

    public class func imageOfArrowheadup(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), borderWidth: CGFloat = 2) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawArrowheadup(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color, borderWidth: borderWidth)

        let imageOfArrowheadup = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfArrowheadup
    }

    public class func imageOfShare(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawShare(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color)

        let imageOfShare = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfShare
    }

    public class func imageOfClose(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawClose(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color, scale: scale)

        let imageOfClose = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfClose
    }

    public class func imageOfButtonclose(frame frame: CGRect = CGRectMake(0, 0, 35, 35), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawButtonclose(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color, scale: scale)

        let imageOfButtonclose = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfButtonclose
    }

    public class func imageOfFavorite(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1, selected: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), false, 0)
            StyleKit.drawFavorite(color: color, scale: scale, selected: selected)

        let imageOfFavorite = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfFavorite
    }

    public class func imageOfCancel(frame frame: CGRect = CGRectMake(0, 0, 50, 50), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1, selected: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawCancel(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color, scale: scale, selected: selected)

        let imageOfCancel = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfCancel
    }

    public class func imageOfInsert(color color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 1, selected: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), false, 0)
            StyleKit.drawInsert(color: color, scale: scale, selected: selected)

        let imageOfInsert = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfInsert
    }

    public class func imageOfFavoritedstate(frame frame: CGRect = CGRectMake(0, 0, 62, 62), scale: CGFloat = 1) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawFavoritedstate(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), scale: scale)

        let imageOfFavoritedstate = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfFavoritedstate
    }

    public class func imageOfUser(frame frame: CGRect = CGRectMake(5, 6, 30, 30), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawUser(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color)

        let imageOfUser = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfUser
    }

    public class func imageOfSettings(frame frame: CGRect = CGRectMake(0, 0, 40, 40), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawSettings(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), color: color)

        let imageOfSettings = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfSettings
    }

}
