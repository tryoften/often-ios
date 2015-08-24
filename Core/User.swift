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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {

            if let nameString = dictionary["displayName"] as? String {
                name = nameString
            }
            
            if let idString = dictionary["id"] as? String {
                id = idString
            }
            
            if let usernameString = dictionary["email"] as? String {
                username = usernameString
            }
            
            if let emailString = dictionary["email"] as? String {
                email = emailString
            }
            
            if let backgroundImageString =  dictionary["backgroundImage"] as? String {
                backgroundImage = backgroundImageString
            }
            
            if let profileImageSmallString = dictionary["profileImageSmall"] as? String {
                profileImageSmall = profileImageSmallString
            }
            
            if let profileImageSmallString = dictionary["profile_pic_small"] as? String {
                profileImageSmall = profileImageSmallString
            }
            
            if let profileImageLargeString = dictionary["profileImageLarge"] as? String {
                profileImageLarge = profileImageLargeString
            }
            
            if let profileImageLargeString = dictionary["profileImageURL"] as? String {
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
