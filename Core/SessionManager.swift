//
//  SessionManager.swift
//  Drizzy
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation
import RealmSwift

class SessionManager: NSObject {
    
    var firebase: Firebase
    var keyboardService: KeyboardService?
    var userRef: Firebase?
    var currentUser: User?
    var userDefaults: NSUserDefaults
    var currentSession: FBSession?
    var realm: Realm
    var isUserNew: Bool
    var sentLoginEvent = false

    private var observers: NSMutableArray
    static let defaultManager = SessionManager()
    
    let permissions = [
        "public_profile",
        "user_actions.music",
        "user_likes",
        "email"
    ]
    
    init(rootFirebase: Firebase = Firebase(url: BaseURL)) {
        firebase = rootFirebase
        observers = NSMutableArray()
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        realm = Realm()
        isUserNew = true
        
        super.init()
        
        self.firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
    }
    
    func fetchKeyboards() {
        if let currentUser = currentUser {
            let keyboardService = provideKeyboardService(currentUser.id)
            keyboardService.requestData({ data in
                self.broadcastDidFetchKeyboardsEvent()
            })
        } else {
            // TODO(luc): throw an error if the current user is not set
        }
    }
    
    func setKeyboardsOnCurrentUser(keyboardIds: [String], completion: (User, NSError?) -> ()) {
        if let currentUser = self.currentUser {
            let keyboardService = provideKeyboardService(currentUser.id)

            keyboardService.fetchDataForKeyboardIds(keyboardIds, completion: { keyboards in
                for keyboardId in keyboardIds {
                    keyboardService.keyboardsRef.childByAppendingPath(keyboardId).setValue(true)
                }

                self.realm.write {
                    self.realm.add(currentUser, update: true)
                }

                completion(currentUser, nil)
            })
        }
    }

    func isUserLoggedIn() -> Bool {
        return !(PFUser.currentUser() == nil)
    }
    
    func signUpUser(data: [String: String]) {
        if let email = data["email"],
            let username = data["username"],
            let password = data["password"] {
                
                var user = PFUser()
                user.email = email
                user.username = email
                user.password = password
                
                if let phone = data["phone"] {
                    user["phone"] = phone
                }
                
                user.signUpInBackgroundWithBlock { (success, error) in
                    if error == nil {
                        self.loginWithUsername(email, password: password)
                    } else {
                        
                    }
                }
        }
    }
    
    func openSession() {
        if let accessToken = FBSession.activeSession().accessTokenData.accessToken {
            firebase.authWithOAuthProvider("facebook", token: accessToken,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        println("Login failed. \(error)")
                    } else {
                        println("Logged in! \(authData)")
                    }
            })
        }
    }
    
    func login(completion: ((PFUser?, NSError?) -> ())? = nil) {
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) in
            completion?(user, error)
            if error == nil {
                self.openSession()
            }
        })
    }
    
    func loginWithUsername(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            self.openSession()
        }
    }
    
    func logout() {
        PFUser.logOut()
        firebase.unauth()
        observers.removeAllObjects()
        
        let realm = Realm()
        realm.write {
            realm.deleteAll()
        }
    }
    
    func addSessionObserver(observer: SessionManagerObserver) {
        self.observers.addObject(observer)
    }
    
    func removeSessionObserver(observer: SessionManagerObserver) {
        self.observers.removeObject(observer)
    }
    
    // MARK: Private methods
    
    private func provideKeyboardService(userId: String) -> KeyboardService {
        if let keyboardService = self.keyboardService {
            return keyboardService
        }

        var keyboardService = KeyboardService(userId: userId, root: self.firebase, realm: self.realm)
        self.keyboardService = keyboardService

        return keyboardService
    }
    
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user
            
            if !self.isUserNew {
                self.realm.write {
                    self.realm.add(user, update: true)
                }
            }
            if !self.sentLoginEvent {
                self.broadcastUserLoginEvent()
                self.sentLoginEvent = true
            }
        }
        
        if let authData = authData,
            let uid = authData.providerData["id"] as? String {
            
            userRef = firebase.childByAppendingPath("users/\(uid)")
            userRef?.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                // TODO(luc): create user model with data and send event
                if snapshot.exists() {
                    if let id = snapshot.key,
                        let value = snapshot.value as? [String: AnyObject] {
                            let user = User()
                            user.id = id
                            
                            if  let name = value["name"] as? String,
                                let profileImageSmall = value["profile_pic_small"] as? String,
                                let profileImageLarge = value["profile_pic_large"] as? String,
                                let email = value["email"] as? String {
                                    user.name = name
                                    user.profileImageLarge = profileImageLarge
                                    user.profileImageSmall = profileImageSmall
                                    user.username = email
                                    user.email = email
                            }
                            self.isUserNew = false
                            persistUser(user)
                    }
                } else {
                    self.getFacebookUserInfo({ (data, err) in
                        if err == nil {
                            self.userRef?.setValue(data)
                            self.isUserNew = true
                            persistUser(User(value: data as! [String : AnyObject]))
                        }
                    })
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
                
                self.userDefaults.setObject(userId, forKey: "userId")
                self.userDefaults.setObject(data, forKey: "user")
                
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
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [String: Keyboard])
}
