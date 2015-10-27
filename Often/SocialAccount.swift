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
    var type: SocialAccountType = .Other
    var activeStatus = false
    var tokenExpirationDate = ""
    
    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {
        
            if let socialAccountType = keyedValues["type"] as? String,
                let accountType = SocialAccountType(rawValue: socialAccountType) {
                type = accountType
            }
            
            if let serviceToken = keyedValues["token"] as? String {
                token = serviceToken
            }
            
            if let active = keyedValues["activeStatus"] as? Bool {
                activeStatus = active
            }
            
            if let expirationDate = keyedValues["tokenExpirationDate"] as? String {
                tokenExpirationDate = expirationDate
            }
        
    }
    
    func toDictionary() -> [String: AnyObject] {
        let dict: [String: AnyObject] = [
            "token": token,
            "type": type.rawValue,
            "activeStatus": activeStatus,
            "tokenExpirationDate": tokenExpirationDate
        ]

        return dict
    }
    
}

enum SocialAccountType: String {
    case Twitter = "twitter"
    case Spotify = "spotify"
    case Soundcloud = "soundcloud"
    case Other = "other"
}
