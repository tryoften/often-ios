//
//  Lyric.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class Lyric: NSObject, DebugPrintable {
    var id: String
    var text: String
    var categoryId: String
    var trackId: String?
    var track: Track?
    
    init(dict: [String: AnyObject]) {
        id = dict["id"] as String
        text = dict["text"] as String
        categoryId = dict["category_id"] as String
        trackId = dict["track_id"] as? String
        
        if let trackData = dict["track"] as? [String: String] {
            track = Track(dictionary: trackData)
        }
    }

    init(id: String, text: String, categoryId: String, trackId: String?) {
        self.id = id
        self.text = text
        self.categoryId = categoryId
        self.trackId = trackId

        super.init()
    }
    
    func toDictionary() -> [String: AnyObject] {
        var dict: [String: AnyObject] = [
            "id": id,
            "text": text,
            "category_id": categoryId
        ]
        
        if let trackId = trackId {
            dict["track_id"] = trackId
        }
        
        if let trackData = track?.toDictionary() {
            dict["track"] = trackData
        }
        
        return dict
    }
    
    override var debugDescription: String {
        return self.text
    }
}
