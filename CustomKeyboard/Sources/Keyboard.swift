//
//  Keyboard.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class Keyboard: NSObject {
    var id: String = ""
    var artist: Artist?
    
    var categories: [String: Category] = [String: Category]() {
        didSet {
            var array = [Category]()
            
            for (key, category) in categories {
                array.append(category)
            }
            
            categoryList = array
        }
    }
    var categoryList: [Category] = []
}
