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
    var userRef: Firebase?
    var currentUser: User?
    
    init(firebase: Firebase = Firebase(url: BaseURL)) {
        self.firebase = firebase
        
        super.init()
        
        self.firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
    }
    
    private func processAuthData(authData: FAuthData?) {
        if (authData != nil) {
            var uid = authData?.providerData["id"] as! String
            
            self.userRef = firebase.childByAppendingPath("users/\(uid)")
            
            self.userRef?.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                // TODO create user model with data and send event
                if snapshot.exists() {
                    if let value = snapshot.value as? [String: AnyObject] {
                        self.currentUser = User(data: value)
                    }
                } else {
                    self.getUserInfo({ (data, err) in
                        self.userRef?.setValue(data)
                        self.currentUser = User(data: data as! [String : AnyObject])
                    })
                }
            })

        } else {
            
        }
    }

    private func openSession() {
        FBSession.openActiveSessionWithReadPermissions(["public_profile", "user_actions.music", "user_likes"], allowLoginUI: true,
            completionHandler: { session, state, error in
                
                if error != nil {
                    println("Facebook login failed. Error \(error)")
                } else if state == FBSessionState.Open {
                    println("Session: \(session)")
                    let accessToken = session.accessTokenData.accessToken
                    
                    self.firebase.authWithOAuthProvider("facebook", token: accessToken,
                        withCompletionBlock: { error, authData in
                            
                            if error != nil {
                                println("Login failed. \(error)")
                            } else {
                                println("Logged in! \(authData)")
                            }
                    })
                    
                }
                
        })
    }
    
    func getUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        var request = FBRequest.requestForMe()
        
        request.startWithCompletionHandler({ (connection, result, error) in
            
            if error == nil {
                println("\(result)")
                var data = (result as! NSDictionary).mutableCopy() as! NSMutableDictionary
                var profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"
                
                data["profile_pic_small"] = String(format: profilePicURLTemplate, data["id"] as! String, "small")
                data["profile_pic_large"] = String(format: profilePicURLTemplate, data["id"] as! String, "large")
                
                completion(data, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
    
    func login() {
        openSession()
    }
    
    func logout() {
        
    }
}
