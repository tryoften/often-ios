//
//  User.swift
//  Often
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Project Surf. All rights reserved.
//

import Crashlytics

class User: NSObject {
    var id: String = ""
    var isNew: Bool = false
    var name: String = ""
    var username: String = ""
    var profileImageSmall: String = ""
    var profileImageLarge: String = ""
    var email: String = ""
    var phone: String = ""
    var userDescription: String = ""
    var password: String = ""
    var backgroundImage: String = ""
    var favoritesPackId: String = ""
    var recentsPackId: String = ""

    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {

        if let nameString = keyedValues["displayName"] as? String {
            name = nameString
        }
        
        if let nameString = keyedValues["name"] as? String {
            name = nameString
        }
        
        if let usernameString = keyedValues["username"] as? String {
            username = usernameString
        }
            
        if let userDescriptionString = keyedValues["description"] as? String {
            userDescription = userDescriptionString
        }
        
        if let idString = keyedValues["id"] as? String {
            id = idString
        }
        
        if let emailString = keyedValues["email"] as? String {
            email = emailString
        }

        if let backgroundImageString =  keyedValues["backgroundImage"] as? String {
            backgroundImage = backgroundImageString
        }

        if let profileImageSmallString = keyedValues["profileImageSmall"] as? String {
            profileImageSmall = profileImageSmallString
        }
        
        if let profileImageSmallString = keyedValues["profile_pic_small"] as? String {
            profileImageSmall = profileImageSmallString
        }
        
        if let profileImageLargeString = keyedValues["profileImageLarge"] as? String {
            profileImageLarge = profileImageLargeString
        }
        
        if let profileImageLargeString = keyedValues["profileImageURL"] as? String {
            profileImageLarge = profileImageLargeString
        }
        
        if let profileImageLargeString = keyedValues["profile_pic_large"] as? String {
            profileImageLarge = profileImageLargeString
        }
        
        if let phoneString = keyedValues["phone"] as? String {
            phone = phoneString
        }

        if let favsId = keyedValues["favoritesPackId"] as? String {
            favoritesPackId = favsId
        }

        if let recentsId = keyedValues["recentsPackId"] as? String {
            recentsPackId = recentsId
        }

        setupCrashlytics()
    }
    
    func dataChangedToDictionary() -> [String: String] {
       let userData = [
            "id": id,
            "name": name,
            "username": username,
            "profileImageSmall": profileImageSmall,
            "profileImageLarge": profileImageLarge,
            "email": email,
            "phone": phone,
            "description": userDescription,
            "password": password,
            "backgroundImage": backgroundImage
        ]

        return userData
    }

    private func setupCrashlytics() {
        Crashlytics.sharedInstance().setUserEmail(email)
        Crashlytics.sharedInstance().setUserIdentifier(id)
        Crashlytics.sharedInstance().setUserName(name)
    }
}

struct UserAuthData {
    var username: String
    var email: String
    var password: String
    var isNewUser: Bool
}
