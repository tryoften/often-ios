//
//  EmailAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class EmailAccountManager: AccountManager {
    
    
    func openSessionWithEmail(username: String, password: String, completion: ((NSError?) -> ())? = nil) {
        self.firebase.authUser(username, password: password, withCompletionBlock: { error, authData -> Void in
            if error != nil {
                print(error)
                completion?(error)
                
            } else {
                self.getUserInfo(authData, completion: completion)

            }
        })
        sessionManagerFlags.openSession = true
    }
    
    func loginWithUsername(username: String, password: String, completion: (NSError?) -> ()) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if user != nil {
                self.openSessionWithEmail(username, password: password, completion:completion)
            } else {
                completion(error)
            }
        }
    }
    
    func createUser( data: [String: String], completion: ((NSError?) -> ())? = nil) throws {
        guard let email = data["email"],
            let username = data["username"],
            let password = data["password"] else {
                throw EmailAccountManagerError.MissingUserData
        }
        
        let user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        user["fullName"] = username
        
        user.signUpInBackgroundWithBlock { (success, error) in
            if error == nil {
                self.firebase.createUser(email, password: password, withValueCompletionBlock: { error, result -> Void in
                    if error != nil {
                        print("Login failed. \(error)")
                        completion?(error)
                    } else {
                        print("Logged in! \(result)")
                        self.openSessionWithEmail(email, password: password, completion:completion)
                    }
                })
                completion?(nil)
            } else {
                completion?(error)
            }
        }
    }
    
    func getUserInfo(authData: FAuthData, completion: ((NSError?) -> ())? = nil) {
        userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        sessionManagerFlags.userId = authData.uid
        
        var data = [String : AnyObject]()
        
        if let currentUser = PFUser.currentUser() {
            data["id"] = authData.uid
            data["email"] = currentUser.email
            data["phone"] = currentUser.objectForKey("phone") as? String
            data["username"] = currentUser.username
            data["displayName"] = currentUser.objectForKey("fullName") as? String
            data["name"] = currentUser.objectForKey("fullName") as? String
            data["parseId"] = currentUser.objectId
            data["accounts"] = SessionManager.defaultManager.createSocialAccount()
            
            let newUser = User()
            newUser.setValuesForKeysWithDictionary(data)
            
            self.userRef?.updateChildValues(data)
            completion?(nil)
        }
    }
}

enum EmailAccountManagerError: ErrorType {
    case MissingUserData
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}