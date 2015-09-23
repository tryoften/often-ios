//
//  SessionManager.swift
//  Often
//
//  Created by Kervins Valcourt on 8/14/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import Crashlytics

class SessionManager: NSObject {
    var firebase: Firebase
    var socialAccountService: SocialAccountsService?
    var twitterAccountManager: TwitterAccountManager?
    var facebookAccountManager: FacebookAccountManager?
    var emailAccountManager: EmailAccountManager?
    var userRef: Firebase?
    var currentUser: User?
    var userDefaults: NSUserDefaults
    var currentSession: FBSession?
    var isUserNew: Bool
    var userIsLoggingIn = false
    
    private var observers: NSMutableArray
    static let defaultManager = SessionManager()
    
    override init() {
        observers = NSMutableArray()
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        isUserNew = true
        
        let configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Service_Loaded")
        Flurry.startSession(FlurryClientKey)
        
        firebase = Firebase(url: BaseURL)
        
        super.init()
        
        firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
        
        if let userData = userDefaults.objectForKey("user") as? [String:String] {
            currentUser = User()
            currentUser?.setValuesForKeysWithDictionary(userData)
            SEGAnalytics.sharedAnalytics().identify(currentUser!.id)
            socialAccountService = SocialAccountsService(user: currentUser!, root: firebase)
            let crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(currentUser!.id)
            
            if let user = currentUser {
                crashlytics.setUserName(user.name)
                crashlytics.setUserEmail(user.email)
            }
        }
        
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaults.objectForKey("user") != nil
    }
    
    func signupUser(loginType: LoginType, data: [String: String], completion: (NSError?) -> ()) {
        emailAccountManager = EmailAccountManager(firebase: firebase)
        emailAccountManager?.createUser(data, completion: completion)
    }
    
    func login(loginType: LoginType, completion: ((NSError?) -> ())? = nil) {
        userIsLoggingIn = true
        switch loginType {
        case .Twitter:
            twitterAccountManager = TwitterAccountManager(firebase: firebase)
            twitterAccountManager?.login(completion)
            break
        case .Facebook:
            facebookAccountManager = FacebookAccountManager(firebase: firebase)
            facebookAccountManager?.login(completion)
            break
        default:
//            completion?(NSError())
            break
        }
    }
    
    func loginWithUsername(username: String, password: String,completion: (NSError?) -> ()) {
        userIsLoggingIn = true
        emailAccountManager = EmailAccountManager(firebase: firebase)
        emailAccountManager?.loginWithUsername(username, password: password, completion: completion)
    }
    
    
    func logout() {
        PFUser.logOut()
        firebase.unauth()
        observers.removeAllObjects()
        userDefaults.setValue(nil, forKey: "user")
        userDefaults.setValue(nil, forKey: "email")
        userDefaults.setValue(nil, forKey: "facebook")
        userDefaults.setValue(nil, forKey: "twitter")
        userDefaults.setValue(nil, forKey: "openSession")
        userDefaults.setValue(nil, forKey: "authData")
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName)!
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(directory.path!)
        } catch _ {
        }
    }
    
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user
            
            if !self.isUserNew {
                self.userDefaults.setObject(user.dataChangedToDictionary(), forKey: "user")
                self.userDefaults.synchronize()
            }
            
            if self.userIsLoggingIn {
                self.broadcastUserLoginEvent()
                self.userIsLoggingIn = false
            }
            self.fetchSocialAccount()
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
                    // TODO(kervs): create user model with data and send event
                    if snapshot.exists() {
                        if let id = snapshot.key,
                            let value = snapshot.value as? [String: AnyObject] {
                                let user = User()
                                user.setValuesForKeysWithDictionary(value)
                                user.id = authData.uid
                                self.isUserNew = false
                                persistUser(user)
                        }
                    } else {
                        if (self.userDefaults.boolForKey("email") == true) {
                            var data = [String : AnyObject]()
                            
                            data["id"] = authData.uid
                            data["email"] = PFUser.currentUser()?.email
                            data["phone"] = PFUser.currentUser()?.objectForKey("phone") as? String
                            data["username"] = PFUser.currentUser()?.username
                            data["displayName"] = PFUser.currentUser()?.objectForKey("fullName") as? String
                            data["name"] = PFUser.currentUser()?.objectForKey("fullName") as? String
                            data["parseId"] = uid
                            data["accounts"] = self.createSocialAccount()
                            
                            let newUser = User()
                            newUser.setValuesForKeysWithDictionary(data)
                            
                            self.userRef?.setValue(data)
                            self.isUserNew = false
                            
                            persistUser(newUser)
                            
                        }
                    }
                    }, withCancelBlock: { error in
                        
                })
                
        } else {
            
        }
    }
    
    func createSocialAccount() -> [String:AnyObject] {
        var socialAccounts = [String:AnyObject]()
        
        let twitter = SocialAccount()
        twitter.type = .Twitter
        socialAccounts.updateValue(twitter.toDictionary(), forKey: "twitter")
        
        let spotify = SocialAccount()
        spotify.type = .Spotify
        socialAccounts.updateValue(spotify.toDictionary(), forKey: "spotify")
        
        let soundcloud = SocialAccount()
        soundcloud.type = .Soundcloud
        socialAccounts.updateValue(soundcloud.toDictionary(), forKey: "soundcloud")
        
        let venmo = SocialAccount()
        venmo.type = .Venmo
        socialAccounts.updateValue(venmo.toDictionary(), forKey: "venmo")
        
        return socialAccounts
    }
    
    func setSocialAccountOnCurrentUser(socialAccount:SocialAccount, completion: (User, NSError?) -> ()) {
        if let currentUser = self.currentUser {
            let socialAccountService = provideSocialAccountService(currentUser)
            socialAccountService.updateSocialAccount(socialAccount)
            completion(currentUser, nil)
        }
    }
    
    func fetchSocialAccount() {
        if let currentUser = currentUser {
            let socialAccountService = provideSocialAccountService(currentUser)
            socialAccountService.fetchLocalData({ err  in
                if err  {
                    self.broadcastDidFetchSocialAccountsEvent()
                }
            })
        } else {
            // TODO(kervs): throw an error if the current user is not set
        }
    }
    
    // MARK: Private methods
    
    private func provideSocialAccountService(user: User) -> SocialAccountsService {
        if let socialService = self.socialAccountService {
            return socialService
        }
        
        let socialAccountService = SocialAccountsService(user: user, root:firebase)
        self.socialAccountService = socialAccountService
        
        return socialAccountService
    }
    
    func addSessionObserver(observer: SessionManagerObserver) {
        self.observers.addObject(observer)
    }
    
    func removeSessionObserver(observer: SessionManagerObserver) {
        self.observers.removeObject(observer)
    }
    
    private func broadcastDidFetchSocialAccountsEvent() {
        if let socialAccountService = self.socialAccountService {
            for observer in observers {
                if let accounts = socialAccountService.socialAccounts {
                    observer.sessionManagerDidFetchSocialAccounts(self, socialAccounts: accounts)
                }
            }
        }
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

enum LoginType {
    case Email
    case Facebook
    case Twitter
}

@objc protocol SessionManagerObserver: class {
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession)
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool)
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String : AnyObject])
}
