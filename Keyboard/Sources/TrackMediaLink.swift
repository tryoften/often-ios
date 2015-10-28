//
//  TrackMediaLink.swift
//  Often
//
//  Created by Luc Succes on 10/1/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class TrackMediaLink: MediaLink {
    var name: String = ""
    var albumName: String = ""
    var artistName: String = ""
    var url: String = ""
    var plays: Int?
    var created: NSDate?
    var formattedCreatedDate: String {
        if let created = created {
            return created.timeAgoSinceNow()
        }
        return ""
    }
    
    override init(data: [String: AnyObject]) {
        super.init(data: data)
        
        self.type = .Track
        
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let url = data["uri"] as? String {
            self.url = url
        }
        
        if let url = data["url"] as? String {
            self.url = url
        }
        
        if let url = data["external_url"] as? String {
            self.url = url
        }
        
        if let image = data["image"] as? String {
            self.image = image
        }
        
        if let image = data["image_large"] as? String {
            self.image = image
        }
        
        if let albumName = data["album_name"] as? String {
            self.albumName = albumName
        }
        
        if let artistName = data["artist_name"] as? String {
            self.artistName = artistName
        }
        
        if let user = data["user"] as? [String: AnyObject],
            let username = user["username"] as? String {
                self.artistName = username
        }
        
        if let plays = data["plays"] as? Int {
            self.plays = plays
        }
        
        if let created = data["created"] as? String {
            let dateFormatter = NSDateFormatter()
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
    
    override func getInsertableText() -> String {
        return "\(name) by \(artistName) - \(url)"
    }
}
