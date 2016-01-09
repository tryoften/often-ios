//
//  AnonymousAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class AnonymousAccountManager: AccountManager {
    var sessionManagerFlags: SessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    var firebase: Firebase
    var userRef: Firebase?
    weak var delegate: AccountManagerDelegate?
    var isInternetReachable: Bool
    var newUser: User?

    required init(firebase: Firebase) {
        self.firebase = firebase
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable

        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        reachabilitymanager.startMonitoring()
    }
    
    
   func openSession(completion: (results: ResultType) -> Void) {
        self.firebase.authAnonymouslyWithCompletionBlock { (err, auth) -> Void in
            if err != nil {
                print(err)
                completion(results: ResultType.Error(e: AnonymousAccountManagerError.ReturnedEmptyUserObject))
            } else {
                self.fetchUserData(auth, completion: completion)
            }
        }

        sessionManagerFlags.openSession = true
        sessionManagerFlags.userIsAnonymous = true
    }
    
    func login(userData: User?, completion: (results: ResultType) -> Void)  {
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                completion(results: ResultType.Error(e: AnonymousAccountManagerError.ReturnedEmptyUserObject))
            } else {
                 self.openSession(completion)
            }
        }
    }

    func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void) {
        userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        sessionManagerFlags.userId = authData.uid
        
        var data = [String : AnyObject]()

        if let currentUser = PFUser.currentUser() {
            data["id"] = authData.uid
            data["parseId"] = currentUser.objectId

            newUser = User()
            newUser?.setValuesForKeysWithDictionary(data)

            if let user = newUser {
                self.userRef?.updateChildValues(data)
                completion(results: ResultType.Success(r: true))
                delegate?.accountManagerUserDidLogin(self, user: user)
            }
        }
    }
}

enum AnonymousAccountManagerError: ErrorType {
    case ReturnedEmptyUserObject
}