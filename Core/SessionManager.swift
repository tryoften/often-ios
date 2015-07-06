//
//  SessionManager.swift
//  Drizzy
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class SessionManager: NSObject {
    
    var firebase: Firebase
    var keyboardService: KeyboardService?
    var artistService: ArtistService
    var userRef: Firebase?
    var currentUser: User?
    var userDefaults: NSUserDefaults
    var currentSession: FBSession?
    var realm: Realm
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
        realm = Realm()
        isUserNew = true
        
        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Keyboard_Loaded")
        Flurry.startSession(FlurryClientKey)
        Firebase.defaultConfig().persistenceEnabled = true

        firebase = Firebase(url: BaseURL)
        artistService = ArtistService(root: firebase, realm: realm)

        super.init()
        
        firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
        
        if let userId = userDefaults.stringForKey("userId") {
            SEGAnalytics.sharedAnalytics().identify(userId)
            currentUser = realm.objectForPrimaryKey(User.self, key: userId)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "writeDatabasetoDisk", name: "database:persist", object: nil)
    }
    
    func fetchKeyboards() {
        if let currentUser = currentUser {
            let keyboardService = provideKeyboardService(currentUser)
            keyboardService.requestData({ data in
                self.broadcastDidFetchKeyboardsEvent()
            })
        } else {
            // TODO(luc): throw an error if the current user is not set
        }
    }
    
    func setKeyboardsOnCurrentUser(keyboardIds: [String], completion: (User, NSError?) -> ()) {
        if let currentUser = self.currentUser {
            let keyboardService = provideKeyboardService(currentUser)

            keyboardService.fetchDataForKeyboardIds(keyboardIds, completion: { keyboards in
                for keyboardId in keyboardIds {
                    keyboardService.keyboardsRef.childByAppendingPath(keyboardId).setValue(true)
                }
                
                self.realm.write {
                    for keyboard in keyboards {
                        keyboard.user = currentUser
                    }
                    self.realm.add(keyboards, update: true)
                    self.realm.add(currentUser, update: true)
                }

                completion(currentUser, nil)
            })
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaults.objectForKey("userId") != nil
    }
    
    func writeDatabasetoDisk() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName)!
            let path = directory.path!.stringByAppendingPathComponent("keyboard.realm")
            let realm = Realm()
            realm.writeCopyToPath(path, encryptionKey: nil)
        }
    }
    
    func signUpUser(data: [String: String], completion: (NSError?) -> ()) {
        if let email = data["email"],
            let username = data["username"],
            let password = data["password"],
            let fullName = data["name"]{
                
                var user = PFUser()
                user.email = email
                user.username = email
                user.password = password
                user["fullName"] = fullName
                user["isFacebook"] = false
                
                if let phone = data["phone"] {
                    user["phone"] = phone
                }
                
                user.signUpInBackgroundWithBlock { (success, error) in
                    if error == nil {
                        self.firebase.createUser(username, password: password, withValueCompletionBlock: { error, result -> Void in
                            if error != nil {
                                println("Login failed. \(error)")
                            } else {
                                println("Logged in! \(result)")
                                self.openSession(username,password:password)
                            }
                        })
                        completion(nil)
                    } else {
                        completion(error)
                    }
                }
        }
    }

    func openSession(username: String?, password: String?) {
        if let username = username, let password = password {
            self.firebase.authUser(username, password: password, withCompletionBlock: { error, authData -> Void in
                if error != nil {
                    println("logged in")
                } else {
                    println(error)
                }
            })
        } else {
            if let accessToken = FBSession.activeSession().accessTokenData.accessToken {
                firebase.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            println("Login failed. \(error)")
                        } else {
                            println( "Login failed. \(authData.providerData)")
                        }
                })
            }
        }
        userDefaults.setValue(true, forKey: "openSession")
        
    }
    
    func login(completion: ((PFUser?, NSError?) -> ())? = nil) {
        userIsLoggingIn = true
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) in
            completion?(user, error)
            if error == nil {
                self.openSession(nil,password: nil)
            }
        })
    }
    
    func loginWithUsername(username: String, password: String) {
        userIsLoggingIn = true

        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if user != nil {
                self.openSession(username, password: password)
            } else {
                println(error)
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
        firebase.unauth()
        observers.removeAllObjects()
        userDefaults.setValue(nil, forKey: "userId")
        userDefaults.setValue(nil, forKey: "openSession")
        userDefaults.setValue(nil, forKey: "authData")
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName)!
        
        NSFileManager.defaultManager().removeItemAtPath(directory.path!, error: nil)
    }
    
    func addSessionObserver(observer: SessionManagerObserver) {
        self.observers.addObject(observer)
    }
    
    func removeSessionObserver(observer: SessionManagerObserver) {
        self.observers.removeObject(observer)
    }
    
    func provideKeyboardService() -> KeyboardService? {
        if let user = currentUser {
            return provideKeyboardService(user)
        }
        return nil
    }
    
    func provideArtistService() -> ArtistService? {
        return nil
    }
    
    // MARK: Private methods
    
    private func provideKeyboardService(user: User) -> KeyboardService {
        if let keyboardService = self.keyboardService {
            return keyboardService
        }

        var keyboardService = KeyboardService(user: user, root: self.firebase, realm: self.realm, artistService: artistService)
        self.keyboardService = keyboardService

        return keyboardService
    }
    
    
    
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user
            self.userDefaults.setObject(user.id, forKey: "userId")
            self.userDefaults.synchronize()
            
            if !self.isUserNew {
                self.realm.write {
                    self.realm.add(user, update: true)
                }
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
                
                userRef = firebase.childByAppendingPath("users/\(uid)")
                userRef?.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                    // TODO(luc): create user model with data and send event
                    if snapshot.exists() {
                        if let id = snapshot.key,
                            let value = snapshot.value as? [String: AnyObject] {
                                var user = User()
                                user.setValuesForKeysWithDictionary(value)
                                self.isUserNew = false
                                persistUser(user)
                        }
                    } else {
                        var checkString = "facebook"
                        
                        if authData.uid.rangeOfString(checkString) == nil {
                            
                            var data = [String : String]()
                            
                            data["id"] = PFUser.currentUser()?.objectId
                            data["provider"] = authData.uid
                            data["email"] = PFUser.currentUser()?.email
                            data["phone"] = PFUser.currentUser()?.objectForKey("phone") as? String
                            data["username"] = PFUser.currentUser()?.username
                            data["name"] = PFUser.currentUser()?.objectForKey("fullName") as? String
                            data["backgroundImage"] = "user-profile-bg-\(arc4random_uniform(4) + 1)"
                            
                            self.userDefaults.setObject(PFUser.currentUser()?.objectId, forKey: "userId")
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
    
    private func broadcastUserLoginEvent() {
        if let currentUser = currentUser {
            for observer in observers {
                if observer.respondsToSelector("sessionManagerDidLoginUser:user:isNewUser:") {
                    observer.sessionManagerDidLoginUser(self, user: currentUser, isNewUser: isUserNew)
                }
            }
        }
    }
    
    private func broadcastDidFetchKeyboardsEvent() {
        if let keyboardService = self.keyboardService {
            for observer in observers {
                observer.sessionManagerDidFetchKeyboards(self, keyboards: keyboardService.keyboards)
            }
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
                
                
                self.userDefaults.setObject(PFUser.currentUser()?.objectId, forKey: "userId")
                self.userDefaults.synchronize()

                completion(data, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
}

@objc protocol SessionManagerObserver: class {
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession)
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool)
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [Keyboard])
}

