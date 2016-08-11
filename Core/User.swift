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
    var firstName: String = ""
    var lastName: String = ""
    var username: String = ""
    var profileImageSmall: String = ""
    var profileImageLarge: String = ""
    var email: String = ""
    var phone: String = ""
    var password: String = ""
    var backgroundImage: String = ""
    var favoritesPackId: String = ""
    var recentsPackId: String = ""
    var shareCount: Int = 0
    var pushNotificationStatus: Bool = false
    var firebasePushNotificationToken: String = ""

    override func setValuesForKeysWithDictionary(data: [String : AnyObject]) {

        if let nameString = data["displayName"] as? String {
            name = nameString
        }
        
        if let nameString = data["name"] as? String {
            name = nameString
        }

        if let firstNameString = data["first_name"] as? String {
            firstName = firstNameString
        }

        if let lastNameString = data["last_name"] as? String {
            lastName = lastNameString
        }
        
        if let usernameString = data["username"] as? String {
            username = usernameString
        }
        
        if let idString = data["id"] as? String {
            id = idString
        }
        
        if let emailString = data["email"] as? String {
            email = emailString
        }

        if let backgroundImageString =  data["backgroundImage"] as? String {
            backgroundImage = backgroundImageString
        }

        if let profileImageSmallString = data["profileImageSmall"] as? String {
            profileImageSmall = profileImageSmallString
        }

        if let profileImageLargeString = data["profileImageLarge"] as? String {
            profileImageLarge = profileImageLargeString
        }

        if let phoneString = data["phone"] as? String {
            phone = phoneString
        }

        if let favsId = data["favoritesPackId"] as? String {
            favoritesPackId = favsId
        }

        if let recentsId = data["recentsPackId"] as? String {
            recentsPackId = recentsId
        }

        if let shareCount = data["shareCount"] as? Int {
            self.shareCount = shareCount
        }

        if let pushNotificationStatus = data["pushNotificationStatus"] as? Bool {
            self.pushNotificationStatus = pushNotificationStatus
            SessionManagerFlags.defaultManagerFlags.userNotificationSettings = pushNotificationStatus
        }

        if let firebasePushNotificationToken = data["firebasePushNotificationToken"] as? String {
            self.firebasePushNotificationToken = firebasePushNotificationToken
        }

        setupCrashlytics()
    }
    
    func dataChangedToDictionary() -> [String: AnyObject] {
        let userData: [String: AnyObject] = [
            "id": id,
            "name": name,
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "profileImageSmall": profileImageSmall,
            "profileImageLarge": profileImageLarge,
            "image": [
                "small_url": profileImageSmall,
                "large_url": profileImageLarge
            ],
            "email": email,
            "phone": phone,
            "password": password,
            "backgroundImage": backgroundImage,
            "favoritesPackId": favoritesPackId,
            "recentsPackId": recentsPackId
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
    var name: String
    var email: String
    var password: String
    var isNewUser: Bool
}
