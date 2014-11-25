//
//  Category.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id: String
    var name: String
    var lyrics: [Lyric]?
    var lyricsRef = Firebase(url: CategoryServiceEndpoint + "/lyrics")
    
    init(id: String, name: String, lyrics: [Lyric]?) {
        self.id = id
        self.name = name
        self.lyrics = lyrics
        
        super.init()
    }
}
