//
//  EmailAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class EmailAccountManager: AccountManager {

    override func openSession(completion: (results: ResultType) -> Void) {
        guard let email = newUser?.email,
            let password = newUser?.password else {
                completion(results: ResultType.Error(e: EmailAccountManagerError.ReturnedEmptyUserObject))
                return
        }
        
        self.firebase.authUser(email, password: password, withCompletionBlock: { error, authData -> Void in
            if error != nil {
                 completion(results: ResultType.SystemError(e: error!))
                
            } else {
                self.fetchUserData(authData, completion: completion)

            }
        })
        sessionManagerFlags.openSession = true
    }
    
    override func login(userData: User?, completion: (results: ResultType) -> Void) {
        guard let user = userData,
            let email = userData?.email,
            let password = userData?.password else {
                 completion(results: ResultType.Error(e: EmailAccountManagerError.ReturnedEmptyUserObject))
                return
        }

        self.newUser = user

        if user.isNew {
            createUser(completion)

        } else {
            PFUser.logInWithUsernameInBackground(email, password: password) { (user, error) in
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
    
    func createUser(completion: (results: ResultType) -> Void) {
        guard let email = newUser?.email,
            let username = newUser?.username,
            let password = newUser?.password else {
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
            delegate?.accountManagerUserDidLogin(self, user: newUser)
        }
    }
}

enum EmailAccountManagerError: ErrorType {
    case MissingUserData
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}