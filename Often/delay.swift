//
//  delay.swift
//  Often
//
//  Created by Often on 10/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

func delay(_ delay: Double, closure:()->()) {
    DispatchQueue.main.after(
        when: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
