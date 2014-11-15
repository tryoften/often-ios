//
//  Category.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        
        super.init()
    }
}
