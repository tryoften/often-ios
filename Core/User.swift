//
//  User.swift
//  Drizzy
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//



class User: NSObject {
    var id: String = ""
    var name: String = ""
    var profileImageSmall: String = ""
    var profileImageLarge: String = ""
    var username: String = ""
    var email: String = ""
    var phone: String = ""
    var userDescription: String = ""

    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {

            if let nameString = dictionary["displayName"] as? String {
                name = nameString
            }
            
            if let nameString = dictionary["name"] as? String {
                name = nameString
            }
            
            if let userDescriptionString = dictionary["description"] as? String {
                userDescription = userDescriptionString
            }
            
            if let idString = dictionary["id"] as? String {
                id = idString
            }
            
            if let usernameString = dictionary["username"] as? String {
                username = usernameString
            }
            
            if let emailString = dictionary["email"] as? String {
                email = emailString
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
    
    func dataChangedToDictionary() -> [String:String] {
       let userData = [
            "id": id,
            "name": name,
            "profileImageSmall": profileImageSmall,
            "profileImageLarge": profileImageLarge,
            "username": username,
            "email": email,
            "phone": phone,
            "backgroundImage": name,
            "description": userDescription
        ]
        return userData
    }
    
    
}
