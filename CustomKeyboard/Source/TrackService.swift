//
//  TrackService.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/5/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class TrackService: NSObject {
    var ref : Firebase
    var root : Firebase
    var tracks: [String: Track]
    var isDataLoaded: Bool
    
    let artistId = "-JoBAZJLJUQMdJXiCgch"

    init(root: Firebase) {
        self.ref = root.childByAppendingPath("owners")
        self.root = root
        self.tracks = [String: Track]()
        self.isDataLoaded = false

        super.init()
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
                                        let currentTrack = Track(dictionary: trackData)
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
                    if let trackId: AnyObject = key as? AnyObject,
                        let trackData = data as? [String : AnyObject] {
                            var mutableTrackData = trackData
                            mutableTrackData["id"] = key
                            var currentTrack = Track(dictionary: mutableTrackData)
                            self.tracks["\(trackId)"] = currentTrack
                    }
                }
            }
        })
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        self.ref.childByAppendingPath(lyric.id).observeSingleEventOfType(.Value, withBlock: { snapshot in
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
