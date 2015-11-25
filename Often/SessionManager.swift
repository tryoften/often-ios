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
    var spotifyAccountManager: SpotifyAccountManager?
    var soundcloudAccountManager: SoundcloudAccountManager?
    var userRef: Firebase?
    var currentUser: User?
    var userDefaults: NSUserDefaults
    var currentSession: FBSession?
    var isUserNew: Bool
    var userIsLoggingIn = false
    
    enum ResultType {
        case Success(r: Bool)
        case Error(e: ErrorType)
        case SystemError(e: NSError)
    }
    
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
        Firebase.defaultConfig().persistenceEnabled = true

        _ = ParseConfig.defaultConfig
        firebase = Firebase(url: BaseURL)
        
        super.init()
        
        spotifyAccountManager = SpotifyAccountManager(firebase: firebase)
        soundcloudAccountManager = SoundcloudAccountManager(firebase:firebase)

        
        firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
        
        if let userID = userDefaults.objectForKey(UserDefaultsProperty.userID) as? String {
            SEGAnalytics.sharedAnalytics().identify(userID)
            let crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(userID)
            
            if let user = currentUser {
                crashlytics.setUserName(user.name)
                crashlytics.setUserEmail(user.email)
            }
        }
        
    }
    
    func setUserDefaultsValue(value:AnyObject, forKey:String ) {
        userDefaults.setValue(false, forKey: forKey)
        userDefaults.synchronize()
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaults.objectForKey(UserDefaultsProperty.userID) != nil
    }
    
    func isUserAnonymous() -> Bool {
        return userDefaults.boolForKey(UserDefaultsProperty.anonymousUser)
    }
    
    func isKeyboardInstalled() -> Bool {
        return userDefaults.boolForKey(UserDefaultsProperty.keyboardInstalled)
    }
    
    func signupUser(loginType: LoginType, data: [String: String], completion: (NSError?) -> ()) {
        emailAccountManager = EmailAccountManager(firebase: firebase)
        do {
            try emailAccountManager?.createUser(data, completion: completion)
            
        } catch {
            
        }
    }
    
    func signupWithAnonymousUser (completion: (results: ResultType) -> Void) {
        let anonymousAccountManager = AnonymousAccountManager(firebase: firebase)
       
        anonymousAccountManager.createAnonymousUser { results -> Void in
            switch results {
            case .Success(let value): completion(results: ResultType.Success(r: value))
            case .Error(let err): completion(results: ResultType.Error(e: err))
            case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
            }
        }
        
    }
    
    func login(loginType: LoginType, completion: (results: ResultType) -> Void) throws {
        userIsLoggingIn = true
        switch loginType {
        case .Twitter:
            twitterAccountManager = TwitterAccountManager(firebase: firebase)
            twitterAccountManager?.login({ results in
                switch results {
                case .Success(let value): completion(results: ResultType.Success(r: value))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            })
            break
        case .Facebook:
            facebookAccountManager = FacebookAccountManager(firebase: firebase)
            facebookAccountManager?.login({ err in
                if err != nil {
                    completion(results: ResultType.SystemError(e: err!))
                } else {
                    completion(results: ResultType.Success(r: true))
                }
            })
            break
        default:
            completion(results: ResultType.Error(e: SessionManagerError.UnvalidSignUp))
            throw SessionManagerError.UnvalidSignUp
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
        userDefaults.setValue(nil, forKey: UserDefaultsProperty.userID)
        userDefaults.setValue(nil, forKey: UserDefaultsProperty.userEmail)
        userDefaults.setValue(nil, forKey: "facebook")
        userDefaults.setValue(nil, forKey: "twitter")
        userDefaults.setValue(nil, forKey: UserDefaultsProperty.openSession)
        userDefaults.setValue(nil, forKey: UserDefaultsProperty.authData)
        userDefaults.setValue(nil, forKey: UserDefaultsProperty.anonymousUser)
        userDefaults.synchronize()
        
        guard let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName) else {
            return
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(directory.path!)
        } catch _ {
        }
    }
    
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user
            
            if !self.isUserNew {
                self.userDefaults.setObject(user.id, forKey: UserDefaultsProperty.userID)
                self.userDefaults.synchronize()
            }
            
            if self.userIsLoggingIn {
                self.broadcastUserLoginEvent()
                self.userIsLoggingIn = false
            }
            self.fetchSocialAccount()
        }
         
        guard let authData = authData, _ = userDefaults.objectForKey(UserDefaultsProperty.openSession) else {
                self.broadcastNoUserFoundEvent()
                logout()
                return
        }
        
        userDefaults.setObject([
            "uid": authData.uid,
            "provider": authData.provider,
            "token": authData.token
        ], forKey: UserDefaultsProperty.authData)
        
        userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        
        userRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
            // TODO(kervs): create user model with data and send event
            if snapshot.exists() {
                if let _ = snapshot.key,
                    let value = snapshot.value as? [String: AnyObject] {
                        let user = User()
                        user.setValuesForKeysWithDictionary(value)
                        user.id = authData.uid
                        self.isUserNew = false
                        self.userIsLoggingIn = true
                        persistUser(user)
                }
            } else {
                if self.userDefaults.boolForKey(UserDefaultsProperty.userEmail) {
                    var data = [String : AnyObject]()
                    
                    if let currentUser = PFUser.currentUser() {
                        data["id"] = authData.uid
                        data["email"] = currentUser.email
                        data["phone"] = currentUser.objectForKey("phone") as? String
                        data["username"] = currentUser.username
                        data["displayName"] = currentUser.objectForKey("fullName") as? String
                        data["name"] = currentUser.objectForKey("fullName") as? String
                        data["parseId"] = currentUser.objectId
                        data["accounts"] = self.createSocialAccount()
                        
                        let newUser = User()
                        newUser.setValuesForKeysWithDictionary(data)
                        
                        self.userRef?.updateChildValues(data)
                        self.isUserNew = false
                        
                        persistUser(newUser)
                    }
                    
                } else {
                    self.broadcastNoUserFoundEvent()
                    self.logout()
                }
            }
            }, withCancelBlock: { error in
                
        })
        
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
                    observer.sessionManagerDidFetchSocialAccounts?(self, socialAccounts: accounts)
                }
            }
        }
    }
    
    private func broadcastUserLoginEvent() {
        if let currentUser = currentUser {
            for observer in observers {
                observer.sessionManagerDidLoginUser?(self, user: currentUser, isNewUser: isUserNew)
            }
        }
    }
    
    private func broadcastNoUserFoundEvent() {
            for observer in observers {
                observer.sessionManagerNoUserFound?(self)
            }
    }
    
}

enum SessionManagerError: ErrorType {
    case UnvalidSignUp
}

enum LoginType {
    case Email
    case Facebook
    case Twitter
}

@objc protocol SessionManagerObserver: class {
    optional func sessionDidOpen(sessionManager: SessionManager, session: FBSession)
    optional func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool)
    optional func sessionManagerNoUserFound(sessionManager: SessionManager)
    optional func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String : AnyObject]?)
}
