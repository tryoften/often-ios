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
    var lyricCount: Int
    
    private var dict: [String: AnyObject]
    
    init(dictionary: [String: AnyObject]) {
        
        self.dict = dictionary
        
        if let id: AnyObject = dictionary["id"] {
            self.id = id as! String
        } else {
            fatalError("Cannot create track object without proper ID")
        }
        name = (dictionary["name"] ?? dictionary["track_name"])! as! String
        albumCoverImage = NSURL(string: dictionary["album_cover_image_small"] as! String)
        albumCoverImageLarge = NSURL(string: dictionary["album_cover_image_large"] as! String)
        artistName = dictionary["artist_name"] as! String
        artistId = (dictionary["artist_id"] ?? dictionary["artist_sp_id"]) as! String
        lyricCount = dictionary["lyrics_count"] as! Int
        //println(lyricCount)
        
        if let albumCoverImageLargeString: AnyObject = dictionary["album_cover_image_large"] {
            albumCoverImageLarge = NSURL(string: albumCoverImageLargeString as! String)
        }
        
        if let spotifyURLString: AnyObject = dictionary["track_spotify_url"] {
            spotifyURL = NSURL(string: spotifyURLString as! String)
        }
        
        if let soundcloudURLString: AnyObject = dictionary["track_soundcloud_url"] {
            soundcloudURL = NSURL(string: soundcloudURLString as! String)
        }
        
        if let rapgeniusURLString: AnyObject = dictionary["track_rapgenius_url"] {
            rapgeniusURL = NSURL(string: rapgeniusURLString as! String)
        }
        
        if let youtubeURLString: AnyObject = dictionary["track_youtube_url"] {
            youtubeURL = NSURL(string: youtubeURLString as! String)
        }
        
        if let previewURLString: AnyObject = dictionary["track_preview_url"] {
            previewURL = NSURL(string: previewURLString as! String)
        }
    }
    
    func toDictionary() -> [String: AnyObject] {
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
