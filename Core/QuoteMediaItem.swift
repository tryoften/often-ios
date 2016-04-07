//
//  QuoteMediaItem.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class QuoteMediaItem: MediaItem {
    var text: String = ""
    var owner_id: String?
    var owner_image_url: String?
    var owner_name: String?
    var origin_name: String?

    required init(data: NSDictionary) {
        if let text = data["text"] as? String {
            self.text = text
        }

        super.init(data: data)

        owner_id = data["owner_id"] as? String
        owner_image_url = data["owner_image_url"] as? String
        owner_name = data["owner_name"] as? String

        if let categoryData = data["category"] as? NSDictionary,
            let categoryId = categoryData["id"] as? String,
            let categoryName = categoryData["name"] as? String {
            category = Category(id: categoryId, name: categoryName)
        }
    }


}