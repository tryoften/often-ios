//
//  Track.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/6/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

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
    
    init(dictionary: [String: String]) {
        id = dictionary["id"]!
        name = dictionary["name"]!
        albumCoverImage = NSURL(string: dictionary["album_cover_image"]!)
        artistName = dictionary["artist_name"]!
        artistId = dictionary["artist_id"]!
        
        if let albumCoverImageLargeString = dictionary["album_cover_image_large"] {
            albumCoverImageLarge = NSURL(string: albumCoverImageLargeString)
        }
        
        if let spotifyURLString = dictionary["spotify_url"] {
            spotifyURL = NSURL(string: spotifyURLString)
        }
        
        if let soundcloudURLString = dictionary["soundcloud_url"] {
            soundcloudURL = NSURL(string: soundcloudURLString)
        }
        
        if let rapgeniusURLString = dictionary["rapgenius_url"] {
            rapgeniusURL = NSURL(string: rapgeniusURLString)
        }
        
        if let youtubeURLString = dictionary["youtube_url"] {
            youtubeURL = NSURL(string: youtubeURLString)
        }
        
        if let previewURLString = dictionary["preview_url"] {
            previewURL = NSURL(string: previewURLString)
        }
    }
}
