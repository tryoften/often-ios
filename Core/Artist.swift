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
    dynamic var lyricCount: Int = 200
    dynamic var artistId: String = ""
    dynamic var index: Int = -1
    let tracks = List<Track>()
    
    var tracksList: [Track] {
        var list : [Track] = []
        var i = 0
        for item in tracks {
            list.append(item)
        }
        return list
    }
}
