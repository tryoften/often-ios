//
//  Category.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

struct Category: Equatable {
    let id: String
    let name: String
}

func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
}