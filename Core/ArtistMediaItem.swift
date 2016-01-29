//
//  ArtistMediaItem.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class ArtistMediaItem: MediaItem {
    var external_url: String?
    var featuredImage: String?
    var genius_id: Int?
    var is_verified: String?
    var lyrics_count: Int?
    var name: String?
    var time_modified: Int?
    var tracks_count: Int?
    var tracks: [TrackMediaItem] = []

    required init(data: NSDictionary) {
        super.init(data: data)

        if let image = data["feature_image_url"] as? String {
            self.featuredImage = image
        }

        if let image = data["image_url"] as? String {
            self.image = image
        }

        if let images = data["images"] as? NSDictionary,
            let image_url_images = images["image_url"] as? NSDictionary,
            let square = image_url_images["square"] as? NSDictionary,
            let original = image_url_images["original"] as? NSDictionary,
            let image_url = square["url"] as? String,
            let original_image_url = original["url"] as? String {
            #if KEYBOARD
                self.image = image_url
            #else
                if let large = image_url_images["large"] as? NSDictionary,
                    let large_image_url = large["url"] as? String {
                        self.image = large_image_url

                } else {
                    self.image = original_image_url
                }

            #endif
        }

        if let name = data["name"] as? String {
            self.name = name
        }

        if let tracksCount = data["tracks_count"] as? Int {
            self.tracks_count = tracksCount
        }

        if let lyricsCount = data["lyrics_count"] as? Int {
            self.lyrics_count = lyricsCount
        }

        if let genius_id = data["genius_id"] as? Int {
            self.genius_id = genius_id
        }

        if let external_url = data["external_url"] as? String {
            self.external_url = external_url
        }

        if let time_modified = data["time_modified"] as? Int {
            self.time_modified = time_modified
        }

        if let tracks = data["tracks"] as? NSDictionary,
            let trackModels = TrackMediaItem.modelsFromDictionaryArray(tracks.allValues) as? [TrackMediaItem] {
                self.tracks = trackModels
        }
    }

    override func subCollectionType() -> MediaItemsCollectionType? {
        return .Tracks
    }
}