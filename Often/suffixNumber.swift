//
//  suffixNumber.swift
//  Often
//
//  Created by Luc Succes on 10/3/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

extension Double {
    
    var suffixNumber: String {
        var num = self
        let sign = (num < 0) ? "-" : ""
        
        num = fabs(num)
        
        if num < 1000.0 {
            return "\(sign)\(num)"
        }
        
        let exp = Int(log10(num) / log10(1000))
        let units = ["K","M","G","T","P","E"]
        
        let roundedNum: Double = round(10 * num / pow(1000.0, Double(exp))) / 10
        
        return "\(sign)\(roundedNum)\(units[exp-1])"
    }
}