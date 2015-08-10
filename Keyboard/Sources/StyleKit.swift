//
//  StyleKit.swift
//  Often
//
//  Created by Luc Succes on 8/10/15.
//  Copyright (c) 2015 Project Surf Inc. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class StyleKit : NSObject {

    //// Drawing Methods

    public class func drawBackspace(#color: UIColor, keySize: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Frames
        let frame = CGRectMake(keySize.origin.x, keySize.origin.y, keySize.size.width, keySize.size.height)


        //// Icon
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.14286 * frame.width, frame.minY + 0.20000 * frame.height)
        CGContextScaleCTM(context, 0.5, 0.5)

        CGContextSetBlendMode(context, kCGBlendModeMultiply)
        CGContextBeginTransparencyLayer(context, nil)


        //// arrow-icon
        //// head Drawing
        var headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(22.95, 33.31))
        headPath.addLineToPoint(CGPointMake(9.75, 20.28))
        headPath.addLineToPoint(CGPointMake(22.6, 7.97))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        color.setStroke()
        headPath.lineWidth = 3
        headPath.stroke()


        //// tail Drawing
        var tailPath = UIBezierPath()
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

    public class func drawArrowup(#color: UIColor, keySize: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Frames
        let frame = CGRectMake(keySize.origin.x, keySize.origin.y, keySize.size.width, keySize.size.height)


        //// icon
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.48571 * frame.width, frame.minY + 0.49335 * frame.height)
        CGContextScaleCTM(context, 0.5, 0.5)



        //// head Drawing
        var headPath = UIBezierPath()
        headPath.moveToPoint(CGPointMake(-12.67, -5.88))
        headPath.addLineToPoint(CGPointMake(0.36, -19.07))
        headPath.addLineToPoint(CGPointMake(12.67, -6.22))
        headPath.miterLimit = 4;

        headPath.usesEvenOddFillRule = true;

        color.setStroke()
        headPath.lineWidth = 3
        headPath.stroke()


        //// tail Drawing
        var tailPath = UIBezierPath()
        tailPath.moveToPoint(CGPointMake(0.21, -19.11))
        tailPath.addLineToPoint(CGPointMake(0.24, 19.11))
        tailPath.miterLimit = 4;

        tailPath.usesEvenOddFillRule = true;

        color.setStroke()
        tailPath.lineWidth = 3
        tailPath.stroke()



        CGContextRestoreGState(context)
    }

    public class func drawSearch(#frame: CGRect, color: UIColor, scale: CGFloat) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// search
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.57045 * frame.width, frame.minY + 0.58812 * frame.height)
        CGContextScaleCTM(context, scale, scale)



        //// Path-82 Drawing
        var path82Path = UIBezierPath()
        path82Path.moveToPoint(CGPointMake(1.45, 1.32))
        path82Path.addLineToPoint(CGPointMake(8.97, 10.58))
        path82Path.miterLimit = 4;

        path82Path.usesEvenOddFillRule = true;

        color.setStroke()
        path82Path.lineWidth = 3
        path82Path.stroke()


        //// Oval-77 Drawing
        var oval77Path = UIBezierPath(ovalInRect: CGRectMake(-13.97, -15.58, 19, 18))
        color.setStroke()
        oval77Path.lineWidth = 3
        oval77Path.stroke()



        CGContextRestoreGState(context)
    }

    public class func drawArrowheadup(#frame: CGRect, color: UIColor, borderWidth: CGFloat) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// head Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.48860 * frame.width, frame.minY + 0.47676 * frame.height)

        var headPath = UIBezierPath()
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

    public class func drawShare(#frame: CGRect, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// share
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.37612 * frame.width, frame.minY + 0.29439 * frame.height)
        CGContextScaleCTM(context, 0.5, 0.5)



        //// square Drawing
        var squarePath = UIBezierPath()
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
        var linePath = UIBezierPath()
        linePath.moveToPoint(CGPointMake(8.08, 1.15))
        linePath.addLineToPoint(CGPointMake(8.01, 15.97))
        linePath.miterLimit = 4;

        linePath.usesEvenOddFillRule = true;

        color.setStroke()
        linePath.lineWidth = 3
        linePath.stroke()


        //// head Drawing
        var headPath = UIBezierPath()
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

    public class func drawClose(#frame: CGRect, color: UIColor, scale: CGFloat) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// close
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.48651 * frame.width, frame.minY + 0.48646 * frame.height)
        CGContextScaleCTM(context, scale, scale)



        //// rightBar Drawing
        CGContextSaveGState(context)

        var rightBarPath = UIBezierPath()
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

        var leftBarPath = UIBezierPath()
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

    public class func drawUser(#frame: CGRect, color: UIColor) {


        //// Subframes
        let userprofile: CGRect = CGRectMake(frame.minX + floor(frame.width * 0.26769 + 0.47) + 0.03, frame.minY + floor(frame.height * 0.13694 + 0.5), floor(frame.width * 0.73778 + 0.37) - floor(frame.width * 0.26769 + 0.47) + 0.1, floor(frame.height * 0.86667 - 0.39) - floor(frame.height * 0.13694 + 0.5) + 0.89)


        //// user-profile
        //// Oval-17 Drawing
        var oval17Path = UIBezierPath(ovalInRect: CGRectMake(userprofile.minX + floor(userprofile.width * 0.10573 + 0.01) + 0.49, userprofile.minY + floor(userprofile.height * 0.00000 + 0.45) + 0.05, floor(userprofile.width * 0.87493 + 0.16) - floor(userprofile.width * 0.10573 + 0.01) - 0.15, floor(userprofile.height * 0.49506 - 0.39) - floor(userprofile.height * 0.00000 + 0.45) + 0.84))
        color.setFill()
        oval17Path.fill()
        color.setStroke()
        oval17Path.lineWidth = 1
        oval17Path.stroke()


        //// Path-18 Drawing
        var path18Path = UIBezierPath()
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

    public class func drawSettings(#frame: CGRect, color: UIColor) {

        //// wheel Drawing
        var wheelPath = UIBezierPath()
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

    public class func imageOfBackspace(#color: UIColor, keySize: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), false, 0)
            StyleKit.drawBackspace(color: color, keySize: keySize)

        let imageOfBackspace = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfBackspace
    }

    public class func imageOfArrowup(#color: UIColor, keySize: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), false, 0)
            StyleKit.drawArrowup(color: color, keySize: keySize)

        let imageOfArrowup = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfArrowup
    }

    public class func imageOfSearch(#frame: CGRect, color: UIColor, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawSearch(frame: frame, color: color, scale: scale)

        let imageOfSearch = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfSearch
    }

    public class func imageOfArrowheadup(#frame: CGRect, color: UIColor, borderWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawArrowheadup(frame: frame, color: color, borderWidth: borderWidth)

        let imageOfArrowheadup = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfArrowheadup
    }

    public class func imageOfShare(#frame: CGRect, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawShare(frame: frame, color: color)

        let imageOfShare = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfShare
    }

    public class func imageOfClose(#frame: CGRect, color: UIColor, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawClose(frame: frame, color: color, scale: scale)

        let imageOfClose = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfClose
    }

    public class func imageOfUser(#frame: CGRect, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawUser(frame: frame, color: color)

        let imageOfUser = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfUser
    }

    public class func imageOfSettings(#frame: CGRect, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawSettings(frame: frame, color: color)

        let imageOfSettings = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfSettings
    }

}

@objc protocol StyleKitSettableImage {
    func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
    func setSelectedImage(image: UIImage!)
}
