//
//  GifMediaItem.swift
//  Often
//
//  Created by Katelyn Findlay on 4/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class GifMediaItem: MediaItem {
    var owner_id: String?
    var owner_name: String?
    var description: String?
    var tags: String?
    var giphy_id: String?
    
    
    required init(data: NSDictionary) {
        
        super.init(data: data)
        
        owner_id = data["owner_id"] as? String
        owner_name = data["owner_name"] as? String
        description = data["description"] as? String
        tags = data["tags"] as? String
        giphy_id = data["tags"] as? String
        
        if let imageData = data["image"] as? NSDictionary, smallImage = imageData["small_url"] as? String {
            smallImageURL = NSURL(string: smallImage)
        }
        
        if let imageData = data["image"] as? NSDictionary, smallImage = imageData["medium_url"] as? String {
            mediumImageURL = NSURL(string: smallImage)
        }
        
        if let imageData = data["image"] as? NSDictionary, largeImage = imageData["large_url"] as? String {
            largeImageURL = NSURL(string: largeImage)
        }
    }
    
}