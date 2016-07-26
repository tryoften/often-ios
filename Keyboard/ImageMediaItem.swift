//
//  ImageMediaItem.swift
//  Often
//
//  Created by Komran Ghahremani on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class ImageMediaItem: MediaItem {
    var owner_id: String?
    var owner_name: String?
    var description: String?
    var tags: String?
    
    required init(data: NSDictionary) {
        
        super.init(data: data)
        
        owner_id = data["owner_id"] as? String
        owner_name = data["owner_name"] as? String
        description = data["description"] as? String
        tags = data["tags"] as? String
        
        if let imageData = data["transforms"] as? NSDictionary, smallImage = imageData["square_small"] as? NSDictionary, imageUrl = smallImage["url"] as? String {
            smallImageURL = NSURL(string: imageUrl)
        }
        
        if let imageData = data["transforms"] as? NSDictionary, mediumImage = imageData["square_medium"] as? NSDictionary, imageUrl = mediumImage["url"] as? String {
            mediumImageURL = NSURL(string: imageUrl)
        }
        
        if let imageData = data["transforms"] as? NSDictionary, largeImage = imageData["square"] as? NSDictionary, imageUrl = largeImage["url"] as? String {
            largeImageURL = NSURL(string: imageUrl)
        }
    }
}
