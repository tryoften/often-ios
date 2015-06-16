//
//  SessionManager.swift
//  Drizzy
//
//  Created by Luc Success on 5/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SessionManager: NSObject {
    
    var firebase: Firebase
    var keyboardService: KeyboardService?
    var trackService: TrackService?
    var userRef: Firebase?
    var currentUser: User?
    var userDefaults: NSUserDefaults
    var currentSession: FBSession?

    private var observers: NSMutableArray
    static let defaultManager = SessionManager()
    
    let permissions = [
        "public_profile",
        "user_actions.music",
        "user_likes"
    ]
    
    init(firebase: Firebase = Firebase(url: BaseURL)) {
        self.firebase = firebase
        self.observers = NSMutableArray()
        self.userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        
        super.init()
        
        
        var artistService = ArtistService(root: self.firebase)
        artistService.requestData { done in
            
        }
        
        var trackService = TrackService(root: self.firebase)
        trackService.requestData { done in
            
        }
        
        
        self.firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
    }
    
    func fetchKeyboards() {
        if let currentUser = currentUser {
            self.keyboardService = KeyboardService(userId: currentUser.id, root: self.firebase)
            self.keyboardService?.requestData({ data in
                self.broadcastDidFetchKeyboardsEvent()
            })
        } else {
            // TODO(luc): throw an error if the current user is not set
        }
    }

    func fetchTracks() {
        self.trackService = TrackService(root: firebase)
        self.trackService?.requestData({ data in
            self.broadcastDidFetchTracksEvent()
        })
        
        self.trackService?.getTracksForArtistId("-Jo284H6WX4QySExfJ5U")
    }
    
    func fetchArtists() {
        
    }
    
    func isUserLoggedIn() -> Bool {
        return !(PFUser.currentUser() == nil)
    }

    private func processAuthData(authData: FAuthData?) {
        if (authData != nil) {
            var uid = authData?.providerData["id"] as! String
            
            self.userRef = firebase.childByAppendingPath("users/\(uid)")
            self.userRef?.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
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
                                    user.fullName = name
                                    user.profileImageLarge = profileImageLarge
                                    user.profileImageSmall = profileImageSmall
                                    user.username = email
                                    user.email = email
                            }
                            
                            self.currentUser = user
                            self.broadcastUserLoginEvent()
                    }
                } else {
                    self.getUserInfo({ (data, err) in
                        self.userRef?.setValue(data)
                        self.currentUser = User(value: data as! [String : AnyObject])
                        self.broadcastUserLoginEvent()
                    })
                }
            })

        } else {
            
        }
    }
    
    private func broadcastUserLoginEvent() {
        for observer in observers {
            observer.sessionManagerDidLoginUser(self, user: self.currentUser!)
        }
    }
    
    private func broadcastDidFetchKeyboardsEvent() {
        if let keyboardService = self.keyboardService {
            for observer in observers {
                observer.sessionManagerDidFetchKeyboards(self, keyboards: keyboardService.keyboards)
            }
        }
    }
    
    private func broadcastDidFetchTracksEvent(){
        if let trackService = self.trackService {
            for observer in observers {
                observer.sessionManagerDidFetchTracks(self, tracks: trackService.tracks)
            }
        }
    }

    private func openSession() {
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) in
            let accessToken = FBSession.activeSession().accessTokenData.accessToken
            println(accessToken)
            self.firebase.authWithOAuthProvider("facebook", token: accessToken,
                withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        println("Login failed. \(error)")
                    } else {
                        println("Logged in! \(authData)")
                    }
            })
            
        })
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
                        
                    } else {
                        
                    }
                }
        }
    }
    
    func getUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        var request = FBRequest.requestForMe()
        
        request.startWithCompletionHandler({ (connection, result, error) in
            
            if error == nil {
                println("\(result)")
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
    
    func login() {
        openSession()
    }
    
    func loginWithEmail(email: String, password: String) {
        PFUser.logInWithUsernameInBackground(email, password: password) { (user, error) in
            
        }
    }
    
    func logout() {
        PFUser.logOut()
    }
    
    func addSessionObserver(observer: SessionManagerObserver) {
        self.observers.addObject(observer)
    }
    
    func removeSessionObserver(observer: SessionManagerObserver) {
        self.observers.removeObject(observer)
    }
}

@objc protocol SessionManagerObserver {
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession)
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User)
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [String: Keyboard])
    func sessionManagerDidFetchTracks(sessionManager: SessionManager, tracks: [String : Track])
    func sessionManagerDidFetchArtists(sessionManager: SessionManager, artists: [String : Artist])
}
