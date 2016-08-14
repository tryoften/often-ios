//
//  UIColor+Often.swift
//
//  Generated by Zeplin on 3/1/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

import UIKit

extension UIColor {
    class func oftBlackColor() -> UIColor {
        return UIColor(white: 32.0 / 255.0, alpha: 1.0)
    }

    class func oftGreenblueColor() -> UIColor {
        return UIColor(red: 33.0 / 255.0, green: 206.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }

    class func oftVividPurpleColor() -> UIColor {
        return UIColor(red: 144.0 / 255.0, green: 19.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }

    class func oftDarkGrey74Color() -> UIColor {
        return UIColor(red: 18.0 / 255.0, green: 19.0 / 255.0, blue: 20.0 / 255.0, alpha: 0.74)
    }

    class func oftBlack74Color() -> UIColor {
        return UIColor(white: 0.0, alpha: 0.74)
    }

    class func oftSoftBlueColor() -> UIColor {
        return UIColor(red: 98.0 / 255.0, green: 169.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
    }

    class func oftDenimBlueColor() -> UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }

    class func oftBrightLavenderColor() -> UIColor {
        return UIColor(red: 159.0 / 255.0, green: 74.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    class func oftBlack90Color() -> UIColor {
        return UIColor(white: 0.0, alpha: 0.9)
    }

    class func oftWhiteColor() -> UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }

    class func oftWhiteTwoColor() -> UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }

    class func oftBlack54Color() -> UIColor {
        return UIColor(white: 0.0, alpha: 0.54)
    }

    class func oftWhiteFourColor() -> UIColor {
        return UIColor(white: 239.0 / 255.0, alpha: 1.0)
    }
    
    class func oftWhiteThreeColor() -> UIColor {
        return UIColor(white: 247.0 / 255.0, alpha: 1.0)
    }
    
    class func oftWhiteFiveColor() -> UIColor {
        return UIColor(white: 227.0 / 255.0, alpha: 1.0)
    }
    
    class func oftVeryLightPinkColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 242.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
    }
    
    class func oftLightPinkColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 232.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    var hexString: String {
        let components = CGColorGetComponents(self.CGColor)

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}