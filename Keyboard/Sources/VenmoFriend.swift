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
    
    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {
        
        if let name = keyedValues["display_name"] as? String {
            self.name = name
        }
        
        if let id = keyedValues["id"] as? UInt {
            self.id = id
        }
        
        if let profileURL = keyedValues["profile_picture_url"] as? String {
            self.profileURL = profileURL
        }
        
        if let username = keyedValues["username"] as? String {
            self.username = username
        }
    }
    

}
