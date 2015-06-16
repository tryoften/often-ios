//
//  Track.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/6/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import RealmSwift

enum ShareOption : Printable {
    case Spotify
    case Soundcloud
    case YouTube
    case RapGenius
    case Lyric
    case Unknown
    
    var description : String {
        switch self {
        case .Spotify: return "spotify"
        case .Soundcloud: return "soundcloud"
        case .YouTube: return "youtube"
        case .RapGenius: return "genius"
        case .Lyric: return "lyric"
        case .Unknown: return "unknown"
        }
    }
}

class Track: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var artistName: String = ""
    dynamic var artistId: String = ""
    dynamic var albumCoverImage: String? = ""
    dynamic var albumCoverImageLarge: String? = ""
    dynamic var owner: Owner?
    dynamic var spotifyURL: String? = ""
    dynamic var soundcloudURL: String? = ""
    dynamic var rapgeniusURL: String? = ""
    dynamic var youtubeURL: String? = ""
    dynamic var previewURL: String? = ""
    var lyricCount: Int = 200
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {

            name = (dictionary["name"] ?? dictionary["track_name"]) as! String
            artistName = dictionary["artist_name"] as! String
            artistId = (dictionary["artist_id"] ?? dictionary["artist_sp_id"]) as! String
            
            if let albumCoverImageString = dictionary["album_cover_image_small"] as? String {
                albumCoverImage = albumCoverImageString
            }
            
            if let albumCoverImageLargeString = dictionary["album_cover_image_large"] as? String {
                albumCoverImageLarge = albumCoverImageLargeString
            }
            
            if let spotifyURLString = dictionary["track_spotify_url"] as? String {
                spotifyURL = spotifyURLString
            }
            
            if let soundcloudURLString = dictionary["track_soundcloud_url"] as? String {
                soundcloudURL = soundcloudURLString
            }
            
            if let rapgeniusURLString = dictionary["track_rapgenius_url"] as? String {
                rapgeniusURL = rapgeniusURLString
            }
            
            if let youtubeURLString = dictionary["track_youtube_url"] as? String {
                youtubeURL = youtubeURLString
            }
            
            if let previewURLString = dictionary["track_preview_url"] as? String {
                previewURL = previewURLString
            }
        }
    }

    func getShareOptions() -> [ShareOption : NSURL] {
        var options = [ShareOption : NSURL]()
        
        if let spotifyURL = spotifyURL {
            options[.Spotify] = NSURL(string: spotifyURL)
        }
        
        if let soundcloudURL = soundcloudURL {
            options[.Soundcloud] = NSURL(string: soundcloudURL)
        }
        
        if let youtubeURL = youtubeURL {
            options[.YouTube] = NSURL(string: youtubeURL)
        }
        
        return options
    }
}
