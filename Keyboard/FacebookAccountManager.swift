//
//  FacebookAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class FacebookAccountManager: AccountManager {
    let permissions = [
        "public_profile",
        "user_actions.music",
        "user_likes",
        "email"
    ]
    
    func openSessionWithFacebook(completion: ((NSError?) -> ())? = nil) {
        if let session = FBSession.activeSession() {
            let accessTokenData = session.accessTokenData
            
            if accessTokenData != nil {
                let accessToken = accessTokenData.accessToken
                firebase.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print( "session Opened. \(authData.providerData)")
                        }
                        completion?(error)
                })
            }
        }
        sessionManagerFlags.openSession = true
    }
    
    func login(completion: ((NSError?) -> ())? = nil) {
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) in
            if error == nil {
                self.openSessionWithFacebook(completion)
                
            } else {
                completion?(error)
            }
        })

    }
    
    func getFacebookUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        let request = FBRequest.requestForMe()
        request.startWithCompletionHandler({ (connection, result, error) in
            
            if error == nil {
                let data = (result as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let userId = data["id"] as! String
                let profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"
                
                data["profile_pic_small"] = String(format: profilePicURLTemplate, userId, "small")
                data["profile_pic_large"] = String(format: profilePicURLTemplate, userId, "large")
                
                completion(data, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
}