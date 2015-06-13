//
//  User.swift
//  Drizzy
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

class User: Object {
    dynamic var id: String = ""
    dynamic var fullName: String = ""
    dynamic var profileImageSmall: String = ""
    dynamic var profileImageLarge: String = ""
    dynamic var username: String = ""
    dynamic var email: String = ""
    dynamic var keyboards: [Keyboard] = []
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
