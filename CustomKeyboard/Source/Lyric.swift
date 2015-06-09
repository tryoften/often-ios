//
//  Lyric.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import Realm
import RealmSwift

class Lyric: Object, DebugPrintable {
    dynamic var id: String = ""
    dynamic var text: String = ""
    dynamic var categoryId: String = ""
    var trackId: String?
    var track: Track?
    
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
