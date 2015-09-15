//
//  TwitterAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class TwitterAccountManager: NSObject {
    var firebase: Firebase
    
    init(firebase: Firebase) {
        self.firebase = firebase
        
        super.init()
        
    }
        
    func openSessionWithTwitter(completion: ((NSError?) -> ())? = nil) {
        let twitterAuthHelper = TwitterAuthHelper(firebaseRef:firebase, apiKey:TwitterConsumerKey)
        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
            if error != nil {
                // Error retrieving Twitter accounts
            } else if accounts.count >= 1 {
                // Select an account. Here we pick the first one for simplicity
                let account = accounts[0] as? ACAccount
                twitterAuthHelper.authenticateAccount(account, withCallback: { error, authData in
                    if error != nil {
                        println("Login failed. \(error)")
                    } else {
                        self.getTwitterUserInfo(authData, completion: { err in
                            
                        })
                    }
                    completion?(error)
                })
            } else {
                
                completion?(NSError())
            }
            
        }
    }
    
    func getTwitterUserInfo(authData:FAuthData, completion: (NSError?) -> ()) {
       let userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        var data = [String : AnyObject]()
        
        data["id"] = authData.uid
        data["profileImageURL"] = authData.providerData["profileImageURL"] as? String
        data["name"] = authData.providerData["displayName"] as? String
        data["username"] = authData.providerData["username"] as? String
        data["displayName"] = PFUser.currentUser()?.objectForKey("fullName") as? String
        data["description"] = authData.providerData["cachedUserProfile"]!["description"] as? String
        data["parseId"] = PFUser.currentUser()?.objectId
        data["accounts"] = [
            "twitter":
            ["token":authData.providerData["accessToken"]!,
            "activeStatus":true,
            "tokenExpirationDate":""]
        ]
        
        userRef.setValue(data)

    }

}