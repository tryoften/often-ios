//
//  Artist.swift
//  Drizzy
//
//  Created by Luc Success on 4/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class Artist: NSObject {
    var id: String
    var name: String
    var imageURLSmall: NSURL?
    var imageURLLarge: NSURL?
    var tracks: [Track]?
    var lyrics: [Lyric]?
    
    init(id: String, name: String, imageURLSmall: NSURL? = nil, imageURLLarge: NSURL? = nil) {
        self.id = id
        self.name = name
        self.imageURLSmall = imageURLSmall
        self.imageURLLarge = imageURLLarge
    }
}
