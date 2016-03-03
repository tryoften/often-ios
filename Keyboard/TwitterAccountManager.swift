//
//  TwitterAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import TwitterKit


class TwitterAccountManager: AccountManager {

    override func openSession(completion: (results: ResultType) -> Void) {
        guard let userId = Twitter.sharedInstance().sessionStore.session()?.userID, twitterToken = Twitter.sharedInstance().sessionStore.session()?.authToken else {
            completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
            return
        }
        
        let twitterAuth = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        twitterAuth.setValue([
            "task": "createToken",
            "user": "twitter:\(userId)",
            "data": ["token": twitterToken]
            ])
        
        userRef = firebase.childByAppendingPath("users/twitter:\(userId)")
        userRef?.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? [String: AnyObject] {
                    self.firebase.authWithCustomToken(value["auth_token"] as? String, withCompletionBlock: { (err, aut ) -> Void in
                        self.userRef?.removeAllObservers()
                        if err == nil {
                            self.fetchUserData(aut, completion: completion)
                        } else {
                             completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                        }
                    })
                    
                }
            }
        })
        
        sessionManagerFlags.openSession = true
    }
    
    override func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: AccountManagerError.NotConnectedOnline))
            return
        }

        Twitter.sharedInstance().logInWithCompletion { result, error in
            if error == nil {
                if result == nil {
                    completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                } else {
                    self.openSession(completion)
                }
            } else {
                self.logout()
                completion(results: ResultType.SystemError(e: error!))
            }

        }
    }
    
    override func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void) {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            client.loadUserWithID(userID) { (user, error) -> Void in
                if error == nil {
                    if user == nil {
                        completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                    } else {
                        var firebaseData = [String: AnyObject]()
                        firebaseData["id"] = authData.uid
                        firebaseData["profileImageURL"] = user?.profileImageLargeURL
                        firebaseData["name"] = user?.name
                        firebaseData["username"] = user?.screenName
                        firebaseData["backgroundImage"] = "user-profile-bg-1"

                        if self.sessionManagerFlags.userId == nil {
                            guard let userID = user?.userID  else {
                                completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                                return
                            }

                            self.sessionManagerFlags.userId =  "twitter:\(userID)"

                            self.currentUser = User()
                            self.currentUser?.setValuesForKeysWithDictionary(firebaseData)

                            if let user = self.currentUser {
                                self.userRef?.updateChildValues(user.dataChangedToDictionary())
                                completion(results: ResultType.Success(r: true))
                                self.delegate?.accountManagerUserDidLogin(self, user: user)
                            }
                        }
                    }
                }
            }
        }
    }

}
