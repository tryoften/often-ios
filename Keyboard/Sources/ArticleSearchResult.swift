//
//  ArticleSearchResult.swift
//  Often
//
//  Created by Luc Succes on 10/1/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ArticleSearchResult: SearchResult {
    var title: String
    var link: String
    var date: NSDate?
    var author: String?
    var description: String?
    var summary: String?
    var categories: [String]?

    override init(data: [String: AnyObject]) {
        self.title = data["title"] as! String
        self.link = ""
            
        if let link = data["link"] as? String {
            self.link = link
        }
        
        if let link = data["external_link"] as? String {
            self.link = link
        }
        
        self.author = data["author"] as? String
        self.description = data["description"] as? String
        self.summary = data["summary"] as? String
        
        if let date = data["date"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.date = dateFormatter.dateFromString(date)
        }
        
        super.init(data: data)
        
        if let images = data["images"] as? [ [String: AnyObject] ] {
            var rectangleImage: [String: AnyObject]? = nil
            for imageData in images {
                let transformation = imageData["transformation"] as! String
                if transformation == "square" {
                    rectangleImage = imageData
                }
            }
            
            if rectangleImage != nil {
                self.image = rectangleImage?["url"] as? String
            }
        } else {
            self.image = data["image"] as? String
        }
        
        self.type = .Article
        self.score = data["_score"] as? Double ?? 0.0
    }
    
    override func getInsertableText() -> String {
        return "\(title) - \(link)"
    }
}