//
//  Category.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import RealmSwift

class Category: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    var ownerId: String = ""
    var lyrics = List<Lyric>()
    dynamic var keyboard: Keyboard?
    var highlightColor: UIColor!
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["highlightColor", "ownerId"]
    }

    var lyricsCount: Int {
        return self.lyrics.count
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
}
