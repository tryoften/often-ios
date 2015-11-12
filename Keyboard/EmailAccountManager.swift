//
//  EmailAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class EmailAccountManager: NSObject {
    var firebase: Firebase
    var userDefaults: NSUserDefaults
    
    init(firebase: Firebase) {
        self.firebase = firebase
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        
        super.init()
    }
    
    func openSessionWithEmail(username: String, password: String, completion: ((NSError?) -> ())? = nil) {
        userDefaults.setValue(true, forKey: UserDefaultsProperty.userEmail)
        self.firebase.authUser(username, password: password, withCompletionBlock: { error, authData -> Void in
            if error != nil {
                print(error)
                completion?(error)
                
            } else {
                self.userDefaults.setValue(authData.uid, forKey: UserDefaultsProperty.userID)
                self.userDefaults.synchronize()
                completion?(nil)
            }
        })
        userDefaults.setValue(true, forKey: UserDefaultsProperty.openSession)
        userDefaults.synchronize()
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
}

enum EmailAccountManagerError: ErrorType {
    case MissingUserData
}