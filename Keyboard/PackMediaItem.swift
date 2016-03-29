//
//  PackMediaItem.swift
//  Often
//
//  Created by Katelyn Findlay on 3/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackMediaItem: MediaItem {
    var description: String?
    var pack_id: String?
    var image_url: String?
    var name: String?
    var items_count: Int?
    var items: [LyricMediaItem] = []
    var premium: Bool?
    var price: Int?
    
    required init(data: NSDictionary) {
        super.init(data: data)
        
        if let description = data["description"] as? String {
            self.description = description
        }
        
        if let id = data["id"] as? String {
            self.pack_id = id
        }
        
        if let image = data["image_url"] as? String {
            self.image_url = image
        }
        
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let itemsCount = data["items_count"] as? Int {
            self.items_count = itemsCount
        }
        
        if let items = data["items"] as? NSArray,
            let itemsModel = LyricMediaItem.modelsFromDictionaryArray(items) as? [LyricMediaItem] {
            self.items = itemsModel
        }
        
        if let premium = data["premium"] as? Bool {
            self.premium = premium
        }
        
        if let price = data["price"] as? Int {
            self.price = price
        }
    }
}

