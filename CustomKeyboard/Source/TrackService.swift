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
        if !isDataLoaded {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                self.getDataFromDisk({
                    (success, error) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success)
                    })
                    
                })
            })
        } else {
            completion(false)
        }
        
        
        self.tracksRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            let data = snapshot.value as! [ [String : String] ]
//            println("\(data)")
            
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
    
    func getDataFromDisk(completion: (success: Bool, error: NSError?) -> ()) {
        if let urlPath = NSBundle.mainBundle().pathForResource("lyrics", ofType: "json"), data = NSData(contentsOfFile: urlPath) {
            var error: NSError?
            var json = JSON(data: data, options: nil, error: &error)
            
            if error != nil {
                completion(success: false, error: error)
                return
            }
            
            tracks = [Track]()
            
            if let tracks = json["tracks"].array {
                
                for track in tracks {
                    
                    if let trackDictionary = track.dictionaryObject {
                        self.tracks.append(Track(dictionary: trackDictionary as! [String: String]))
                    }

                }
                
                isDataLoaded = true
                completion(success: true, error: nil)
            }
        }
    }

}
