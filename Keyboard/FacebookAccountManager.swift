//
//  FacebookAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class FacebookAccountManager: NSObject {
    var firebase: Firebase
    
    init(firebase: Firebase) {
        self.firebase = firebase
        
        super.init()
        
    }
    
    func openSessionWithFacebook(completion: ((NSError?) -> ())? = nil) {
        if let session = FBSession.activeSession() {
            let accessTokenData = session.accessTokenData
            
            if accessTokenData != nil {
                let accessToken = accessTokenData.accessToken
                firebase.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            println("Login failed. \(error)")
                        } else {
                            println( "session Opened. \(authData.providerData)")
                        }
                        completion?(error)
                })
            } else {
                completion?(NSError())
            }
        }

    }
    
    func getFacebookUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler({ (connection, result, error) in
            
            if error == nil {
                var data = (result as! NSDictionary).mutableCopy() as! NSMutableDictionary
                var userId = data["id"] as! String
                var profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"
                
                data["profile_pic_small"] = String(format: profilePicURLTemplate, userId, "small")
                data["profile_pic_large"] = String(format: profilePicURLTemplate, userId, "large")
                
                completion(data, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
}