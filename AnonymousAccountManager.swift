//
//  AnonymousAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class AnonymousAccountManager: AccountManager {

  override func openSession(completion: (results: ResultType) -> Void) {
        self.firebase.authAnonymouslyWithCompletionBlock { (err, auth) -> Void in
            if err != nil {
                print(err)
                completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
            } else {
                self.fetchUserData(auth, completion: completion)
            }
        }

        sessionManagerFlags.openSession = true
        sessionManagerFlags.userIsAnonymous = true
    }
    
    override func login(userData: UserAuthData?, completion: AccountManagerResultCallback)  {
        PFAnonymousUtils.logInWithBlock(handleParseUser(completion))
    }

    override func fetchUserData(authData: FAuthData, completion: AccountManagerResultCallback) {
        userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        sessionManagerFlags.userId = authData.uid
        
        var data = [String : AnyObject]()

        if let parseCurrentUser = PFUser.currentUser() {
            data["id"] = authData.uid
            data["parseId"] = parseCurrentUser.objectId
            data["isAnonymous"] = true

            currentUser = User()
            currentUser?.setValuesForKeysWithDictionary(data)

            if let user = self.currentUser {
                self.userRef?.updateChildValues(data)
                completion(results: ResultType.Success(r: true))
                delegate?.accountManagerUserDidLogin(self, user: user)
            }

            self.initiateUserWithPacks()
        }
    }
}