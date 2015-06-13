//
//  Owner.swift
//  Drizzy
//
//  Created by Luc Succes on 6/3/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//


import RealmSwift

class Owner: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var imageURLSmall: String = ""
    dynamic var imageURLLarge: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
