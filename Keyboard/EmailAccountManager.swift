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
        guard let email = currentUser?.email,
            let password = currentUser?.password else {
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
    
    override func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard let user = userData,
            let email = userData?.email,
            let password = userData?.password,
            let username = userData?.username else {
                 completion(results: ResultType.Error(e: EmailAccountManagerError.ReturnedEmptyUserObject))
                return
        }

        currentUser = User()
        currentUser?.password = password
        currentUser?.email = email
        currentUser?.username = username

        if user.isNewUser {
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
        guard let email = currentUser?.email,
            let username = currentUser?.username,
            let password = currentUser?.password else {
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
        
        if let parseCurrentUser = PFUser.currentUser() {
            data["id"] = authData.uid
            data["email"] = parseCurrentUser.email
            data["phone"] = parseCurrentUser.objectForKey("phone") as? String
            data["username"] = parseCurrentUser.username
            data["displayName"] = parseCurrentUser.objectForKey("fullName") as? String
            data["name"] = parseCurrentUser.objectForKey("fullName") as? String
            data["parseId"] = parseCurrentUser.objectId
            data["backgroundImage"] = "user-profile-bg-\(arc4random_uniform(4) + 1)"

            currentUser?.setValuesForKeysWithDictionary(data)

            if let user = currentUser {
                self.userRef?.updateChildValues(data)
                completion(results: ResultType.Success(r: true))
                delegate?.accountManagerUserDidLogin(self, user: user)
            }
        }
    }
}

enum EmailAccountManagerError: ErrorType {
    case MissingUserData
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}