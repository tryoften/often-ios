//
//  TrackService.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/5/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class TrackService: NSObject {
    var tracksRef : Firebase
    var root : Firebase
    var tracks: [Track]
    var isDataLoaded: Bool

    init(root: Firebase) {
        self.tracksRef = root.childByAppendingPath("tracks")
        self.root = root
        self.tracks = []
        self.isDataLoaded = false

        super.init()
    }
    
    func requestData(completion: (Bool) -> Void) {
        self.tracksRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            let data = snapshot.value as! [ [String : String] ]
            println("\(data)")
            
            for trackData in data {
                var track = Track(dictionary: trackData)
                self.tracks.append(track)
            }
            
            self.isDataLoaded = true
            completion(true)
        })
    }
    
    func trackForId(id: String) -> Track? {
        var track: Track? = nil
        
        for aTrack in tracks {
            if aTrack.id == id {
                return aTrack
            }
        }
        
        return nil
    }
    
    
}
