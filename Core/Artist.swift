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
    let tracks = List<Track>()
    
    var tracksList: [Track] {
        var list: [Track] = []
        for item in tracks {
            list.append(item)
        }
        return list
    }
}
