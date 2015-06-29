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
    dynamic var name: String = ""
    dynamic var profileImageSmall: String = ""
    dynamic var profileImageLarge: String = ""
    dynamic var username: String = ""
    dynamic var email: String = ""
    dynamic var phone: String = ""
    var keyboards: [Keyboard] {
        return linkingObjects(Keyboard.self, forProperty: "user")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func hasKeyboardForArtist(artist: Artist) -> Bool {
        for keyboard in keyboards {
            if let keyboardOwner = keyboard.artist {
                if artist.id == keyboardOwner.id {
                    return true
                }
            }
        }
        return false
    }
}
