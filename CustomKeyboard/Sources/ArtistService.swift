//
//  ArtistService.swift
//  Drizzy
//
//  Created by Luc Success on 4/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistService: NSObject {
    var artistsRef: Firebase
    var artists: [String: Artist]
    
    init(root: Firebase) {
        artistsRef = root.childByAppendingPath("owners")
        artists = [String: Artist]()
        super.init()
    }
    
    func requestData(completion: (Bool) -> Void) {
        artistsRef.observeEventType(.Value, withBlock: { snapshot in 
            if let artistsData = snapshot.value as? [String: AnyObject] {
                for (key, val) in artistsData {
                    if let artistData = val as? [String: AnyObject],
                        let artistName = artistData["name"] as? String,
                        let urlSmall = artistData["image_small"] as? String,
                        let urlLarge = artistData["image_large"] as? String,
                        let artistId = key as? String {
                            var tracks = [Track]()
                            var artist = Artist(id: key, name: artistName, imageURLSmall: NSURL(string: urlSmall)!, imageURLLarge: NSURL(string: urlLarge)!)
                            if let tracksData = artistData["tracks"] as? [String : [String : String]] {
                                for (trackKey, trackData) in tracksData {
                                    var data = trackData
                                    data["id"] = trackKey
                                    var track = Track(dictionary: data)
                                    tracks.append(track)
                                    //completion here
                                }
                                artist.tracks = tracks
                            }
                        self.artists[key] = artist
                    }
                }
            }
        })
    }
    
    
    
}








