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
    
    let artistId = "-JoBAZJLJUQMdJXiCgch"

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
    func requestData(completion: ([String : Track])-> Void) {
        ref.observeEventType(.Value, withBlock: { snapshot in
            // [artist ID : [image kind : image URL]]
            if let artistsData = snapshot.value as? [String : [String : AnyObject]] {
                for (key, data) in artistsData {
                    //images and then track dictionary
                    if let artistData = data as? [String : AnyObject],
                    let artistId = key as? String {
                        self.ref = self.ref.childByAppendingPath("\(artistId)/tracks")
                        self.ref.observeEventType(.Value, withBlock: { snapshot in
                            if let tracksData = snapshot.value as? [String : [String : String]] {
                                for(key, data) in tracksData {
                                    if let trackData = data as? [String : String],
                                        let trackId = key as? String {
                                        let currentTrack = Track(value: trackData)
                                    }
                                }
                            }
                        })
                    }
                    completion(self.tracks)
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
