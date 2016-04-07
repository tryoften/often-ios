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
    var items_count: Int = 0
    var items: [LyricMediaItem] = []
    var premium: Bool = false
    var price: Double = 0.0
    
    required init(data: NSDictionary) {
        super.init(data: data)
        
        if let description = data["description"] as? String {
            self.description = description
        }
        
        if let id = data["id"] as? String {
            self.pack_id = id
        }

        if let name = data["name"] as? String {
            self.name = name
        }

        if let images = data["image"] as? NSDictionary,
            let small = images["small_url"] as? String {
            self.smallImageURL = NSURL(string: small)
        }

        if let images = data["image"] as? NSDictionary,
            let large = images["large_url"] as? String {
            self.largeImageURL = NSURL(string: large)
        }
        
        if let items = data["items"] as? NSArray,
            let itemsModel = LyricMediaItem.modelsFromDictionaryArray(items) as? [LyricMediaItem] {
            self.items = itemsModel
        }

        if let itemsCount = data["items_count"] as? Int {
            self.items_count = itemsCount
        } else {
            self.items_count = self.items.count
        }

        if let premium = data["premium"] as? Bool {
            self.premium = premium
        }
        
        if let price = data["price"] as? Double {
            self.price = price
        }
    }

    func callToActionText() -> String {
        if premium {
            if price == 0.0 {
                return "Free"
            }

            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            return formatter.stringFromNumber(NSNumber(double: price))!
        }
        
        return "Download"
    }
}

