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
    var isInternetReachable: Bool
    
    enum ResultType {
        case Success(r: Bool)
        case Error(e: ErrorType)
        case SystemError(e: NSError)
    }
    
    init(firebase: Firebase) {
        self.firebase = firebase
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable
        
        super.init()
        
        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        reachabilitymanager.startMonitoring()
    }
        
    func openSessionWithTwitter(completion: ((NSError?) -> ())? = nil) {
        userDefaults.setValue(true, forKey: "twitter")
        
        let twitterAuthHelper = TwitterAuthHelper(firebaseRef: firebase, apiKey: TwitterConsumerKey)
        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
            if error != nil {
                // Error retrieving Twitter accounts
                completion?(error)
            } else if !accounts.isEmpty {
    
                for account in accounts {
                    if let userName = PFTwitterUtils.twitter()?.screenName {
                        if account.username == userName {
                            
                            twitterAuthHelper.authenticateAccount(account as! ACAccount, withCallback: { error, authData in
                                if error != nil {
                                    print("Login failed. \(error)")
                                    completion?(error)
                                } else {
                                    self.getTwitterUserInfo(authData, completion: { err in
                                        if err != nil {
                                            completion?(err)
                                        }
                                      completion?(nil)  
                                    }
                                    )
                                }
  
                            })
                        }
                    }
                    
                }
            }
        }

        userDefaults.setValue(true, forKey: SessionManagerProperty.openSession)
        userDefaults.synchronize()
    }
    
    func login(completion: (results: ResultType) -> Void) {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: TwitterAccountManagerError.NotConnectedOnline))
            return
        }
        
        PFTwitterUtils.logInWithBlock({ (user, error) in
            if error == nil {
                if user != nil {
                    self.openSessionWithTwitter({ err in
                        if err == nil {
                            completion(results: ResultType.Success(r: true))
                        } else {
                            completion(results: ResultType.SystemError(e: err!))
                        }
                    })
                } else {
                    completion(results: ResultType.Error(e: TwitterAccountManagerError.ReturnedEmptyUserObject))
                }
                
            } else {
                completion(results: ResultType.SystemError(e: error!))
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
        
        userDefaults.setValue(authData.uid, forKey: SessionManagerProperty.userID)
        userDefaults.synchronize()
        
        userRef.updateChildValues(data)
        completion(nil)

    }

}

enum TwitterAccountManagerError: ErrorType {
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}
