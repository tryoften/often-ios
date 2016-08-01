//
//  ImageMediaItem.swift
//  Often
//
//  Created by Komran Ghahremani on 7/27/16.
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
        
        if let imageData = data["transforms"] as? [String : AnyObject], smallImage = imageData["small"] as? [String : AnyObject], url = smallImage["url"] as? String {
            smallImageURL = NSURL(string: url)
        }
        
        if let imageData = data["transforms"] as? [String : AnyObject], mediumImage = imageData["medium"] as? [String : AnyObject], url = mediumImage["url"] as? String {
            mediumImageURL = NSURL(string: url)
        }
        
        if let imageData = data["transforms"] as? [String : AnyObject], largeImage = imageData["large"] as? [String : AnyObject], url = largeImage["url"] as? String {
            largeImageURL = NSURL(string: url)
        }
    }
}
