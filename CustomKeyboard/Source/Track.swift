//
//  Track.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/6/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

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

class Track: NSObject {
    var id: String
    var name: String
    var albumCoverImage: NSURL?
    var albumCoverImageLarge: NSURL?
    var artistName: String
    var artistId: String
    var spotifyURL: NSURL?
    var soundcloudURL: NSURL?
    var rapgeniusURL: NSURL?
    var youtubeURL: NSURL?
    var previewURL: NSURL?
    
    private var dict: [String: String]
    
    init(dictionary: [String: String]) {
        self.dict = dictionary
        id = dictionary["id"]!
        name = (dictionary["name"] ?? dictionary["track_name"])!
        albumCoverImage = NSURL(string: dictionary["album_cover_image_small"]!)
        albumCoverImageLarge = NSURL(string: dictionary["album_cover_image_large"]!)
        artistName = dictionary["artist_name"]!
        artistId = (dictionary["artist_id"] ?? dictionary["artist_sp_id"])!
        
        if let albumCoverImageLargeString = dictionary["album_cover_image_large"] {
            albumCoverImageLarge = NSURL(string: albumCoverImageLargeString)
        }
        
        if let spotifyURLString = dictionary["track_spotify_url"] {
            spotifyURL = NSURL(string: spotifyURLString)
        }
        
        if let soundcloudURLString = dictionary["track_soundcloud_url"] {
            soundcloudURL = NSURL(string: soundcloudURLString)
        }
        
        if let rapgeniusURLString = dictionary["track_rapgenius_url"] {
            rapgeniusURL = NSURL(string: rapgeniusURLString)
        }
        
        if let youtubeURLString = dictionary["track_youtube_url"] {
            youtubeURL = NSURL(string: youtubeURLString)
        }
        
        if let previewURLString = dictionary["track_preview_url"] {
            previewURL = NSURL(string: previewURLString)
        }
    }
    
    func toDictionary() -> [String: String] {
        return dict
    }
    
    func getShareOptions() -> [ShareOption : NSURL] {
        var options = [ShareOption : NSURL]()
        
        if spotifyURL != nil {
            options[.Spotify] = spotifyURL
        }
        
        if soundcloudURL != nil {
            options[.Soundcloud] = soundcloudURL
        }
        
        if youtubeURL != nil {
            options[.YouTube] = youtubeURL
        }
        
        return options
    }
}
