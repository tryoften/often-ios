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
    var userDefaults: NSUserDefaults
    let sessionManager = SessionManager.defaultManager
    
    init(firebase: Firebase) {
        self.firebase = firebase
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        
        super.init()
        
    }
        
    func openSessionWithTwitter(completion: ((NSError?) -> ())? = nil) {
        userDefaults.setValue(true, forKey: "twitter")
        let twitterAuthHelper = TwitterAuthHelper(firebaseRef:firebase, apiKey:TwitterConsumerKey)
        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
            if error != nil {
                // Error retrieving Twitter accounts
            } else if !accounts.isEmpty {
    
                for account in accounts {
                    if let userName = PFTwitterUtils.twitter()?.screenName {
                        if account.username == userName {
                            
                            twitterAuthHelper.authenticateAccount(account as! ACAccount, withCallback: { error, authData in
                                if error != nil {
                                    print("Login failed. \(error)")
                                } else {
                                    self.getTwitterUserInfo(authData, completion: { err in
                                        
                                    })
                                }
                                completion?(error)
                            })
                        }
                    }
                    
                }
            } else {
            }
            
        }
        userDefaults.setValue(true, forKey: "openSession")
    }
    
    func login(completion: ((NSError?) -> ())? = nil) {
        PFTwitterUtils.logInWithBlock({ (user, error) in
            if error == nil {
                print(user)
                self.openSessionWithTwitter(completion)
            } else {
                completion?(error)
            }
        })
    }
    
    func getTwitterUserInfo(authData:FAuthData, completion: (NSError?) -> ()) {
       let userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        var data = [String : AnyObject]()
        var socialAccounts = sessionManager.createSocialAccount()
        
        if let accessToken = authData.providerData["accessToken"] as? String {
            let twitter = SocialAccount()
            twitter.type = .Twitter
            twitter.activeStatus = true
            twitter.token = accessToken
            socialAccounts.updateValue(twitter.toDictionary(), forKey: "twitter")
        }
        
        data["accounts"] = socialAccounts
        data["id"] = authData.uid
        data["profileImageURL"] = authData.providerData["profileImageURL"] as? String
        data["name"] = authData.providerData["displayName"] as? String
        data["username"] = authData.providerData["username"] as? String
        data["displayName"] = PFUser.currentUser()?.objectForKey("fullName") as? String
        data["description"] = (authData.providerData["cachedUserProfile"] as? [String: AnyObject])?["description"] as? String
        data["parseId"] = PFUser.currentUser()?.objectId
        
        userRef.setValue(data)

    }

}