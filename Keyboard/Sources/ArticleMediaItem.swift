//
//  ArticleMediaItem.swift
//  Often
//
//  Created by Luc Succes on 10/1/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ArticleMediaItem: MediaItem {
    var title: String
    var link: String
    var date: Date?
    var author: String?
    var description: String?
    var summary: String?
    var categories: [String]?

    required init(data: NSDictionary) {
        self.title = data["title"] as? String ?? ""
        self.link = data["link"] as? String ?? ""

        if let link = data["external_link"] as? String {
            self.link = link
        }

        self.author = data["author"] as? String
        self.description = data["description"] as? String
        self.summary = data["summary"] as? String

        if let date = data["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.date = dateFormatter.date(from: date)
        }

        super.init(data: data)

        self.type = .Article
        self.score = data["_score"] as? Double ?? 0.0
    }

    override func getInsertableText() -> String {
        return "\(title) - \(link)"
    }
}
