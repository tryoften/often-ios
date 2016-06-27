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

    override func openSession(_ completion: (results: ResultType) -> Void) {
        guard let email = currentUser?.email,
            let password = currentUser?.password else {
                completion(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))
                return
        }

        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                completion(results: ResultType.systemError(e: error!))

            } else {
                if let user = user {
                    self.fetchUserData(user, completion: completion)
                }
            }
        })

        sessionManagerFlags.openSession = true
    }
    
    override func login(_ userData: UserAuthData?, completion: AccountManagerResultCallback) {
        guard let user = userData,
            let email = userData?.email,
            let password = userData?.password,
            let username = userData?.username else {
                 completion(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))
                return
        }

        currentUser = User()
        currentUser?.password = password
        currentUser?.email = email
        currentUser?.username = username

        if user.isNewUser {
            createUser(completion)
        } else {
            PFUser.logInWithUsername(inBackground: email, password: password, block: handleParseUser(completion))
        }
    }
    
    func createUser(_ completion: AccountManagerResultCallback) {
        guard let email = currentUser?.email,
            let username = currentUser?.username,
            let password = currentUser?.password else {
                completion(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))
                return
        }
        
        let user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        user["fullName"] = username
        
        user.signUpInBackground { (success, error) in
            if error == nil {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        completion(results: ResultType.systemError(e: error!))
                    } else {
                        self.openSession(completion)
                    }
                })
            } else {
                completion(results: ResultType.systemError(e: error!))
            }
        }
    }

    override func fetchUserData(_ authData: FIRUser, completion: AccountManagerResultCallback) {
        userRef = firebase.child("users/\(authData.uid)")
        sessionManagerFlags.userId = authData.uid

        var data = [String : AnyObject]()

        if let parseCurrentUser = PFUser.current() {
            data["id"] = authData.uid
            data["email"] = parseCurrentUser.email
            data["phone"] = parseCurrentUser.object(forKey: "phone") as? String
            data["username"] = parseCurrentUser.username
            data["displayName"] = parseCurrentUser.object(forKey: "fullName") as? String
            data["name"] = parseCurrentUser.object(forKey: "fullName") as? String
            data["parseId"] = parseCurrentUser.objectId
            data["backgroundImage"] = "user-profile-bg-1"

            currentUser?.setValuesForKeys(data)

            if let user = currentUser {
                self.userRef?.updateChildValues(data)
                completion(results: ResultType.success(r: true))
                delegate?.accountManagerUserDidLogin(self, user: user)
            }

            self.initiateUserWithPacks()
        }
    }
}
