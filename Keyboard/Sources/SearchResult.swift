//
//  SearchResult.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

enum SearchResultType: String {
    case Article = "article"
    case Link = "link"
    case Music = "music"
    case Album = "album"
    case Track = "track"
    case Artist = "artist"
    case Video = "video"
    case User = "user"
    case Other = "other"
}

class SearchResult {
    var id: String = ""
    var type: SearchResultType = .Other
    var score: Double = 0.0
    var sourceName: String = ""
    var sourceId: String = ""
}

class ArticleSearchResult: SearchResult {
    var title: String
    var date: NSDate
    var link: String
    
    var author: String?
    var description: String?
    var summary: String?
    var categories: [String]?
    
    init (id: String, title: String, date: NSDate, link: String, score: Double) {
        self.title = title
        self.date = date
        self.link = link
        
        super.init()
        
        self.id = id
        self.type = .Article
    }
}

class MusicSearchResult: SearchResult {
    
}

class VideoSearchResult: SearchResult {
    
}
