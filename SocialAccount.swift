//
//  SocialAccount.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SocialAccount: NSObject {
    var token = ""
    var type: SocialAccountType?
    var activeStatus = false
    var tokenExpirationDate = ""
    
    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {
            if let socialAccountType = dictionary["socialAccountType"] as? String {
                type = SocialAccountType(rawValue: socialAccountType)
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
            
        }
    }
}

enum SocialAccountType: String {
    case Twitter = "twitter"
    case Spotify = "spotify"
    case Soundcloud = "soundcloud"
    case Venmo = "venmo"
    case Other = "other"
}
