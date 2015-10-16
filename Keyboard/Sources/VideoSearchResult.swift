//
//  VideoSearchResult.swift
//  Often
//
//  Created by Luc Succes on 10/1/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class VideoSearchResult: SearchResult {
    var title: String = ""
    var link: String = ""
    var owner: String = ""
    var description: String = ""
    var date: NSDate?
    var viewCount: Int?
    var likeCount: Int?
    
    override init(data: [String: AnyObject]) {
        if let link = data["link"] as? String {
            self.link = link
        }
        
        if let link = data["external_url"] as? String {
            self.link = link
        }
        
        if let title = data["title"] as? String {
            self.title = title
        }
        
        if let channelTitle = data["channel_title"] as? String {
            self.owner = channelTitle
        }
        
        if let description = data["description"] as? String {
            self.description = description
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let dateString = data["published"] as? String,
            let date = dateFormatter.dateFromString(dateString) {
                self.date = date
        }
        
        super.init(data: data)
        
        if let thumbnail = data["thumbnail"] as? String {
            self.image = thumbnail
        }
        
        if let viewCount = data["viewCount"] as? String {
            self.viewCount = Int(viewCount)
        }
        
        if let likeCount = data["likeCount"] as? String {
            self.likeCount = Int(likeCount)
        }
        
        self.type = .Video
    }
    
    override func getInsertableText() -> String {
        return "\(title) - \(link)"
    }
}