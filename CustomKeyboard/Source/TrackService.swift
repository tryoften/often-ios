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
        self.tracksRef = root.childByAppendingPath("contents")
        self.tracks = [String: Track]()
        self.isDataLoaded = false

        super.init(root: root, realm: realm)
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        dispatch_async(writeQueue) {
            self.tracksRef.childByAppendingPath(lyric.id).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                println("\(snapshot.value)")
                if var trackData = snapshot.value as? [String: String] {
                    trackData["id"] = snapshot.key
                    
                    let track = Track()
                    track.id = snapshot.key
                    track.setValuesForKeysWithDictionary(trackData)
                    
                    self.tracks[track.id] = track
                    
                    self.realm.write {
                        self.realm.add(track, update: true)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(track: track)
                    }
                }
            })
        }
    }
}
