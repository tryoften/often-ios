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
            } else if accounts.count > 1 {
                // Select an account. Here we pick the first one for simplicity
                let account = accounts[0] as? ACAccount
                twitterAuthHelper.authenticateAccount(account, withCallback: { error, authData in
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
    
    func getTwitterUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        
    }

}