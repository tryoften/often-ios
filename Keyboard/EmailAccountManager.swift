//
//  EmailAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class EmailAccountManager: AccountManager {
    var userData: [String: String]?
    
    override func openSession(completion: (results: ResultType) -> Void) {
        guard let _ = userData!["email"],
            let username = userData!["username"],
            let password = userData!["password"] else {
                completion(results: ResultType.Error(e: EmailAccountManagerError.ReturnedEmptyUserObject))
                return
        }

        self.firebase.authUser(username, password: password, withCompletionBlock: { error, authData -> Void in
            if error != nil {
                 completion(results: ResultType.SystemError(e: error!))
                
            } else {
                self.fetchUserData(authData, completion: completion)

            }
        })
        sessionManagerFlags.openSession = true
    }
    
    override func login(data: [String: String]?, completion: (results: ResultType) -> Void) {
        guard let data = data, let email = data["email"],
            let username = data["username"],
            let password = data["password"] else {
                 completion(results: ResultType.Error(e: EmailAccountManagerError.ReturnedEmptyUserObject))
                return
        }

        userData = data

        if isNewUser {
            createUser(data, completion: completion)

        } else {
            PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
                if error == nil {
                    if user != nil {
                        self.openSession(completion)
                    } else {
                        completion(results: ResultType.Error(e: TwitterAccountManagerError.ReturnedEmptyUserObject))
                    }

                } else {
                    completion(results: ResultType.SystemError(e: error!))
                }
            }

        }
    }
    
    func createUser(data: [String: String], completion: (results: ResultType) -> Void) {
        guard let email = data["email"],
            let username = data["username"],
            let password = data["password"] else {
                completion(results: ResultType.Error(e: EmailAccountManagerError.ReturnedEmptyUserObject))
                return
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
                        completion(results: ResultType.SystemError(e: error))
                    } else {
                        self.openSession(completion)
                    }
                })
            } else {
                completion(results: ResultType.SystemError(e: error!))
            }
        }
    }
    
    override func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void) {
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
            completion(results: ResultType.Success(r: true))
            delegate?.userLogin(self)
        }
    }
}

enum EmailAccountManagerError: ErrorType {
    case MissingUserData
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}