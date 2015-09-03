//
//  EmailService.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class EmailService: NSObject {
    var firebase: Firebase
    
    init(firebase: Firebase) {
        self.firebase = firebase
        
        super.init()
        
    }
    
    func openSessionWithEmail(username:String, password: String, completion: ((NSError?) -> ())? = nil) {
        self.firebase.authUser(username, password: password, withCompletionBlock: { error, authData -> Void in
            if error != nil {
                println(error)
                completion?(error)
                
            } else {
                println("logged in")
                completion?(nil)
            }
        })

    }
}