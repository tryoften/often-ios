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
    var lyricCount: Int

    init(id: String, name: String, imageURLSmall: NSURL? = nil, imageURLLarge: NSURL? = nil) {
        self.id = id
        self.name = name
        self.imageURLSmall = imageURLSmall
        self.imageURLLarge = imageURLLarge
        self.lyricCount = 10
    }
    
    init(id:String, dictionary: NSDictionary) {
        self.id = id
        self.name = dictionary["name"] as! String
        self.imageURLSmall = NSURL(string: dictionary["image_small"] as! String)
        self.imageURLLarge = NSURL(string: dictionary["image_large"] as! String)
        self.lyricCount = 200
    }
}
