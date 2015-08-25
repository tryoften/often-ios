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

enum SearchResultSource: String {
    case Complex = "complex-music"
    case Spotify = "spotify"
    case SpinMusic = "spin-music"
    case SpinNews = "spin-news"
    case Soundcloud = "soundcloud"
    case Youtube = "youtube"
    case VibeNews = "vibe-news"
    case VibeMusic = "vibe-music"
    case Vice = "vice"
    case MTV = "mtv-news"
    case Unknown = "unknown"
}

class SearchResult {
    var id: String = ""
    var type: SearchResultType = .Other
    var score: Double = 0.0
    var sourceName: String = ""
    var source: SearchResultSource = .Unknown
    
    func iconImageForSource() -> UIImage? {
        return UIImage(named: source.rawValue)
    }
}

class ArticleSearchResult: SearchResult {
    var title: String
    var link: String
    
    var date: NSDate?
    var author: String?
    var description: String?
    var summary: String?
    var categories: [String]?
    
    init (data: [String: AnyObject]) {
        self.title = data["title"] as! String
        self.link = data["link"] as! String
        
        self.author = data["author"] as? String
        self.description = data["description"] as? String
        self.summary = data["summary"] as? String
        
        if let date = data["date"] as? String {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.date = dateFormatter.dateFromString(date)
        }

        super.init()
        
        self.id = data["_id"] as! String
        self.type = .Article
        self.score = data["_score"] as? Double ?? 0.0
    }
}

class TrackSearchResult: SearchResult {
    var name: String = ""
    var albumName: String = ""
    var artistName: String = ""
    var url: String = ""
    var image: String = ""
    var plays: Int?
    var created: NSDate?
    var formattedCreatedDate: String {
        if let created = created {
            return created.timeAgoSinceNow()
        }
        return ""
    }
    
    init(resultData: [String: AnyObject]) {
        super.init()
        
        self.type = .Track

        if let id = resultData["_id"] as? String {
            self.id = id
        }
        
        if let name = resultData["name"] as? String {
            self.name = name
        }
        
        if let url = resultData["uri"] as? String {
            self.url = url
        }
        
        if let url = resultData["url"] as? String {
            self.url = url
        }
        
        if let image = resultData["image"] as? String {
            self.image = image
        }
        
        if let image = resultData["image_large"] as? String {
            self.image = image
        }
        
        if let albumName = resultData["album_name"] as? String {
            self.albumName = albumName
        }

        if let artistName = resultData["artist_name"] as? String {
            self.artistName = artistName
        }
        
        if let user = resultData["user"] as? [String: String],
            let username = user["username"] {
                self.artistName = username
        }
        
        if let plays = resultData["plays"] as? Int {
            self.plays = plays
        }
        
        if let created = resultData["created"] as? String {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss ZZZZ"
            self.created = dateFormatter.dateFromString(created)
        }
    }
    
    func formattedPlays() -> String {
        if let plays = plays {
            let formattedNum = NSNumber(integer: plays).descriptionWithLocale(NSLocale.currentLocale())
            return "\(formattedNum) Plays"
        }
        return "No Plays"
    }
}

class VideoSearchResult: SearchResult {
    
}
