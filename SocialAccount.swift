//
//  SocialAccount.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SocialAccount: NSObject {
    var name = ""
    var token = ""
    var type: SocialAccountType
    var index: Int = -1
    var id: String = ""
    var activeStatus = false
    var tokenExpirationDate = ""
    var username = ""
    var password = ""
    var user: User?
    
    init (type:SocialAccountType, user: User) {
        self.type = type
        self.user = user
        super.init()
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {
            
            if let serviceName = dictionary["serviceName"] as? String {
                name = serviceName
            }
            
            if let id = dictionary["id"] as? String {
                self.id = id
            }
            if let serviceToken = dictionary["serviceToken"] as? String {
                token = serviceToken
            }
            
            if let active = dictionary["active"] as? Bool {
                activeStatus = active
            }
            
            if let expirationDate = dictionary["tokenExpirationDate"] as? String {
                tokenExpirationDate = expirationDate
            }
            
            if let expirationDate = dictionary["tokenExpirationDate"] as? String {
                tokenExpirationDate = expirationDate
            }
            
            if let usernameString = dictionary["userName"] as? String {
                username = usernameString
            }
            
            if let passwordString = dictionary["password"] as? String {
                password = passwordString
            }
        }
    }
}

enum SocialAccountType: String {
    case Twitter = "twitter"
    case Spotify = "spotify"
    case Youtube = "youtube"
    case Soundcloud = "soundcloud"
    case Venmo = "venmo"
    case Espn = "espn"
    case Vine = "vine"
}
