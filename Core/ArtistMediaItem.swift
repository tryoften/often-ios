//
//  ArtistMediaItem.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class ArtistMediaItem: MediaItem {
    var name: String = ""
    var tracksCount: Int?
    var lyricsCount: Int?

    required init(data: NSDictionary) {
        super.init(data: data)

        if let image = data["image_url"] as? String {
            self.image = image
        }

        if let name = data["name"] as? String {
            self.name = name
        }

        if let tracksCount = data["tracks_count"] as? Int {
            self.tracksCount = tracksCount
        }

        if let lyricsCount = data["lyrics_count"] as? Int {
            self.lyricsCount = lyricsCount
        }
    }
}