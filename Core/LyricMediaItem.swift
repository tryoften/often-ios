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
    var artist_external_url: String?
    var artist_genius_id: Int?
    var artist_id: String?
    var artist_image_url: String?
    var artist_is_verified: String?
    var artist_name: String?
    var external_url: String?
    var genius_id: Int?
    var track_external_url: String?
    var track_genius_id: Int?
    var track_header_image_url: String?
    var track_hot: String?
    var track_id: String?
    var track_song_art_image_url: String?
    var track_title: String?

    required init(data: NSDictionary) {
        if let text = data["text"] as? String {
            self.text = text
        }

        super.init(data: data)

        artist_external_url = data["artist_external_url"] as? String
        artist_genius_id = data["artist_genius_id"] as? Int
        artist_id = data["artist_id"] as? String
        artist_image_url = data["artist_image_url"] as? String
        artist_is_verified = data["artist_is_verified"] as? String
        artist_name = data["artist_name"] as? String
        external_url = data["external_url"] as? String
        genius_id = data["genius_id"] as? Int
        track_external_url = data["track_external_url"] as? String
        track_genius_id = data["track_genius_id"] as? Int
        track_header_image_url = data["track_header_image_url"] as? String
        track_hot = data["track_hot"] as? String
        track_id = data["track_id"] as? String
        track_song_art_image_url = data["track_song_art_image_url"] as? String
        track_title = data["track_title"] as? String

        if let imageURL = artist_image_url {
            image = imageURL
        }
    }

    override func getInsertableText() -> String {
        return text
    }
}