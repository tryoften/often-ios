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
        
        super.init()
        
        firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }

        if let userData = userDefaults.objectForKey("user") as? [String:String] {
            currentUser = User()
            currentUser?.setValuesForKeysWithDictionary(userData)
            SEGAnalytics.sharedAnalytics().identify(currentUser!.id)
            socialAccountService = SocialAccountsService(user: currentUser!, root: firebase)
            var crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(currentUser!.id)
            
            if let user = currentUser {
                crashlytics.setUserName(user.username)
                crashlytics.setUserEmail(user.email)
            }
        }
        
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaults.objectForKey("user") != nil
    }
    
    func signupUser(loginType: LoginType, data: [String: String], completion: (NSError?) -> ()) {
        if let email = data["email"],
            let username = data["username"],
            let password = data["password"] {
                
                var user = PFUser()
                user.email = email
                user.username = email
                user.password = password
                
                            
                user.signUpInBackgroundWithBlock { (success, error) in
                    if error == nil {
                        self.firebase.createUser(email, password: password, withValueCompletionBlock: { error, result -> Void in
                            if error != nil {
                                println("Login failed. \(error)")
                            } else {
                                println("Logged in! \(result)")
                                self.openSession(loginType, username: email, password: password)
                            }
                        })
                        completion(nil)
                    } else {
                        completion(error)
                    }
                }
        }
    }
    
    func login(loginType: LoginType, completion: ((PFUser?, NSError?) -> ())? = nil) {
        userIsLoggingIn = true
        switch loginType {
        case .Twitter:
            PFTwitterUtils.logInWithBlock({ (user, error) in
                if error == nil {
                    println(user)
                    self.openSession(loginType, username:nil, password: nil, completion: { sessionError in
                        if sessionError != nil {
                            completion?(nil, sessionError)
                        } else {
                            completion?(user, error)
                        }
                    })
                } else {
                    completion?(nil, error)
                }
            })
            break
        case .Facebook:
            PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) in
                if error == nil {
                    self.openSession(loginType, username:nil, password: nil, completion: { sessionError in
                        if sessionError != nil {
                            completion?(nil, sessionError)
                        } else {
                            completion?(user, error)
                        }
                    })
                } else {
                    completion?(nil, error)
                }
            })
            break
        default:
            completion?(nil, NSError())
            break
        }
    }
    
    func loginWithUsername(username: String, password: String,completion: (NSError?) -> ()) {
        userIsLoggingIn = true
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if user != nil {
                self.openSession(.Email, username: username, password: password)
            } else {
                completion(error)
            }
        }
    }

    
    func openSession(loginType: LoginType, username: String?, password: String?, completion: ((NSError?) -> ())? = nil) {
        switch loginType {
        case .Twitter:
            userDefaults.setValue(true, forKey: "twitter")
            
            twitterAccountManager = TwitterAccountManager(firebase: firebase)
            twitterAccountManager?.openSessionWithTwitter(completion: completion)
            
            break
        case .Email:
            userDefaults.setValue(true, forKey: "email")
            if let username = username, let password = password {
                emailAccountManager = EmailAccountManager(firebase: firebase)
                emailAccountManager?.openSessionWithEmail(username, password: password, completion: completion)
            }
            
            break
        case .Facebook:
            userDefaults.setValue(true, forKey: "facebook")
            
            facebookAccountManager = FacebookAccountManager(firebase: firebase)
            facebookAccountManager?.openSessionWithFacebook(completion: completion)
            
            break
        default:
            break
        }
        userDefaults.setValue(true, forKey: "openSession")
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
        
        NSFileManager.defaultManager().removeItemAtPath(directory.path!, error: nil)
    }
    
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user
        
            if !self.isUserNew {
                self.userDefaults.setObject([
                    "id": user.id,
                    "name": user.name,
                    "profileImageSmall": user.profileImageSmall,
                    "profileImageLarge": user.profileImageLarge,
                    "username": user.username,
                    "email": user.email,
                    "phone": user.phone,
                    "backgroundImage": user.name,
                    "description": user.userDescription
                    ], forKey: "user")
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
                                var user = User()
                                user.setValuesForKeysWithDictionary(value)
                                user.id = authData.uid
                                self.isUserNew = false
                                persistUser(user)
                    }
                    } else {
                        if (authData.uid.rangeOfString("twitter") == nil || authData.uid.rangeOfString("facebook") == nil) {
                            var data = [String : String]()
                            
                            data["id"] = authData.uid
                            data["email"] = PFUser.currentUser()?.email
                            data["phone"] = PFUser.currentUser()?.objectForKey("phone") as? String
                            data["username"] = PFUser.currentUser()?.username
                            data["displayName"] = PFUser.currentUser()?.objectForKey("fullName") as? String
                            data["name"] = PFUser.currentUser()?.objectForKey("fullName") as? String
                            data["parseId"] = uid
                            
                            self.userRef?.setValue(data)
                            self.isUserNew = false
                            
                            var user = User()
                            user.setValuesForKeysWithDictionary(data)
                            persistUser(user)
                            
                        }
                    }
                    }, withCancelBlock: { error in
                        
                })
                
        } else {
            
        }
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
                if err {
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
        
        var socialAccountService = SocialAccountsService(user: user, root:firebase)
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
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [SocialAccount])
}
