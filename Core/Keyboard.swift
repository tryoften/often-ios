//
//  Keyboard.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

class Keyboard: Object {
    dynamic var id: String = ""
    dynamic var artistName: String = ""
    dynamic var index: Int = -1
    dynamic var currentCategoryId: String = ""
    dynamic var artist: Artist?
    let categories = List<Category>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["categoryList"]
    }
    
    var categoryList: [Category] {
        var list : [Category] = []
        var i = 0
        for item in categories {
            item.highlightColor = UIColor(fromHexString: CategoryCollectionViewCellHighlightColors[i++ % CategoryCollectionViewCellHighlightColors.count])
            list.append(item)
        }
        return list
    }
}
