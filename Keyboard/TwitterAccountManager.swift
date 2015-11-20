//
//  TwitterAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class TwitterAccountManager: AccountManager {
    let sessionManager = SessionManager.defaultManager
    var userRef: Firebase?
    
    func openSessionWithTwitter(completion: (results: ResultType) -> Void) {
        guard let userId = PFTwitterUtils.twitter()?.userId, twitterToken = PFTwitterUtils.twitter()?.authToken else {
            completion(results: ResultType.Error(e: TwitterAccountManagerError.ReturnedEmptyUserObject))
            return
        }
        
        let twitterAuth = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        twitterAuth.setValue([
            "task": "createToken",
            "user": "twitter:\(userId)",
            "data": ["token": twitterToken]
            ])
    
        
        userRef = firebase.childByAppendingPath("users/twitter:\(userId)")
        
        
        userRef?.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? [String: AnyObject] {
                    self.firebase.authWithCustomToken(value["auth_token"] as? String, withCompletionBlock: { (err, aut ) -> Void in
                        self.userRef?.removeAllObservers()
                        if err == nil {
                            self.getTwitterUserInfo(completion)
                        } else {
                             completion(results: ResultType.Error(e: TwitterAccountManagerError.ReturnedEmptyUserObject))
                        }
                    })
                    
                }
            }
        })
        
        userDefaults.setValue(true, forKey: UserDefaultsProperty.openSession)
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
                    self.openSessionWithTwitter(completion)
                } else {
                    completion(results: ResultType.Error(e: TwitterAccountManagerError.ReturnedEmptyUserObject))
                }
                
            } else {
                completion(results: ResultType.SystemError(e: error!))
            }
        })
    }
    
    func getTwitterUserInfo(completion: (results: ResultType) -> Void) {
        func parseUserData(data: AnyObject) {
            if let userdata = data as? [String: AnyObject] {
                var firebaseData = [String: AnyObject]()
                var socialAccounts = sessionManager.createSocialAccount()
                
                if let accessToken = PFTwitterUtils.twitter()?.authToken {
                    let twitter = SocialAccount()
                    twitter.type = .Twitter
                    twitter.activeStatus = true
                    twitter.token = accessToken
                    socialAccounts.updateValue(twitter.toDictionary(), forKey: "twitter")
                }
                
                let urlString = userdata["profile_image_url_https"] as? String
                let hiResUrlString = urlString?.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                
                firebaseData["accounts"] = socialAccounts
                firebaseData["id"] = PFTwitterUtils.twitter()?.authToken
                firebaseData["profileImageURL"] = hiResUrlString
                firebaseData["name"] = userdata["name"] as! String
                firebaseData["username"] = userdata["screen_name"] as? String
                firebaseData["description"] = userdata["description"] as? String
                firebaseData["parseId"] = PFUser.currentUser()?.objectId
                
                if let userID = PFTwitterUtils.twitter()?.userId {
                    
                    userDefaults.setValue("twitter:\(userID)", forKey: UserDefaultsProperty.userID)
                    userDefaults.synchronize()
                    
                    userRef?.updateChildValues(firebaseData)
                    completion(results: ResultType.Success(r: true))
                    
                }
            }
        }
        
        let verify = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
        let request = NSMutableURLRequest(URL: verify!)
        PFTwitterUtils.twitter()?.signRequest(request)
        var response: NSURLResponse?
        
        do {
        let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        parseUserData(result)
            
        } catch {
            completion(results: ResultType.Error(e: TwitterAccountManagerError.ReturnedNoTwitterData))
        }
        
        
    }

}

enum TwitterAccountManagerError: ErrorType {
    case ReturnedEmptyUserObject
    case NotConnectedOnline
    case ReturnedNoTwitterData
}
