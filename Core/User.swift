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
    dynamic var backgroundImage: String = ""
    let keyboards = List<Keyboard>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {
            
            name = dictionary["name"] as! String
            id = dictionary["id"] as! String
            username = dictionary["email"] as! String
            email = dictionary["email"] as! String
            backgroundImage = dictionary["backgroundImage"] as! String
            
            
            if let profileImageSmallString = dictionary["profileImageSmall"] as? String {
                profileImageSmall = profileImageSmallString
            }
            if let profileImageSmallString = dictionary["profile_pic_small"] as? String {
                profileImageSmall = profileImageSmallString
            }
            
            if let profileImageLargeString = dictionary["profileImageLarge"] as? String {
                profileImageLarge = profileImageLargeString
            }
            
            if let profileImageLargeString = dictionary["profile_pic_large"] as? String {
                profileImageLarge = profileImageLargeString
            }
            
            if let phoneString = dictionary["phone"] as? String {
                phone = phoneString
            }
            
        }
    }
}
