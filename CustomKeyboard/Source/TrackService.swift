//
//  TrackService.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/5/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import RealmSwift

class TrackService: Service {
    var tracksRef : Firebase
    var tracks: [String: Track]
    var isDataLoaded: Bool

    override init(root: Firebase, realm: Realm = Realm()) {
        tracksRef = root.childByAppendingPath("contents")
        tracks = [String: Track]()
        isDataLoaded = false

        super.init(root: root, realm: realm)
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        tracksRef.childByAppendingPath(lyric.id).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            println("\(snapshot.value)")
            if let trackData = snapshot.value as? [String: String] {
                
                let track = Track()
                track.id = snapshot.key
                track.setValuesForKeysWithDictionary(trackData)
                
                self.tracks[track.id] = track
                lyric.track = track
                lyric.trackId = track.id
                
                self.realm.write {
                    self.realm.add(lyric, update: true)
                    self.realm.add(track, update: true)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(track: track)
                }
            }
        })
    }
}
