//
//  TrackMediaItem.swift
//  Often
//
//  Created by Luc Succes on 10/1/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class TrackMediaItem: MediaItem {
    var name: String = ""
    var title: String = ""
    var album_name: String = ""
    var url: String = ""
    var lyrics: [LyricMediaItem] = []
    var plays: Int?

    var artist_external_url: String?
    var artist_genius_id: Int?
    var artist_id: String?
    var artist_image_url: String?
    var artist_is_verified: String?
    var artist_name: String?
    var external_url: String?
    var genius_id: Int?
    var header_image_url: String?
    var hot: String?
    var lyrics_count: Int?
    var song_art_image_url: String?
    var time_modified: Int?
    var formattedCreatedDate: String {
        if let created = created {
            return created.timeAgoSinceNow()
        }
        return ""
    }

    required init(data: NSDictionary) {
        super.init(data: data)
        
        self.type = .Track
        
        if let name = data["name"] as? String {
            self.name = name
        }

        if let title = data["title"] as? String {
            self.title = title
        }
        
        if let url = data["uri"] as? String {
            self.url = url
        }
        
        if let url = data["url"] as? String {
            self.url = url
        }
        
        if let url = data["external_url"] as? String {
            self.url = url
        }
        
        if let image = data["album_cover_art_url"] as? String {
            self.smallImage = image
            self.mediumImage = image
            self.largeImage = image
        }

        if let albumName = data["album_name"] as? String {
            self.album_name = albumName
        }
        
        if let artistName = data["artist_name"] as? String {
            self.artist_name = artistName
        }
        
        if let user = data["user"] as? [String: AnyObject],
            let username = user["username"] as? String {
                self.artist_name = username
        }
        
        if let plays = data["plays"] as? Int {
            self.plays = plays
        }
        
        if let created = data["created"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss ZZZZ"
            self.created = dateFormatter.dateFromString(created)
        }

        if let lyrics = data["lyrics"] as? NSDictionary,
            let lyricModels = LyricMediaItem.modelsFromDictionaryArray(lyrics.allValues) as? [LyricMediaItem] {
                self.lyrics = lyricModels.sort { $0.index < $1.index }
        }

        if let artist_name = data["artist_name"] as? String {
            self.artist_name = artist_name
        }

        if let artist_external_url = data["artist_external_url"] as? String {
            self.artist_external_url = artist_external_url
        }

        if let artist_genius_id = data["artist_genius_id"] as? Int {
            self.artist_genius_id = artist_genius_id
        }

        if let artist_id = data["artist_id"] as? String {
            self.artist_id = artist_id
        }

        if let artist_image_url = data["artist_image_url"] as? String {
            self.artist_image_url = artist_image_url
        }

        if let artist_is_verified = data["artist_is_verified"] as? String {
            self.artist_is_verified = artist_is_verified
        }

        if let external_url = data["external_url"] as? String {
            self.external_url = external_url
        }

        if let genius_id = data["genius_id"] as? Int {
            self.genius_id = genius_id
        }

        if let header_image_url = data["header_image_url"] as? String {
            self.header_image_url = header_image_url
        }

        if let lyrics_count = data["lyrics_count"] as? Int {
            self.lyrics_count = lyrics_count
        }

        if let song_art_image_url = data["song_art_image_url"] as? String {
            self.song_art_image_url = song_art_image_url
        }

        if let time_modified = data["time_modified"] as? Int {
            self.time_modified = time_modified
        }
    }
    
    func formattedPlays() -> String {
        if let plays = plays {
            let formattedNum = NSNumber(integer: plays).descriptionWithLocale(NSLocale.currentLocale())
            return "\(formattedNum) Plays"
        }
        return "No Plays"
    }
    
    override func getInsertableText() -> String {
        return "\(name) by \(artist_name) - \(url)"
    }

    override func subCollectionType() -> MediaItemsCollectionType? {
        return .Lyrics
    }
}
