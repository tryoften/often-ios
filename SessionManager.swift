//
//  SessionManager.swift
//  Often
//
//  Created by Kervins Valcourt on 8/14/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import Crashlytics

class SessionManager: NSObject {
    var firebase: Firebase
    var socialAccountService: SocialAccountsService?
    var userRef: Firebase?
    var currentUser: User?
    var userDefaults: NSUserDefaults
    var currentSession: FBSession?
    var isUserNew: Bool
    var userIsLoggingIn = false
    
    private var observers: NSMutableArray
    static let defaultManager = SessionManager()
    
    let permissions = [
        "public_profile",
        "user_actions.music",
        "user_likes",
        "email"
    ]
    
    override init() {
        observers = NSMutableArray()
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        isUserNew = true
        
        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Service_Loaded")
        Flurry.startSession(FlurryClientKey)
        Firebase.defaultConfig().persistenceEnabled = true
        
        firebase = Firebase(url: BaseURL)
        socialAccountService = SocialAccountsService(root: firebase)
        
        super.init()
        
        firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
        
        if let user = userDefaults.objectForKey("user") as? User {
            SEGAnalytics.sharedAnalytics().identify(user.id)
            currentUser = user
            var crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(user.id)
            if let user = currentUser {
                crashlytics.setUserName(user.username)
                crashlytics.setUserEmail(user.email)
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "writeDatabasetoDisk", name: "database:persist", object: nil)
    }
   
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user
        
            if !self.isUserNew {
                self.userDefaults.setObject(user, forKey: "user")
                self.userDefaults.synchronize()
            }
            
            if self.userIsLoggingIn {
                self.broadcastUserLoginEvent()
                self.userIsLoggingIn = false
            }
        }
        
        if let authData = authData,
            let uid = PFUser.currentUser()?.objectId {
                
                userDefaults.setObject([
                    "uid": authData.uid,
                    "provider": authData.provider,
                    "token": authData.token
                    ], forKey: "authData")
                
                userRef = firebase.childByAppendingPath("users/\(authData.uid)")
                userRef?.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                    // TODO(luc): create user model with data and send event
                    if snapshot.exists() {
                        if let id = snapshot.key,
                            let value = snapshot.value as? [String: AnyObject] {
                                var user = User()
                                user.setValuesForKeysWithDictionary(value)
                                user.id = authData.uid
                                self.isUserNew = false
                                persistUser(user)
                        }
                    } else {
                        var checkString = "facebook"
                        
                        if authData.uid.rangeOfString(checkString) == nil {
                            
                            var data = [String : String]()
                            
                            data["id"] = authData.uid
                            data["email"] = PFUser.currentUser()?.email
                            data["phone"] = PFUser.currentUser()?.objectForKey("phone") as? String
                            data["username"] = PFUser.currentUser()?.username
                            data["name"] = PFUser.currentUser()?.objectForKey("fullName") as? String
                            data["backgroundImage"] = "user-profile-bg-\(arc4random_uniform(4) + 1)"
                            data["parseId"] = uid
                            
                            self.userDefaults.setObject(authData.uid, forKey: "userId")
                            self.userDefaults.synchronize()
                            
                            self.userRef?.setValue(data)
                            self.isUserNew = true
                            
                            var user = User()
                            user.setValuesForKeysWithDictionary(data)
                            persistUser(user)
                            
                            
                        } else {
                            self.getFacebookUserInfo({ (data, err) in
                                if err == nil {
                                    var newData = data as! [String : AnyObject]
                                    newData["provider"] = authData.uid
                                    newData["id"] = PFUser.currentUser()?.objectId
                                    
                                    self.userRef?.setValue(newData)
                                    self.isUserNew = true
                                    var user = User()
                                    user.setValuesForKeysWithDictionary(newData)
                                    persistUser(user)
                                }
                            })
                        }
                    }
                    }, withCancelBlock: { error in
                        
                })
                
        } else {
            
        }
    }
    
    private func getFacebookUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler({ (connection, result, error) in
            
            if error == nil {
                var data = (result as! NSDictionary).mutableCopy() as! NSMutableDictionary
                var userId = data["id"] as! String
                var profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"
                
                data["profile_pic_small"] = String(format: profilePicURLTemplate, userId, "small")
                data["profile_pic_large"] = String(format: profilePicURLTemplate, userId, "large")
                data["backgroundImage"] = "user-profile-bg-\(arc4random_uniform(4) + 1)"
                
                completion(data, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaults.objectForKey("user") != nil
    }
    
    private func broadcastUserLoginEvent() {
        if let currentUser = currentUser {
            for observer in observers {
                if observer.respondsToSelector("sessionManagerDidLoginUser:user:isNewUser:") {
                    observer.sessionManagerDidLoginUser(self, user: currentUser, isNewUser: isUserNew)
                }
            }
        }
    }
}


@objc protocol SessionManagerObserver: class {
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession)
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool)
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, SocialAccounts: [SocialAccount])
}
