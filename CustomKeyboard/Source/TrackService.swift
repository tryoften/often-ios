//
//  TrackService.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/5/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrackService: NSObject {
    var tracksRef : Firebase
    var root : Firebase
    var tracks: [String: Track]
    var isDataLoaded: Bool

    init(root: Firebase) {
        self.tracksRef = root.childByAppendingPath("contents")
        self.root = root
        self.tracks = [String: Track]()
        self.isDataLoaded = false

        super.init()
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        self.tracksRef.childByAppendingPath(lyric.id).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            println("\(snapshot.value)")
            if var trackData = snapshot.value as? [String: String] {
                trackData["id"] = snapshot.key

                let track = Track(dictionary: trackData)
                self.tracks[track.id] = track
                
                completion(track: track)
            }
        })
    }
}
