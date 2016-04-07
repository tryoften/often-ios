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
    var name: String?
    var items_count: Int?
    var items: [MediaItem] = []
    var premium: Bool?
    var price: Double?
    var categories: [Category] = []
    
    required init(data: NSDictionary) {
        super.init(data: data)
        
        if let description = data["description"] as? String {
            self.description = description
        }
        
        if let id = data["id"] as? String {
            self.pack_id = id
        }
        
        if let image = data["image"] as? NSDictionary,
            let smallImage = image["small_url"] as? String,
            let largeImage = image["large_url"] as? String {
            self.smallImageURL = NSURL(string: smallImage)
            self.largeImageURL = NSURL(string: largeImage)
        }
        
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let itemsCount = data["items_count"] as? Int {
            self.items_count = itemsCount
        }

        if let images = data["image"] as? NSDictionary,
            let small = images["small_url"] as? String {
            self.smallImageURL = NSURL(string: small)
        }

        if let images = data["image"] as? NSDictionary,
            let large = images["large_url"] as? String  {
            self.largeImageURL = NSURL(string: large)
        }
        
        if let items = data["items"] as? NSArray,
            let itemsModel = MediaItem.modelsFromDictionaryArray(items) as? [MediaItem] {
            self.items = itemsModel
        }

        if let items = data["categories"] as? NSDictionary {
            self.categories = Category.modelsFromDictionary(items)
        }

        if let premium = data["premium"] as? Bool {
            self.premium = premium
        }
        
        if let price = data["price"] as? Double {
            self.price = price
        }
    }
}

