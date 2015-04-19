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
    var lyrics = [Lyric]()
    var lyricsRef = Firebase(url: CategoryServiceEndpoint + "/lyrics")
    
    init(id: String, name: String, lyrics: [Lyric]?) {
        self.id = id
        self.name = name
        if let lyrics = lyrics {
            self.lyrics = lyrics
        }
        
        super.init()
    }
    
    func filterLyricsByText(filterText: String) -> [Lyric]? {
        var filterLyricSet = [Lyric]()
        
        if filterText == "" {
            return lyrics
        }
        
        for lyric in lyrics {
            if fuzzySearch(lyric.text, filterText, caseSensitive: true) {
                filterLyricSet.append(lyric)
            }
        }
        
        return filterLyricSet
    }
}
