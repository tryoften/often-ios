//
//  User.swift
//  Drizzy
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String
    var fullName: String
    var profileImageSmall: NSURL
    var profileImageLarge: NSURL
    var username: String
    var email: String
    var keyboards: [Keyboard]
    
    init(data: [String: AnyObject]) {
        id = data["id"] as! String
        fullName = data["name"] as! String
        profileImageLarge = NSURL(string: data["profile_pic_large"] as! String)!
        profileImageSmall = NSURL(string: data["profile_pic_small"] as! String)!
        username = data["email"] as! String
        email = data["email"] as! String
        
        keyboards = [Keyboard]()
        
        super.init()
    }
}
