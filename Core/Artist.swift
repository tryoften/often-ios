//
//  Artist.swift
//  Drizzy
//
//  Created by Luc Success on 4/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

class Artist: Owner {
    dynamic var keyboardId: String = ""
    dynamic var index: Int = -1
    dynamic var lyricCount: Int = 0
    dynamic var tracksCount: Int = 0
    dynamic var arrow = ""
    dynamic var score: Int = 0
    let tracks = List<Track>()
    
    var displayName: String {
        var string = ""
        for letter in name {
            string += "\(letter) "
        }
        return string.uppercaseString
    }
    
    var tracksList: [Track] {
        var list: [Track] = []
        for item in tracks {
            list.append(item)
        }
        return list
    }
    
    override static func ignoredProperties() -> [String] {
        return ["arrow"]
    }
}
