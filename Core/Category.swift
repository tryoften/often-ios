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

    static var all = Category(id: "all", name: "All")

    func toDictionary() -> [String: AnyObject] {
        return [
            "id": id,
            "name": name
        ]
    }

    static func modelsFromDictionary(dictionary: NSDictionary) -> [Category] {
        var models: [Category] = []
        for (_, categoryData) in dictionary  {
            if let itemData = categoryData as? NSDictionary,
                id = itemData["id"] as? String, name = itemData["name"] as? String {
                let category = Category(id: id, name: name)
                models.append(category)
            }
        }
        
        return models
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
}