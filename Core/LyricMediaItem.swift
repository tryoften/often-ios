//
//  LyricMediaItem.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class LyricMediaItem: MediaItem {
    var text: String = ""
    var artist_id: String?
    var artist_image_url: String?
    var artist_name: String?
    var genius_id: Int?
    var track_id: String?
    var track_title: String?
    var index: Int = 0

    override var imageProperty: String {
        return "artist_image_url"
    }

    required init(data: NSDictionary) {
        if let text = data["text"] as? String {
            self.text = text
        }

        super.init(data: data)

        artist_id = data["artist_id"] as? String
        artist_image_url = data["artist_image_url"] as? String
        artist_name = data["artist_name"] as? String
        genius_id = data["genius_id"] as? Int
        track_id = data["track_id"] as? String
        track_title = data["track_title"] as? String
        
        if let index = data["index"] as? Int {
            self.index = index
        }

        if let categoryData = data["category"] as? NSDictionary,
            let categoryId = categoryData["id"] as? String,
            let categoryName = categoryData["name"] as? String {
                category = Category(id: categoryId, name: categoryName)
        }
    }

    override func getInsertableText() -> String {
        return text
    }
}