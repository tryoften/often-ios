//
//  VenmoFriend.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/21/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoFriend: NSObject {
    var name = ""
    var id: UInt = 0
    var profileURL = ""
    var username = ""
    
    override func setValuesForKeysWithDictionary(keyedValues: [NSObject : AnyObject]) {
        
        if let dictionary = keyedValues as? [String: AnyObject] {
            
            if let name = dictionary["display_name"] as? String {
                self.name = name
            }
            
            if let id = dictionary["id"] as? UInt {
                self.id = id
            }
            
            if let profileURL = dictionary["profile_picture_url"] as? String {
                self.profileURL = profileURL
            }
            
            if let username = dictionary["username"] as? String {
                self.username = username
            }
        }
    }

}
