//
//  BackspaceShape.swift
//  Often
//
//  Created by Luc Succes on 8/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class BackspaceShape: Shape {    
    override func drawRect(rect: CGRect) {
        StyleKit.drawBackspace(color: color!, keySize: bounds)
    }
}