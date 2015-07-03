//
//  Lyric.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import Realm
import RealmSwift

class Lyric: Object {
    dynamic var id: String = ""
    dynamic var text: String = ""
    dynamic var categoryId: String = ""
    dynamic var trackId: String = ""
    dynamic var artistId: String = ""
    dynamic var track: Track?
    dynamic var arrow: String = ""
    dynamic var owner: String = ""
    dynamic var ownerImageLarge: String = ""
    dynamic var score: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["arrow", "owner"]
    }
}

extension Lyric: DebugPrintable {
    override var debugDescription: String {
        return self.text
    }
}