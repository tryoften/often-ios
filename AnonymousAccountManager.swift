//
//  AnonymousAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class AnonymousAccountManager: AccountManager {

  override func openSession(_ completion: (results: ResultType) -> Void) {
        FIRAuth.auth()!.signInAnonymously { (user, err) in
            if err != nil {
                completion(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))
            } else {
                if let user = user {
                    self.fetchUserData(user, completion: completion)
                }
            }
        }

        sessionManagerFlags.openSession = true
        sessionManagerFlags.userIsAnonymous = true
    }
    
    override func login(_ userData: UserAuthData?, completion: AccountManagerResultCallback)  {
        PFAnonymousUtils.logIn(handleParseUser(completion))
        initiateUserWithPacks()
    }

    override func fetchUserData(_ user: FIRUser, completion: AccountManagerResultCallback) {
        userRef = firebase.child("users/\(user.uid)")
        sessionManagerFlags.userId = user.uid
        
        var data = [String : AnyObject]()

        if let parseCurrentUser = PFUser.current() {
            data["id"] = user.uid
            data["parseId"] = parseCurrentUser.objectId
            data["isAnonymous"] = true

            currentUser = User()
            currentUser?.setValuesForKeys(data)

            if let user = self.currentUser {
                self.userRef?.updateChildValues(data)
                completion(results: ResultType.success(r: true))
                delegate?.accountManagerUserDidLogin(self, user: user)
            }

            self.initiateUserWithPacks()
        }
    }
}
