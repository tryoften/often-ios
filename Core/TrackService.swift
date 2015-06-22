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
    var ref: Firebase
    var tracks: [String: Track]
    var isDataLoaded: Bool

    override init(root: Firebase, realm: Realm = Realm()) {
        tracksRef = root.childByAppendingPath("contents")
        ref = root.childByAppendingPath("owners")
        tracks = [String: Track]()
        isDataLoaded = false
        super.init(root: root, realm: realm)
    }
    
    /**
        requestData(artistId: String): takes in an artist ID and returns all of the tracks for that
        artists in self.tracks as a [String : Track]
    */
    func requestData(completion: ([String : Track]) -> Void) {
        ref.observeEventType(.Value, withBlock: { snapshot in
            // [artist ID : [image kind : image URL]]
            if let artistsData = snapshot.value as? [String : [String : AnyObject]] {
                for (key, data) in artistsData {
                    //images and then track dictionary
                    let artistId = key
                    self.ref = self.ref.childByAppendingPath("\(artistId)/tracks")
                    self.ref.observeEventType(.Value, withBlock: { snapshot in
                        if let tracksData = snapshot.value as? [String : [String : String]] {
                            for(key, data) in tracksData {
                                let track = Track(value: data)
                                self.tracks[key] = track
                            }
                        }
                        completion(self.tracks)
                    })

                }
            }
        })
    }
    
    
    /**
        loads the track array in this class with all of the tracks for a particular artist based on the
        artist's ID that you provide
    
        :param: string representing an artist in format "-JoBAZJLJUQMdJXiCgch" to pull from Firebase

    */
    func getTracksForArtistId(artistId: String) {
        ref = ref.childByAppendingPath("/\(artistId)/tracks") //owners/artistID/tracks
        println(ref)
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let artistData = snapshot.value as? [String : [String : AnyObject]] {
                for(key, data) in artistData {
                    var track = Track(value: [
                        "id": key
                    ])
                    
//                    track.setValuesForKeysWithDictionary(data)
                    self.tracks[key] = track
                }
            }
        })
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        
        // Read from in-memory cache
        if let track = tracks[lyric.trackId] {
            completion(track: track)
            return
        }
        
        // Read track from local database first
        if let track = realm.objectForPrimaryKey(Track.self, key: lyric.trackId) {
            tracks[track.id] = track
            completion(track: track)
            return
        }
        
        // Fetch track data from firebase
        tracksRef.childByAppendingPath(lyric.id).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let trackData = snapshot.value as? [String: String],
                let trackId = trackData["track_id"] ?? snapshot.key {
                
                var track: Track

                if let trackModel = self.realm.objectForPrimaryKey(Track.self, key: trackId) {
                    track = trackModel
                } else {
                    track = Track()
                    track.id = trackId
                    track.setValuesForKeysWithDictionary(trackData)
                }

                self.tracks[track.id] = track
                if lyric.track == nil {
                    
                    self.realm.beginWrite()
                    lyric.track = track
                    lyric.trackId = track.id
                    self.realm.add(lyric, update: true)
                    self.realm.commitWrite()
                    completion(track: track)
                }
                
            }
        })
    }
}
