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
    var smallImageURL: NSURL?
    var largeImageURL: NSURL?
    static var all = Category(id: "all", name: "All", smallImageURL: nil, largeImageURL: nil)

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
                var category = Category(id: id, name: name, smallImageURL: nil, largeImageURL: nil)

                if let imageData = itemData["image"] as? NSDictionary, smallImage = imageData["small_url"] as? String {
                    category.smallImageURL = NSURL(string: smallImage)
                }

                if let imageData = itemData["image"] as? NSDictionary, largeImage = imageData["large_url"] as? String {
                    category.largeImageURL = NSURL(string: largeImage)
                }


                models.append(category)
            }
        }

        return models
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
}