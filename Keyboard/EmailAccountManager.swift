//
//  EmailAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class EmailAccountManager: AccountManager {

    override func openSession(completion: (results: ResultType) -> Void) {
        guard let email = currentUser?.email,
            let password = currentUser?.password else {
                completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                return
        }

        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                completion(results: ResultType.SystemError(e: error!))

            } else {
                if let user = user {
                    self.fetchUserData(user, completion: completion)
                }
            }
        })

        sessionManagerFlags.openSession = true
    }
    
    override func login(userData: UserAuthData?, completion: AccountManagerResultCallback) {
        guard let user = userData,
            let email = userData?.email,
            let password = userData?.password,
            let username = userData?.name else {
                 completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                return
        }

        currentUser = User()
        currentUser?.password = password
        currentUser?.email = email
        currentUser?.username = username

        if user.isNewUser {
            createUser(completion)
        } else {
            PFUser.logInWithUsernameInBackground(email, password: password, block: handleParseUser(completion))
        }
    }
    
    func createUser(completion: AccountManagerResultCallback) {
        guard let email = currentUser?.email,
            let username = currentUser?.username,
            let password = currentUser?.password else {
                completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                return
        }
        
        let user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        user["fullName"] = username
        
        user.signUpInBackgroundWithBlock { (success, error) in
            if error == nil {
                FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                    if error != nil {
                        completion(results: ResultType.SystemError(e: error!))
                    } else {
                        self.openSession(completion)
                    }
                })
            } else {
                completion(results: ResultType.SystemError(e: error!))
            }
        }
    }

    override func fetchUserData(authData: FIRUser, completion: AccountManagerResultCallback) {
        userRef = firebase.child("users/\(authData.uid)")
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
            data["backgroundImage"] = "user-profile-bg-1"

            currentUser?.setValuesForKeysWithDictionary(data)

            if let user = currentUser {
                self.userRef?.updateChildValues(data)
                completion(results: ResultType.Success(r: true))
                delegate?.accountManagerUserDidLogin(self, user: user)
            }

            self.initiateUserWithPacks()
        }
    }
}